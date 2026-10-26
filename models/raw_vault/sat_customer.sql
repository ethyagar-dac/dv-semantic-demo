-- Satellite: descriptive attributes of customer, with full history.
-- Insert a row only when the hashdiff differs from the latest row we hold
-- for that key. Unchanged records are skipped; changes become new versions.

with source as (

    select
        customer_hk,
        customer_hashdiff as hashdiff,
        customer_name,
        address,
        nation_id,
        phone,
        account_balance,
        market_segment,
        load_date,
        record_source
    from {{ ref('stg_customer') }}

)

{% if is_incremental() %}
, latest as (

    select customer_hk, hashdiff
    from {{ this }}
    qualify row_number() over (partition by customer_hk order by load_date desc) = 1

)
{% endif %}

select source.*
from source
{% if is_incremental() %}
left join latest
    on source.customer_hk = latest.customer_hk
where latest.hashdiff is null              -- new key
   or latest.hashdiff <> source.hashdiff   -- changed attributes
{% endif %}
