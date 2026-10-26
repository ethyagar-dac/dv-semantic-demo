-- Dimension: one row per customer, current attribute values only (SCD type 1 view
-- of the vault). History stays in sat_customer; a type 2 dimension could be built
-- from the same satellite by keeping every version with valid_from / valid_to.

with current_sat as (

    select *
    from {{ ref('sat_customer') }}
    qualify row_number() over (partition by customer_hk order by load_date desc) = 1

)

select
    hub.customer_hk,
    hub.customer_id,
    sat.customer_name,
    sat.nation_id,
    sat.market_segment,
    sat.account_balance,
    sat.load_date as attributes_as_of
from {{ ref('hub_customer') }} as hub
left join current_sat as sat
    on hub.customer_hk = sat.customer_hk
