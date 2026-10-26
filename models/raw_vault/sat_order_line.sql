-- Satellite: descriptive attributes of an order line (a link satellite), with full history.
-- Insert a row only when the hashdiff differs from the latest row we hold
-- for that key. Unchanged records are skipped; changes become new versions.

with source as (

    select
        order_line_hk,
        order_line_hashdiff as hashdiff,
        quantity,
        extended_price,
        discount,
        return_flag,
        ship_date,
        load_date,
        record_source
    from {{ ref('stg_lineitem') }}

)

{% if is_incremental() %}
, latest as (

    select order_line_hk, hashdiff
    from {{ this }}
    qualify row_number() over (partition by order_line_hk order by load_date desc) = 1

)
{% endif %}

select source.*
from source
{% if is_incremental() %}
left join latest
    on source.order_line_hk = latest.order_line_hk
where latest.hashdiff is null              -- new key
   or latest.hashdiff <> source.hashdiff   -- changed attributes
{% endif %}
