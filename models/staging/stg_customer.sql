-- Staging: one row per customer, renamed + typed, with vault metadata.
-- On load_batch 2, a few customers get changed attributes from the seed,
-- simulating a second delivery from the source system.
--
-- The source + load-2 CTEs are done for you. Read them until you can explain
-- the if/else Jinja block: it is the whole "second load" simulation.

with source as (

    select
        c_custkey    as customer_id,
        c_name       as customer_name,
        c_address    as address,
        c_nationkey  as nation_id,
        c_phone      as phone,
        c_acctbal    as account_balance,
        c_mktsegment as market_segment
    from {{ source('tpch', 'customer') }}

),

{% if var('load_batch') | int == 2 %}
changes as (
    select * from {{ ref('customer_changes_load2') }}
),

current_delivery as (
    select
        s.customer_id,
        s.customer_name,
        s.address,
        s.nation_id,
        coalesce(c.phone, s.phone)                     as phone,
        -- the cast matters: see seeds/_seeds.yml for why
        cast(coalesce(c.account_balance, s.account_balance) as number(12, 2)) as account_balance,
        coalesce(c.market_segment, s.market_segment)   as market_segment
    from source as s
    left join changes as c
        on s.customer_id = c.customer_id
)
{% else %}
current_delivery as (
    select * from source
)
{% endif %}

-- TODO: final select from current_delivery. Output columns, in order:
--   customer_hk         hash of the business key
--   customer_hashdiff   hash of ALL descriptive columns (everything except the key)
--   customer_id ... market_segment   (the 7 columns above)
--   load_date           which load this row belongs to
--   record_source       a literal naming the source table, e.g. 'TPCH.CUSTOMER'
--
-- Clue 1: {{ hash_key(['customer_id']) }} as customer_hk
-- Clue 2: the hashdiff takes six columns. If you leave one out, changes to
--         that column will never create a new satellite row.
-- Clue 3: there's a macro for load_date already: {{ load_date() }}
-- Done when: dbt build -s stg_customer passes (unique + not_null on customer_hk).

select 1 as todo_remove_me from current_delivery limit 0
