--- STEP 1:

CREATE SCHEMA MV

CREATE OR REPLACE TRANSIENT TABLE CALL_CENTER as 
select * from
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER

select * from
CALL_CENTER   -- 60 records

create or replace materialized view call_center_M_view
as
select * from
CALL_CENTER

select * from
call_center_M_view   -- 60 records

select * from table(information_schema.materialized_view_refresh_history());

SHOW MATERIALIZED VIEWS LIKE 'call_center_M_view' -- -- observe behind_by column

select 0.000839473+0.001810528

--- STEP 2:

delete from CALL_CENTER where cc_call_center_sk=4

SHOW MATERIALIZED VIEWS LIKE 'call_center_M_view'  -- observe behind_by column

/*........
........ Wait for some time*/

select 60+59 =119

select * from call_center_M_view  -- still 59 records

select * from table(information_schema.materialized_view_refresh_history());--- It will start to refresh

show tables like 'call_center'

SHOW MATERIALIZED VIEWS LIKE 'call_center_M_view'


--- STEP 3 :


SHOW MATERIALIZED VIEWS LIKE 'call_center_M_view' -- Behind by timestamp will be updated to last extraction from main table.
  
  -- Records counts will show as 59 instead of 119
  
 ----Observations-------
 -- I ran delete clause and i have not executed select on materialized view.
 
 -- Through this investigation we made, i believe you have a better understanding about how materialized view
 -- may operates under the hood.
 
 -- Let's try to draw few observations,
 
 -- Once data is changed in main table , changed data will be pulled to the matirailized table.
 
 -- If underlying data has changed, 
 -- if you execute select quey on materialized view there will be a refreshing cost.
 
 -- Why these overvatons are importent ? 
 
 
 
 
 
-- Remember :

             -- Once we update main table refreshing service will start