
CREATE OR REPLACE FILE FORMAT control_db.file_formats.csv_format
TYPE = csv
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
FIELD_DELIMITER = ','
null_if = ('NULL', 'null')
empty_field_as_null = true
compression = gzip;



CREATE or REPLACE table DEMO_DB.PUBLIC.emp_basic_2 (
first_name string,
last_name string,
email string
);

COPY INTO DEMO_DB.PUBLIC.emp_basic_2
FROM (SELECT t.$1, t.$2, t.$3 FROM @DEMO_DB.public.%emp_basic_2 t)
FILE_FORMAT = control_db.file_formats.csv_format
PATTERN = '.*employees0[1-5].csv.gz'
ON_ERROR = 'skip_file';

create or replace table demo_db.public.emp_basic_local (
         file_name string,
         fie_row_number string,
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);


COPY INTO DEMO_DB.PUBLIC.EMP_BASIC_LOCAL
FROM (SELECT metadata$filename, metadata$file_row_number, t.$1, t.$2, t.$3, t.$4, t.$5, $6 FROM @DEMO_DB.PUBLIC.%emp_basic_local t)
FILE_FORMAT = control_db.file_formats.csv_format
ON_ERROR = 'skip_file';

SELECT * FROM DEMO_DB.public.emp_basic_local;

ALTER FILE FORMAT control_db.file_formats.csv_format
set ERROR_ON_COLUMN_COUNT_MISMATCH = false;

SELECT count(*)
FROM @DEMO_DB.public.%emp_basic_local
(file_format => control_db.file_formats.csv_format);

SELECT metadata$filename, metadata$file_row_number, $1, $2, $3, $4, $5, $6
FROM @DEMO_DB.public.%emp_basic_local
(file_format => control_db.file_formats.csv_format)
MINUS
SELECT * FROM DEMO_DB.public.emp_basic_local
;

SELECT DISTINCT split_part(split_part(file_name, '/', 2), '.', 1)
FROM demo_db.public.emp_basic_local;




