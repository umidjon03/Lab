USE DATABASE DEMO_DB;
CREATE OR REPLACE TRaNSIENT table person(id int, name string);


INSERT INTO person VALUEs (1, 'Joe');
INSERT INTO person VALUEs (2, 'Leyla');
INSERT INTO person VALUEs (3, 'John');
INSERT INTO person VALUEs (4, 'Biden');
INSERT INTO person VALUEs (5, 'Messi');
INSERT INTO person VALUEs (6, 'Mia');

DELETE FROM person where id=4;
UPDATE person set name='update1' where id=6;

CREATE STREAM person_delta_stream on table person;
CREATE TABLE person_history(id int, name string, operation string default null, version int default 0, "date" timestamp_ltz);

CREATE or replace TASK stream_producer
    warehouse = compute_wh
    schedule = '1 minute'
WHEN system$stream_has_data('person_delta_stream')
as
MERGE INTO person_history h
USING (SELECT DISTINCT id, name,METADATA$ACTION, METADATA$ISUPDATe FROM person_delta_stream) s
ON h.id=s.id and s.metadata$action = 'DELETE'
WHEN MATCHED and s.metadata$isupdate = 'TRUE'
    THEN UPDATE SET version = version-1, operation='UPDATED'
when matched AND s.METADATA$isupdate = 'FALSE'
    then update set version = 9999, operation='DELETE'
when NOT matched 
    then insert values (s.id, s.name, s.METADATA$ACTION, 0, current_timestamp());

ALTER task stream_producer resume;
show tasks;

select * FROM person_delta_stream;
SELECT * FROM PERSON;
SELECT * FROM PERSON_HISTORY;
-- delete from person_history where id=1;