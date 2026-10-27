-- Run once in a Snowsight worksheet as ACCOUNTADMIN.
-- Creates an isolated role, warehouse, database and a key-pair service user for dbt.
-- Key-pair auth avoids password + MFA prompts on every dbt run.

use role accountadmin;

-- 1. Compute: smallest size, suspends after 60s idle to save trial credits
create warehouse if not exists dv_demo_wh
    warehouse_size = xsmall
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true;

-- 2. Storage
create database if not exists dv_demo;

-- 2b. Sample data. Most accounts already have SNOWFLAKE_SAMPLE_DATA.
--     If `show databases like 'SNOWFLAKE_SAMPLE_DATA';` returns nothing, run:
-- create database snowflake_sample_data from share sfc_samples.sample_data;

-- 3. Role with only what dbt needs
create role if not exists dv_demo_role;
grant usage on warehouse dv_demo_wh to role dv_demo_role;
grant all on database dv_demo to role dv_demo_role;
grant imported privileges on database snowflake_sample_data to role dv_demo_role;
grant role dv_demo_role to role sysadmin;

-- 4. Service user for dbt. Paste your PUBLIC key (one line, no BEGIN/END lines).
--    Generate the key pair on your Mac first - see README "Setup".
create user if not exists dbt_svc
    type = service
    default_role = dv_demo_role
    default_warehouse = dv_demo_wh
    rsa_public_key = '<PASTE_PUBLIC_KEY_HERE>';
grant role dv_demo_role to user dbt_svc;

-- 5. Optional guardrail: cap spend on this warehouse
create resource monitor if not exists dv_demo_monitor
    with credit_quota = 20
    triggers on 90 percent do suspend;
alter warehouse dv_demo_wh set resource_monitor = dv_demo_monitor;

-- Your account identifier for .env:
select current_organization_name() || '-' || current_account_name() as snowflake_account;
