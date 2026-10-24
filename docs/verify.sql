-- Run in Snowsight after load 2 to see the vault doing its job.

-- 1. Customers 1-5 should each have TWO satellite rows (Jan and Feb load dates).
--    Everyone else should have one.
select customer_hk, load_date, market_segment, account_balance, hashdiff
from dv_demo.raw_vault.sat_customer
where customer_hk in (select customer_hk from dv_demo.raw_vault.hub_customer where customer_id <= 5)
order by customer_hk, load_date;

-- 2. Satellite row counts by load date: load 2 should have added exactly 5 rows.
select load_date, count(*) as rows_inserted
from dv_demo.raw_vault.sat_customer
group by load_date
order by load_date;

-- 3. Hubs are insert-only: load 2 should have added zero new customers.
select load_date, count(*) from dv_demo.raw_vault.hub_customer group by load_date;

-- 4. The dimension shows only the current value.
select customer_id, market_segment, account_balance, attributes_as_of
from dv_demo.marts.dim_customer
where customer_id <= 5
order by customer_id;
