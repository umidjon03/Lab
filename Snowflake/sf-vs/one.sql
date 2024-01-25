select current_organization_name();

SELECT c1::string st
from (values (1)) as num (c1);


SELECT id, table_name, table_catalog, clone_group_id, active_bytes, time_travel_bytes, failsafe_bytes
fRom snowflake.information_schema.table_storage_metrics; -- account_usage.table_storage_metrics;

CREATE table call2 clone db1.public.call;
CREATE table call3 clone db1.public.call2;

SELECT * from 
snowflake.information_schema.table_storage_metrics;

use db1;
SELECT * FROM call2 limit 1;
update call2
set CC_CALL_CENTER_SK=2
where cc_call_center_id = 'AAAAAAAABAAAAAAA';

create table call4 clone call2 ;


insert into call3 (cc_call_center_id)
select left(cc_call_center_id, 1)||'1' from call;

select * FROM call3;




SELECT * FROM call2;
SELECT * FROM call2;

SELECT * fRoM call3;


seLeCT * fROM call3;


use role sysadmin;
select current_database();
show tables;


use role accountadmin;

grant usage on database db1 to role sysadmin;
grant select on table call to role sysadmin;

use role sysadmin;

seLECt * from call;

select current_session();

SELECT * froM 
table(result_scan('01b09c81-0604-d7d8-0002-0e6f0002b0da'));