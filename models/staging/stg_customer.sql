-- Staging: one row per customer, renamed + typed, with vault metadata.
-- On load_batch 2, a few customers get changed attributes from the seed,
-- simulating a second delivery from the source system.

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

select
    {{ hash_key(['customer_id']) }} as customer_hk,
    {{ hash_key(['customer_name', 'address', 'nation_id', 'phone', 'account_balance', 'market_segment']) }} as customer_hashdiff,
    customer_id,
    customer_name,
    address,
    nation_id,
    phone,
    account_balance,
    market_segment,
    {{ load_date() }} as load_date,
    'TPCH.CUSTOMER'   as record_source
from current_delivery
