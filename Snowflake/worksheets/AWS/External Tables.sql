 CREATE OR REPLACE EXTERNAL TABLE ext_table
 WITH location = @control_db.external_stages.s3_stage
 FILE_FORMAT = (TYPE = CSV);

 DESC TABLE ext_table;
 SELECT * FROM ext_table; -- JSON

 SELECT value:c1::string as Name,
     value:c2::string as LName,
     value:c3::string as email
 FROM DEMO_DB.PUBLIC.ext_table;


CREATE OR REPLACE EXTERNAL TABLE ext_table_2
(
first_name string as (value:c1::string),
last_name string as (value:c2::string),
email string as (value:c3::string)
)
WITH LOCATION = @control_db.external_stages.s3_stage
FILE_FORMAT = (TYPE = CSV);

SELECT * FROM DEMO_DB.PUBLIC.ext_table_2; 
-- ALTER SESSION set USE_CACHED_RESULT=FALSE;
SHOW PARAMETERS;
--CREATE VIEW

CREATE OR REPLACE VIEW DEMO_DB.PUBLIC.ext_view
as
SELECT $1, $2, $3, $6
FROM @control_db.external_stages.s3_stage;

SELECT count(*) FROM DEMO_DB.PUBLIC.ext_view;


-- Metadata Info
SELEcT *
FROM table(information_schema.external_table_files(TABLE_NAME=>'demo_db.public.ext_table_2'));

SELECT *
FROM table(information_schema.external_table_file_registration_history(table_NAME => 'demo_db.public.ext_table_2'))
-- WHERE FILE_NAME = 'emp/employees04.csv'
;

ALTER EXTERNAL TABLE demo_db.public.ext_table_2 REFRESH;



-- Partiotioning
CREATE OR REPLACE EXTERNAL TABLE demo_db.public.ext_table_3
(
Department string as SUBSTR(metadata$filename, 5, 11), -- emp/employees01.csv -> employees01 
first_name string as (value:c1::string),
last_name string as (value:c2::string),
email string as (value:c3::string)
)
PARTITION BY (Department)
WITH LOCATION = @control_db.external_stages.s3_stage
FILE_FORMAT = (TYPE = CSV);

SELECT *
FROM demo_db.public.ext_table_3
WHERE DEPARTMENT='employees04' and first_name = 'Konny';

DESC EXTERNAL TABLE demo_db.public.ext_table_3;


-- Manual Partition

DESC STORAGE INTEGRATION s3_int;

ALTER STORAGE INTEGRATION s3_int
SET STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-mejohn/unload/',
                                    's3://snowflake-mejohn/emp/',
                                    's3://snowflake-mejohn/emp_partition');

CREATE OR REPLaCE STAGE control_db.external_stages.partition_stage
STORAGE_INTEGRATION = s3_int
url = 's3://snowflake-mejohn/emp_partition'
FILE_FORMAT = CONTROL_DB.FILE_FORMATS.CSV_COMPRESS_FORMAT;

CREATE OR REPLACE EXTERNAL TABLE demo_db.public.ext_table_partition
(
-- status string as (metadata$filename::varchar),
status string as (parse_json(metadata$external_table_partition):STATUS::varchar),
f_name string as (value:c1::varchar),
l_name string as (value:c2::varchar),
email string as (value:c3::varchar)
)
PARTITION BY (status)
partition_type = USER_SPECIFIED
WITH LOCATION = @control_db.external_stages.partition_stage
FILE_FORMAT = (type=csv);

ALTER external TABLE demo_db.public.ext_table_partition
ADD PARTITION (status='Silver')
LOCATION 'silver/';

ALTER external TABLE demo_db.public.ext_table_partition
ADD PARTITION (status='Gold')
LOCATION 'gold/';

ALTER external TABLE demo_db.public.ext_table_partition
ADD PARTITION (status='VIP')
LOCATION 'vip/';

-- SELECT parse_json(metadata$external_table_partition):STATUS::string FROM demo_db.public.ext_table_partition;
SELECT * FROM demo_db.public.ext_table_partition;


-- AUTO REFRESH SQS
 CREATE OR REPLACE EXTERNAL TABLE DEMO_DB.PUBLIC.ext_table
(
Department string as SUBSTR(metadata$filename, 5, 11), -- emp/employees01.csv -> employees01 
first_name string as (value:c1::string),
last_name string as (value:c2::string),
email string as (value:c3::string)

)
 WITH location = @control_db.external_stages.s3_stage
 FILE_FORMAT = (TYPE = CSV)
 AUTO_REFRESH = true; -- default value
 
SHOW EXTERNAL TABLEs;

SELECT * 
FROM table(information_schema.external_table_file_registration_history(table_name=>'DEMO_DB.PUBLIC.ext_table'));
