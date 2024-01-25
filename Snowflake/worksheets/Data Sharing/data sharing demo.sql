CREATE DATABASE to_share;
USE database to_share;
 
create table customer as
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;

CREATE or REPLACE share sales_s;
create or replace share sales_demodb;

GRANT UsaGE ON DATABASE to_Share to share sales_s;
GRANT usage on schema to_share.public to share sales_s;
GRant all on table to_share.public.customer to share sales_s;
show grants to share sales_s;

GRANT all ON database demo_db to share sales_demodb;
show grants to share sales_demodb;
ALTER SHARE sales_s add accounts=wwb21273;
ALTER SHARE sales_demodb add accounts=wwb21273;

DESC SHARE sales_s;
show shares;
show grants;
-- revoke usage on database to_share to share sales_s;
create secure view sec_view as select 1 as one;
show views;
grant usage on database to_share to role useradmin;
grant usage on schema to_share.public to role useradmin;
grant select on view to_share.public.sec_view to useradmin;
show grants to role useradmin;