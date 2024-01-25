create or replace table demo_db.public.emp_basic_1 (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

COPY INTO DEMO_DB.PUBLIC.emp_basic_1
FROM @DEMO_DB.PUBLIC.%emp_basic_1
FILE_FORMAT = (type = csv field_optionally_enclosed_by='"')
PATTERN = '.*employees0[1-5].csv.gz'
ON_ERROR = 'skip_file'
;

SELECT * FROM DEMO_DB.public.emp_basic_1 limit 100;

LIST STAGE @%emp_basic_1;
ALTER SESSION SET USE_CACHED_RESULT=FALSE;
