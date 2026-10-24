-- Staging: one row per order, limited to the configured date window.

with source as (

    select
        o_orderkey      as order_id,
        o_custkey       as customer_id,
        o_orderstatus   as order_status,
        o_totalprice    as total_price,
        o_orderdate     as order_date,
        o_orderpriority as order_priority
    from {{ source('tpch', 'orders') }}
    -- TODO: keep only orders between var('order_date_start') and var('order_date_end')
    -- Clue: where o_orderdate between '{{ var("order_date_start") }}' and '...'

)

-- TODO: final select. This one table feeds THREE vault objects, so it needs:
--   order_hk            hash of order_id                       -> hub_order
--   customer_hk         hash of customer_id                    -> hub_customer
--   order_customer_hk   hash of (order_id, customer_id)        -> link_order_customer
--   order_hashdiff      hash of status, total_price, order_date, priority -> sat_order
--   the 6 business columns, load_date, record_source ('TPCH.ORDERS')
--
-- Clue: customer_hk here MUST be built exactly like customer_hk in stg_customer.
--       Same macro, same single column. That's what makes the hub join work.

select 1 as todo_remove_me from source limit 0
