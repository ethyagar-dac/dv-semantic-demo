-- Hub: unique order business keys. Insert-only.

select distinct
    order_hk,
    order_id,
    load_date,
    record_source
from {{ ref('stg_orders') }} as src
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} as hub
    where hub.order_hk = src.order_hk
)
{% endif %}
