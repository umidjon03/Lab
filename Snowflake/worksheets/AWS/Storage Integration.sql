CREATE OR REPLACE STORAGE INTEGRATION s3_int
type = external_stage
storage_provider = s3
enabled = true
storage_aws_role_arn = 'arn:aws:iam::552582972300:role/snowflake_s3_role'
storage_allowed_locations = ('s3://snowflake-mejohn/emp/');

DESC INTEGRATION s3_int;

ALTER FILE FORMAT control_db.file_formats.csv_format
SET COMPRESSION = AUTO;
DESC FILE FORMAT control_db.file_formats.csv_format;


CREATE OR REPLACE STAGE control_db.external_stages.s3_stage
storage_integration = s3_int
url = 's3://snowflake-mejohn/emp/'
file_format = control_db.file_formats.csv_format;

desc STAGE control_db.external_stages.s3_stage;


SELECT t.$1 AS f_name,
    t.$2 AS l_name,
    t.$3 email
FROM @CONTROL_DB.external_stages.s3_stage t;

-- with external staging we can
-- apply where filter
-- use joins
-- create views
-- create table by CTAS
-- transform data
