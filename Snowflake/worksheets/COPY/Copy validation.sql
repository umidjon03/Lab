-- Validate Mode
COPY INTO DEMO_DB.PUBLIC.EMP_BASIC_1
FROM @control_db.external_stages.s3_stage
validation_mode = 'RETURN_ERRORS'
-- validation_mode = 'RETURN_1_ROWS';
-- validation_mode = 'RETURN_ALL_ERRORS';
-- ON_ERROR = 'SKIP_FILE'

SELECT * FROM 
TABLE(VALITAde(<table>, job_id=>'<query id>')