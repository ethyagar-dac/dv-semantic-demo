-- Dimension: one row per part, current attribute values.

with current_sat as (

    select *
    from {{ ref('sat_part') }}
    qualify row_number() over (partition by part_hk order by load_date desc) = 1

)

select
    hub.part_hk,
    hub.part_id,
    sat.part_name,
    sat.manufacturer,
    sat.brand,
    sat.part_type,
    sat.part_size,
    sat.retail_price
from {{ ref('hub_part') }} as hub
left join current_sat as sat
    on hub.part_hk = sat.part_hk
