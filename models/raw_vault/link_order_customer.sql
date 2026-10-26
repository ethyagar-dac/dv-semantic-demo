-- Link: which customer placed which order. Insert-only.
-- Modelled as a link (not a foreign key on the order) so that if the
-- relationship ever changes or a second source disagrees, nothing is remodelled.

select distinct
    order_customer_hk,
    order_hk,
    customer_hk,
    load_date,
    record_source
from {{ ref('stg_orders') }} as src
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} as lnk
    where lnk.order_customer_hk = src.order_customer_hk
)
{% endif %}
