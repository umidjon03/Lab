 create or replace table demo_db.public.emp (
         first_name varchar(10) ,
         last_name varchar(10) ,
         email varchar(10) ,
         streetaddress varchar(10) ,
         city varchar(10) ,
         start_date varchar(10)
);
USE DATABASE DEMO_DB;

COPY INTO emp
FROM @control_db.external_stages.s3_stage
TRUNCATECOLUMNS = true -- edits the error column to fit to the assigned data type (someany@gmail.com -> someany@gm)
-- ENFORCE_LENGTH = false; -- if it set false do the same thing: substring record. And if source table has extra columns Snowflake ignores the error
ON_ERROR = 'continue'
FORCE = true -- Snowflake does not check any metadata and load data anyways (eventhough it is loaded recently)
;
SELECT * FROM emp;
TRUNCATE TABLE emp;
DESC STAGE control_db.external_stages.s3_stage;