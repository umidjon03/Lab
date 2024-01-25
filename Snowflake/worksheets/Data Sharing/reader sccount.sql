create database reader_sales;

create table customer as
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;

CREATE share sales_reader;
grant usage on database reader_sales to share sales_reader;
grant usage on schema reader_sales.public to share sales_reader;
grant select on table reader_sales.public.customer to share sales_reader;

alter share sales_reader add accounts=FXYCOCW.CUSTOMER1;
show shares;