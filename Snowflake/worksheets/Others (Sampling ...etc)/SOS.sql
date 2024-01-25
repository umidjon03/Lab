USE DATABASE DEMO_DB;

CREATE TABLE DEMO_DB.PUBLIC.LINEITEM_SOS
AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.LINEITEM;

SELECT query_id, eligible_query_acceleration_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'COMPUTE_WH'
  ORDER BY eligible_query_acceleration_time DESC;  -- 41 mins to insert

SELECT *
FROM DEMO_DB.PUBLIC.LINEITEM_SOS
WHERE l_quantity BETWEEN 1 AND 2;