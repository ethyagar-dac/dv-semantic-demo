-- Link: which customer placed which order. Insert-only.
--
-- TODO: columns order_customer_hk, order_hk, customer_hk, load_date, record_source,
-- from stg_orders. Pattern is the same as a hub; the "key" is order_customer_hk.
--
-- Interview question: TPC-H has exactly one customer per order. Why model this as a
-- link instead of putting customer_hk on the order satellite?
-- (Think: what happens when a second source disagrees, or the business rule changes?)

select 1 as todo_remove_me
