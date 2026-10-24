-- WORKED EXAMPLE. Read this before writing the other three satellites.
-- Trace it twice: once for the first run (is_incremental() false),
-- once for load 2 (true). What does `latest` contain on load 2?

-- Satellite: descriptive attributes of order, with full history.
-- Insert a row only when the hashdiff differs from the latest row we hold
-- for that key. Unchanged records are skipped; changes become new versions.

with source as (

    select
        order_hk,
        order_hashdiff as hashdiff,
        order_status,
        total_price,
        order_date,
        order_priority,
        load_date,
        record_source
    from {{ ref('stg_orders') }}

)

{% if is_incremental() %}
, latest as (

    select order_hk, hashdiff
    from {{ this }}
    qualify row_number() over (partition by order_hk order by load_date desc) = 1

)
{% endif %}

select source.*
from source
{% if is_incremental() %}
left join latest
    on source.order_hk = latest.order_hk
where latest.hashdiff is null              -- new key
   or latest.hashdiff <> source.hashdiff   -- changed attributes
{% endif %}
