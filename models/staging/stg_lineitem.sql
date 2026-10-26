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
        on l.l_orderkey = o.order_id

)

select
    {{ hash_key(['order_id', 'part_id', 'line_number']) }} as order_line_hk,
    {{ hash_key(['order_id']) }}                           as order_hk,
    {{ hash_key(['part_id']) }}                            as part_hk,
    {{ hash_key(['quantity', 'extended_price', 'discount', 'return_flag', 'ship_date']) }} as order_line_hashdiff,
    order_id,
    part_id,
    line_number,
    quantity,
    extended_price,
    discount,
    return_flag,
    ship_date,
    {{ load_date() }} as load_date,
    'TPCH.LINEITEM'   as record_source
from source
