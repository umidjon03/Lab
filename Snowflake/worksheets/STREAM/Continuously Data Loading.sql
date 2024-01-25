DESC storage integration s3_int;
desc file format control_db.file_formats.csv_format;

alter storage integration s3_int 
set
STORAGE_ALLOWED_LOCATIONS = (
's3://snowflake-mejohn/unload/',
's3://snowflake-mejohn/emp/',
's3://snowflake-mejohn/emp_partition',
's3://snowflake-mejohn/books/',
's3://snowflake-mejohn/parkings/'
);


CREATE stage control_db.external_stages.parking_stage
storage_integration = s3_int
url = 's3://snowflake-mejohn/parkings/'
file_format = control_db.file_formats.csv_format;

desc stage control_db.external_stages.parking_stage;
SELECT $1 from @control_db.external_stages.parking_stage/parking_aa limit 1;

create or replace transient table demo_db.public.parking  -- NJ_parking --LC_parking --NY_parking
(
Summons_Number	 Number	,
Plate_ID	Varchar	,
Registration_State	 Varchar	,
Plate_Type	 Varchar	,
Issue_Date	DATE	,
Violation_Code	 Number	,
Vehicle_Body_Type	 Varchar	,
Vehicle_Make	 Varchar	,
Issuing_Agency	 Varchar	,
Street_Code1	 Number	,
Street_Code2	 Number	,
Street_Code3	 Number	,
Vehicle_Expiration_Date	 Number	,
Violation_Location	 Varchar	,
Violation_Precinct	 Number	,
Issuer_Precinct	 Number	,
Issuer_Code	 Number	,
Issuer_Command	 Varchar	,
Issuer_Squad	 Varchar	,
Violation_Time	 Varchar	,
Time_First_Observed	 Varchar	,
Violation_County	 Varchar	,
Violation_In_Front_Of_Or_Opposite	 Varchar	,
House_Number	 Varchar	,
Street_Name	 Varchar	,
Intersecting_Street	 Varchar	,
Date_First_Observed	 Number	,
Law_Section	 Number	,
Sub_Division	 Varchar	,
Violation_Legal_Code	 Varchar	,
Days_Parking_In_Effect	 Varchar	,
From_Hours_In_Effect	 Varchar	,
To_Hours_In_Effect	 Varchar	,
Vehicle_Color	 Varchar	,
Unregistered_Vehicle	 Varchar	,
Vehicle_Year	 Number	,
Meter_Number	 Varchar	,
Feet_From_Curb	 Number	,
Violation_Post_Code	 Varchar	,
Violation_Description	 Varchar	,
No_Standing_or_Stopping_Violation	 Varchar	,
Hydrant_Violation	 Varchar	,
Double_Parking_Violation	 Varchar ,
Latitude  Varchar,
Longitude Varchar,
Community_Board  Varchar,
Community_Council  Varchar, 
Census_Tract  Varchar,
BIN  Varchar,
BBL  Varchar,
NTA  Varchar
);

CREATE OR REPLACE table LC_parking_t like parking;
CREATE OR REPLACE table NJ_parking_t like parking;

CREATE OR REPLACE PIPE parkings_pipe auto_ingest = true 
as
COPY INTO parking
FROM @control_db.external_stages.parking_stage
ON_ERROR = 'CONTINUE';

DESC PIPE parkings_pipe;
ALTER PIPE parkingS_pipe refresh;

SELECT COUNT(*) FROM parking;

CREATE or REPLACE stream LC_parking_stream on table parking ;
CREATE or REPLACE stream NJ_parking_stream on table parking ;

select * from LC_parking_stream WHERE REGISTRATION_STATE='NJ' order by Summons_Number limit 10;

CREATE or REPLACE TASK lc_executor
warehouse = compute_wh
schedule = '1 Minute'
WHEN system$stream_has_data('LC_parking_stream')
AS
INSERT INTO LC_parking_t
SELECT 
SUMMONS_NUMBER,
PLATE_ID,
REGISTRATION_STATE,
PLATE_TYPE,
ISSUE_DATE,
VIOLATION_CODE,
VEHICLE_BODY_TYPE,
VEHICLE_MAKE,
ISSUING_AGENCY,
STREET_CODE1,
STREET_CODE2,
STREET_CODE3,
VEHICLE_EXPIRATION_DATE,
VIOLATION_LOCATION,
VIOLATION_PRECINCT,
ISSUER_PRECINCT,
ISSUER_CODE,
ISSUER_COMMAND,
ISSUER_SQUAD,
VIOLATION_TIME,
TIME_FIRST_OBSERVED,
VIOLATION_COUNTY,
VIOLATION_IN_FRONT_OF_OR_OPPOSITE,
HOUSE_NUMBER,
STREET_NAME,
INTERSECTING_STREET,
DATE_FIRST_OBSERVED,
LAW_SECTION,
SUB_DIVISION,
VIOLATION_LEGAL_CODE,
DAYS_PARKING_IN_EFFECT,
FROM_HOURS_IN_EFFECT,
TO_HOURS_IN_EFFECT,
VEHICLE_COLOR,
UNREGISTERED_VEHICLE,
VEHICLE_YEAR,
METER_NUMBER,
FEET_FROM_CURB,
VIOLATION_POST_CODE,
VIOLATION_DESCRIPTION,
NO_STANDING_OR_STOPPING_VIOLATION,
HYDRANT_VIOLATION,
DOUBLE_PARKING_VIOLATION,
LATITUDE,
LONGITUDE,
COMMUNITY_BOARD,
COMMUNITY_COUNCIL,
CENSUS_TRACT,
BIN,
BBL,
NTA
FROM LC_parking_stream where Registration_State='LA';
ALTER TASK lc_executor resume;



CREATE or REPLACE TASK nj_executor
warehouse = compute_wh
schedule = '1 Minute'
WHEN system$stream_has_data('NJ_parking_stream')
AS
INSERT INTO NJ_parking_t
SELECT 
SUMMONS_NUMBER,
PLATE_ID,
REGISTRATION_STATE,
PLATE_TYPE,
ISSUE_DATE,
VIOLATION_CODE,
VEHICLE_BODY_TYPE,
VEHICLE_MAKE,
ISSUING_AGENCY,
STREET_CODE1,
STREET_CODE2,
STREET_CODE3,
VEHICLE_EXPIRATION_DATE,
VIOLATION_LOCATION,
VIOLATION_PRECINCT,
ISSUER_PRECINCT,
ISSUER_CODE,
ISSUER_COMMAND,
ISSUER_SQUAD,
VIOLATION_TIME,
TIME_FIRST_OBSERVED,
VIOLATION_COUNTY,
VIOLATION_IN_FRONT_OF_OR_OPPOSITE,
HOUSE_NUMBER,
STREET_NAME,
INTERSECTING_STREET,
DATE_FIRST_OBSERVED,
LAW_SECTION,
SUB_DIVISION,
VIOLATION_LEGAL_CODE,
DAYS_PARKING_IN_EFFECT,
FROM_HOURS_IN_EFFECT,
TO_HOURS_IN_EFFECT,
VEHICLE_COLOR,
UNREGISTERED_VEHICLE,
VEHICLE_YEAR,
METER_NUMBER,
FEET_FROM_CURB,
VIOLATION_POST_CODE,
VIOLATION_DESCRIPTION,
NO_STANDING_OR_STOPPING_VIOLATION,
HYDRANT_VIOLATION,
DOUBLE_PARKING_VIOLATION,
LATITUDE,
LONGITUDE,
COMMUNITY_BOARD,
COMMUNITY_COUNCIL,
CENSUS_TRACT,
BIN,
BBL,
NTA  
FROM NJ_parking_stream where Registration_State='NJ';
alter TASK nj_executor resume;

show tasks;

SELECT * FROM LC_parking_t;
SELECT COUNT(*) FROM NJ_parking_t --WHERE Registration_State!='NJ';
;
show tasks;