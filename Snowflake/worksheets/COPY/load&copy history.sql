-- load history

USE DATABASE DEMO_DB;
-- limit of the view: recent 14 days and max 10,000 rows
SELECT * FROM INFoRmation_SCHEMA.load_history
order by last_load_time desc;

-- copy history
-- parent view of load history
-- copy history gives more info about the copy (more columns)
SELECT * 
FROM TABLE(information_schema.copy_history(table_name=>'demo_db.public.emp', start_time=>dateadd(hours, -48, current_timestamp())));

-- Global history

-- in Snowflake db -> account_usage -> copy_history / load_history views
-- retrieve recent 1 year history
-- need for account admin privilage