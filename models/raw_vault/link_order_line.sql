-- Link: an order line connects an order to a part.
-- line_number is a dependent child key: part of the link's hash, no hub of its own.
--
-- TODO: columns order_line_hk, order_hk, part_hk, line_number, load_date, record_source,
-- from stg_lineitem. Insert-only, same not-exists pattern.

select 1 as todo_remove_me
