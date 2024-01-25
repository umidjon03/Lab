-- NOTE!!!!!!!!!!!      Loading .zip copressed files to snowflake is nor possible

CREATE OR REPLACE TABLE demo_db.public.ext_emp_table
LIKE demo_db.public.emp_basic_local;

CREATE OR REPLACE TABLE demo_db.public.ext_emp_table2
as 
SELECT first_name, last_name, email, start_date
FROM demo_db.public.emp_basic_local;

SELECT * FROM demo_db.public.ext_emp_table;
TRUNCATE TABLE demo_db.public.ext_emp_table;
DELETE FROM demo_db.public.ext_emp_table;

COPY INTO demo_db.public.ext_emp_table
FROM (SELECT split_part(metadata$filename, '/', 2), 0, $1, $2, $3, $4, $5, $6 FROM @control_db.external_stages.s3_stage)
FILE_FORMAT = control_db.file_formats.csv_format
PATTERN = '.*employees0[1-5].csv'
ON_ERROR =   CONTINUE;

COPY INTO demo_db.public.ext_emp_table2
FROM (SELECT $1, $2, $3, $6 FROM @control_db.external_stages.s3_stage)
FILE_FORMAT = control_db.file_formats.csv_format
-- PATTERN = '.*employees0[1-5].csv'
ON_ERROR =   CONTINUE;

-- printing the all rejected records
SELECT * FROM table(VALIDATE(ext_emp_table2, JOB_ID=>'01afb015-0404-c8ad-0001-434b000251b2'));


----- NOTE!!!!!!!!!!!!!!!!!!!!!!!!!!!-----
-- If the select invoilves default or metadata, it will be cause not to be included in the "error list", it is not gonna be appeared in VALIDATE
