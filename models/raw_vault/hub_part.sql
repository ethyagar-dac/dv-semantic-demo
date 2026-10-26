-- Hub: unique part business keys. Insert-only.

select distinct
    part_hk,
    part_id,
    load_date,
    record_source
from {{ ref('stg_part') }} as src
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} as hub
    where hub.part_hk = src.part_hk
)
{% endif %}
