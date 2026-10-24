-- Satellite: descriptive attributes of part, with full history.
--
-- TODO: copy the pattern from sat_order.sql.
-- Change: the ref, the parent key (part_hk), the hashdiff column, the attribute list.
-- Attributes = exactly the columns that went into part_hashdiff in stg_part.


select 1 as todo_remove_me
