-- Hub: unique part business keys. Insert-only.
--
-- TODO: same pattern as hub_order.sql, for parts.
-- Columns: part_hk, part_id, load_date, record_source
-- Done when: dbt build -s hub_part passes, and running it a second time inserts 0 rows.

select 1 as todo_remove_me
