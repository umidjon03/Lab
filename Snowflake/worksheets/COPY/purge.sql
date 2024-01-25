 create or replace table demo_db.public.emp2 (
         first_name varchar(10) ,
         last_name varchar(10) ,
         email varchar(10) ,
         streetaddress varchar(10) ,
         city varchar(10) ,
         start_date date
);

USE database DEMO_DB;

COPY INTO emp2
FROM @control_db.external_stages.s3_stage
-- FILES = ('employees_error_file0.csv')
truncatecolumns=true
FORCE=true
on_error='continue'
PURGE=true; --  if purge=true, when a file is loaded to Snowflake, the file will be immidiately deleted from the stage

-- NOTE!!!!!!!!!!!!!
-- purge deletes file, even if the file is PARTIALLY_LOADED