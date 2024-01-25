create or replace table sampling_test
as
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER SAMPLE bernoulli (0.1) seed (1);

SELECT * FROM sampling_test 
where c_custkey=72186906;

select *
from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER SAMPLE system (0.0001) seed (2)
where c_custkey=76462360;
