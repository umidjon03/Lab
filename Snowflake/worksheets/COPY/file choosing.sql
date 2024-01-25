-- Specify which files snowflake have to load data from
COPY INTO demo_db.public.emp_basic_1
FROM @control_db.external_stages.s3_stage
FILES = ('employees04.csv', 'employees05.csv')
ON_ERROR = 'SKIP_FILE'
-- FORCE = TRUE
;

-- Specify which files snowflake have to skip loading data from
COPY INTO demo_db.public.emp_basic_1
FROM @control_db.external_stages.s3_stage
 PATTERN = '.*employees0[1-5].csv'
FILES != ('employees04.csv', 'employees05.csv')
ON_ERROR = 'SKIP_FILE';

select * FROM demo_db.public.emp_basic_1;

