-- WORKED EXAMPLE. Read this before writing hub_part and hub_customer.
-- Can you say why `distinct` is safe here, and what `is_incremental()` is false on?

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
