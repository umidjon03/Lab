USE DATABASE DEMO_DB;

create or replace TABLE taxi
(
TRIP_ID string,
CALL_TYPE char(1),
ORIGINAL_CALL int,
ORIGINAL_STAND int,
TAXI_ID int,
TIMESTAMP int,
DAYTYPE char(1),
MISSING_DATA boolean,
POLYLINE ARRAY
);

CREATE OR REPLACE FILE FORMAT control_db.file_formats.taxi_ff
type = csv,
compression = gzip
null_if = ('Null', 'null'),
empty_field_as_null = true,
skip_header = 1;

COPY INTO taxi
FROM (SELECT t.$1, t.$2, iff(t.$3='', null, t.$3), iff(t.$4='', null, t.$4), t.$5, t.$6, t.$7, t.$8, t.$9 FROM @%taxi t)
FILE_FORMAT = (FORMAT_NAME='control_db.file_formats.taxi_ff' field_optionally_enclosed_by='"')
-- VALIDATION_mode = 'reTurn_errors'
on_error = 'continue'
;  -- 2 mins 29 SECONDS

create or replace TABLE taxi_split
(
TRIP_ID string,
CALL_TYPE char(1),
ORIGINAL_CALL int,
ORIGINAL_STAND int,
TAXI_ID int,
TIMESTAMP int,
DAYTYPE char(1),
MISSING_DATA boolean,
POLYLINE ARRAY
);


COPY INTO taxi_split
FROM (SELECT t.$1, t.$2, iff(t.$3='', null, t.$3), iff(t.$4='', null, t.$4), t.$5, t.$6, t.$7, t.$8, t.$9 FROM @%taxi_split t)
FILE_FORMAT = (FORMAT_NAME='control_db.file_formats.taxi_ff' field_optionally_enclosed_by='"')
-- VALIDATION_mode = 'reTurn_errors'
on_error = 'continue'
;  --25 SECONDS 




TRUNCate table taxi;

SELECT * FROM table(VALIDATE(taxi, job_id=>'01afc6bf-0404-cb76-0001-434b0003159e'));

list @%taxi;
select * from TAXI
MINUS
SELECT * FROM TAXI_SPLIT;



