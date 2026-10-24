-- Dimension: one row per customer, CURRENT attribute values (type 1).
-- History stays in sat_customer; this only shows the latest version.
--
-- TODO:
--   1. CTE current_sat: the latest sat_customer row per customer_hk
--   2. hub_customer LEFT JOIN current_sat on customer_hk
--   3. columns: customer_hk, customer_id, customer_name, nation_id,
--      market_segment, account_balance, sat.load_date as attributes_as_of
--
-- Clue 1: "latest row per key" = qualify row_number() over (partition by ... order by load_date desc) = 1
-- Clue 2: why LEFT join from the hub? Some customer keys came only from orders
--         and may have no satellite row. (Do they, in TPC-H? Worth checking.)
-- Interview question: how would you make this type 2 instead? (valid_from / valid_to
-- from the satellite's load_date and lead() over the next version.)

select 1 as todo_remove_me
