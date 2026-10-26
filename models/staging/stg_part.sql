-- Staging: one row per part.

with source as (

    select
        p_partkey     as part_id,
        p_name        as part_name,
        p_mfgr        as manufacturer,
        p_brand       as brand,
        p_type        as part_type,
        p_size        as part_size,
        p_retailprice as retail_price
    from {{ source('tpch', 'part') }}

)

select
    {{ hash_key(['part_id']) }} as part_hk,
    {{ hash_key(['part_name', 'manufacturer', 'brand', 'part_type', 'part_size', 'retail_price']) }} as part_hashdiff,
    part_id,
    part_name,
    manufacturer,
    brand,
    part_type,
    part_size,
    retail_price,
    {{ load_date() }} as load_date,
    'TPCH.PART'       as record_source
from source
