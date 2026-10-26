-- Fact: one row per order line. Grain = order_id + line_number.
-- Stores additive facts only (quantity, gross and net revenue).
-- Averages and ratios are NOT stored here; they belong in the semantic layer.

with line_sat as (
    select *
    from {{ ref('sat_order_line') }}
    qualify row_number() over (partition by order_line_hk order by load_date desc) = 1
),

order_sat as (
    select *
    from {{ ref('sat_order') }}
    qualify row_number() over (partition by order_hk order by load_date desc) = 1
)

select
    lnk.order_line_hk,
    lnk.order_hk,
    loc.customer_hk,
    lnk.part_hk,
    hub_o.order_id,
    lnk.line_number,
    order_sat.order_date,
    order_sat.order_status,
    line_sat.quantity,
    line_sat.extended_price                         as gross_revenue,
    line_sat.discount,
    line_sat.extended_price * (1 - line_sat.discount) as net_revenue
from {{ ref('link_order_line') }} as lnk
inner join {{ ref('hub_order') }} as hub_o
    on lnk.order_hk = hub_o.order_hk
inner join {{ ref('link_order_customer') }} as loc
    on lnk.order_hk = loc.order_hk
inner join line_sat
    on lnk.order_line_hk = line_sat.order_line_hk
inner join order_sat
    on lnk.order_hk = order_sat.order_hk
