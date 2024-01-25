CREATE DATABASE snowpipe;
USE database SNOWpipe;

CREATE or replace STORAGE INTEGRATIon snowpipe_int
type = external_stage
storage_provider = s3
enabled=true
storage_aws_role_arn = 'arn:aws:iam::552582972300:role/snowflake_s3_role'
STORAGE_ALLOWED_LOCATIONS = ('s3://snowpipe-mejohn/');

dESC STORAGE INTEGration snowpipe_int;

CREATE OR REPLACE desc stage snowpipe_stage
storage_integration = snowpipe_int
url = 's3://snowpipe-mejohn/'
file_format = control_db.file_formats.csv_format;

create or replace table emp_snowpipe (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

CREATE OR REPLACE PIPE snowpipe
auto_ingest=true
as
COPY INTO emp_snowpipe
FROM @snowpipe_stage;

CREATE OR REPLACE PIPE snowpipe
auto_ingest=true
as
COPY INTO emp_snowpipe
FROM @snowpipe_stage;

show pipes;
desc pipe snowpipe;

SELECT * FROM emp_snowpipe;
truncate table emp_snowpipe;
ALTER PIPE snowpipe refresh;

-- validating pipe
SELECT SYSTEM$pipe_status('snowpipe');

SELECT *
FROM table(VALIDATE_PIPE_LOAD(pipe_name=>'snowpipe.public.snowpipe', start_time=>dateadd(hours, -3, current_timestamp())));
