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

-- TODO: final select with part_hk, part_hashdiff (6 descriptive columns),
-- the 7 business columns, load_date, record_source ('TPCH.PART').
-- This is the simplest staging model. Do it first, right after the macro.

select 1 as todo_remove_me from source limit 0
