-- Satellite: descriptive attributes of customer, with full history.
--
-- TODO: copy the pattern from sat_order.sql.
-- Change: the ref, the parent key (customer_hk), the hashdiff column, the attribute list.
-- Attributes = exactly the columns that went into customer_hashdiff in stg_customer.
--
-- This is the satellite that proves the vault works. After load 2, customers 1-5
-- must have two rows each and every other customer one. Check with docs/verify.sql.
-- If EVERY customer got a second row, your hashdiff isn't stable between loads -
-- see seeds/_seeds.yml.

select 1 as todo_remove_me
