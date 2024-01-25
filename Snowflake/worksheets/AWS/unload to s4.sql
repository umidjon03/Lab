-- NOTE!!!!--
-- To unload big data to external stage, it is recommended to use dedicated virtual warehouse


CREATE OR REPLACE FILE FORMAT control_db.file_formats.csv_compress_format
compression = gzip
type = csv
null_if = ('NULL', 'null');

ALTER STORAGE INTEGRATION s3_int
SET STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-mejohn/unload/', 's3://snowflake-mejohn/emp/');

CREATE OR REPLACE STAGE control_db.external_stages.s3_unload_stage
STORAGE_INTEGRATION = s3_int
URL = 's3://snowflake-mejohn/unload/'
FILE_FORMAT = control_db.file_formats.csv_compress_format;

COPY INTO @control_db.external_stages.s3_unload_stage
FROM demo_db.public.ext_emp_table
overwrite=true;

DESC STORAGE INTEGRATION s3_int;
DESC STAGE control_db.external_stages.s3_unload_stage;

COPY INTO @control_db.external_stages.s3_unload_stage/emails
FROM (SELECT email FROM demo_db.public.ext_emp_table)
overwrite=true;