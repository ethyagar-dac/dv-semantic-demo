-- Hub: the unique list of customer business keys, and when each was first seen.
-- Insert-only: existing keys are never updated.
--
-- Twist vs hub_order: customer keys arrive from TWO sources -
-- stg_customer AND stg_orders (o_custkey). The hub must take both, so an order
-- can never point at a customer the hub doesn't know.
--
-- TODO:
--   1. CTE all_keys: union all of (customer_hk, customer_id, load_date, record_source)
--      from stg_customer and from stg_orders
--   2. CTE first_seen: one row per customer_hk - the earliest one
--   3. final select from first_seen, with the same not-exists filter as hub_order
--
-- Clue 1: `distinct` alone won't work - record_source differs between the two feeds,
--         so the same key would appear twice.
-- Clue 2: Snowflake's QUALIFY filters on a window function without a subquery:
--           qualify row_number() over (partition by customer_hk order by load_date, record_source) = 1
-- Done when: unique test on customer_hk passes.

select 1 as todo_remove_me
