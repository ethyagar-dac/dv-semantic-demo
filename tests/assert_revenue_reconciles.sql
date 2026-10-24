-- Singular test: returns rows only when something is wrong.
-- Proves net revenue in the fact equals net revenue computed straight from source
-- for the same order window - nothing dropped or duplicated through the vault.
--
-- TODO:
--   CTE source_total: sum(l_extendedprice * (1 - l_discount)) from source lineitem
--                     joined to source orders, filtered to the order_date vars
--   CTE fact_total:   sum(net_revenue) from fct_order_lines
--   select both totals, cross join, where abs(difference) > 0.01
--
-- Clue: use {{ source('tpch', 'lineitem') }} - deliberately bypass your own models,
--       otherwise you're checking your work against itself.

select 1 as todo_remove_me where false
