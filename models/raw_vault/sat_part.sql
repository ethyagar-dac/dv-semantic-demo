-- Satellite: descriptive attributes of part, with full history.
-- Insert a row only when the hashdiff differs from the latest row we hold
-- for that key. Unchanged records are skipped; changes become new versions.

with source as (

    select
        part_hk,
        part_hashdiff as hashdiff,
        part_name,
        manufacturer,
        brand,
        part_type,
        part_size,
        retail_price,
        load_date,
        record_source
    from {{ ref('stg_part') }}

)

{% if is_incremental() %}
, latest as (

    select part_hk, hashdiff
    from {{ this }}
    qualify row_number() over (partition by part_hk order by load_date desc) = 1

)
{% endif %}

select source.*
from source
{% if is_incremental() %}
left join latest
    on source.part_hk = latest.part_hk
where latest.hashdiff is null              -- new key
   or latest.hashdiff <> source.hashdiff   -- changed attributes
{% endif %}
