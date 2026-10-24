-- Staging: one row per order line, for orders in the configured date window.
-- line_number is a dependent child key: it only means something inside its order.

with orders as (
    select order_id from {{ ref('stg_orders') }}
),

source as (

    select
        l.l_orderkey      as order_id,
        l.l_partkey       as part_id,
        l.l_linenumber    as line_number,
        l.l_quantity      as quantity,
        l.l_extendedprice as extended_price,
        l.l_discount      as discount,
        l.l_returnflag    as return_flag,
        l.l_shipdate      as ship_date
    from {{ source('tpch', 'lineitem') }} as l
    inner join orders as o
        on l.l_orderkey = o.order_id   -- only lines for orders in the date window

)

-- TODO: final select with
--   order_line_hk        hash of (order_id, part_id, line_number)  -> link_order_line
--   order_hk             hash of order_id                          -> joins to hub_order
--   part_hk              hash of part_id                           -> joins to hub_part
--   order_line_hashdiff  hash of quantity, extended_price, discount, return_flag, ship_date
--   the 8 business columns, load_date, record_source ('TPCH.LINEITEM')
--
-- Think: why does line_number go INTO the link's hash key?
-- (Hint: can the same part appear twice in one order?)

select 1 as todo_remove_me from source limit 0
