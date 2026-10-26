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
    where o_orderdate between '{{ var("order_date_start") }}' and '{{ var("order_date_end") }}'

)

select
    {{ hash_key(['order_id']) }}                as order_hk,
    {{ hash_key(['customer_id']) }}             as customer_hk,
    {{ hash_key(['order_id', 'customer_id']) }} as order_customer_hk,
    {{ hash_key(['order_status', 'total_price', 'order_date', 'order_priority']) }} as order_hashdiff,
    order_id,
    customer_id,
    order_status,
    total_price,
    order_date,
    order_priority,
    {{ load_date() }} as load_date,
    'TPCH.ORDERS'     as record_source
from source
