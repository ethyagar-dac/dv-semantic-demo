with source_total as (
    select sum(l.l_extendedprice * (1 - l.l_discount)) as revenue
    from {{ source('tpch', 'lineitem') }} as l
    inner join {{ source('tpch', 'orders') }} as o
        on l.l_orderkey = o.o_orderkey
    where o.o_orderdate between '{{ var("order_date_start") }}' and '{{ var("order_date_end") }}'
),

fact_total as (
    select sum(net_revenue) as revenue
    from {{ ref('fct_order_lines') }}
)

select
    source_total.revenue as source_revenue,
    fact_total.revenue   as fact_revenue
from source_total
cross join fact_total
where abs(source_total.revenue - fact_total.revenue) > 0.01