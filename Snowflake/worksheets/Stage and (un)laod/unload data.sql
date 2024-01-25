use demo_db;

-- a table to table stage
COPY INTO @%emp_basic_local
FROM emp_basic_local
file_format = control_db.file_formats.csv_format;

SELECT * FROM @%emp_basic_local;

-- part of table to stage
COPY INTO @%emp_basic_local
FROM (SELECT first_name from emp_basic_local)
file_format = (type=csv field_optionally_enclosed_by='"')
OverWrite = true;

COPY INTO @%emp_basic_local/all
FROM emp_basic_local
file_format = control_db.file_formats.csv_format;
desc table emp_basic_local;

copy into @demo_db.public.%emp_basic_local/test_folder/test_
from (select first_name, last_name,email from demo_db.public.emp_basic_local)
file_format = (type = csv field_optionally_enclosed_by='"')
OVERWRITE=TRUE;
--on_error = 'skip_file';