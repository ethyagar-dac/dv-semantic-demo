-- Link: an order line connects an order to a part.
-- line_number is a dependent child key: it is part of the link's hash key
-- (the same part can appear twice in one order) but has no hub of its own.

select distinct
    order_line_hk,
    order_hk,
    part_hk,
    line_number,
    load_date,
    record_source
from {{ ref('stg_lineitem') }} as src
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} as lnk
    where lnk.order_line_hk = src.order_line_hk
)
{% endif %}
