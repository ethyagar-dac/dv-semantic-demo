-- Hub: the unique list of customer business keys, and when each was first seen.
-- Customers can arrive from two sources (the customer table and orders),
-- so the hub is fed from both. Insert-only: existing keys are never updated.

with all_keys as (

    select customer_hk, customer_id, load_date, record_source
    from {{ ref('stg_customer') }}

    union all

    select customer_hk, customer_id, load_date, record_source
    from {{ ref('stg_orders') }}

),

first_seen as (

    select *
    from all_keys
    qualify row_number() over (partition by customer_hk order by load_date, record_source) = 1

)

select customer_hk, customer_id, load_date, record_source
from first_seen as src
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} as hub
    where hub.customer_hk = src.customer_hk
)
{% endif %}
