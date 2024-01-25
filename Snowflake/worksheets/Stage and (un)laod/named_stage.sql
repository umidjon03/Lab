CREATE OR REPLACE stage control_db.internal_stages.int_stage;
desc stage control_db.internal_stages.int_stage;

truncate table demo_db.public.emp_basic_local;

COPY INTO demo_db.public.emp_basic_local
FROM (SELECT metadata$filename, metadata$file_row_number, $1, $2, $3, $4, $5, $6 from @control_db.internal_stages.int_stage/emp_basic_named_stage)
FILE_FORMAT = (type=csv field_optionally_enclosed_by='"')
PATTERN = '.*employees0[1-5].csv.gz'
ON_ERROR = 'skip_file';

SELECT * FROM demo_db.public.emp_basic_local;