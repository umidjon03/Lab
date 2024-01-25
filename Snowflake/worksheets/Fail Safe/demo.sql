SELECT * FROM demo_db.information_schema.table_storage_metrics where TABLE_NAME='TAXI';
select* from demo_db.public.taxi limit 1;

ALTER TABLE taxi set data_retention_time_in_days=0;

update taxi
set call_type='A'
where trip_id=1403778326620000296;