SELECT ...
FROM ...
   CHANGES ( INFORMATION => { DEFAULT | APPEND_ONLY } )
   AT ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } )
 | BEFORE ( STATEMENT => <id> )
   [ END( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
[ ... ]


-- Currently, at least one of the following must be true before change tracking metadata is recorded for a table:

-- Change tracking is enabled on the table (using ALTER TABLE … CHANGE_TRACKING = TRUE).

-- A stream is created for the table (using CREATE STREAM).

-- Both options add hidden columns to the table which store change tracking metadata. The columns consume a small amount of storage.

-- Retention period is 1 day by default




-- The following example queries the standard (delta) and append-only change tracking metadata for a table. No END() value is provided, so the current timestamp is used as the endpoint in the transactional interval of time:

CREATE OR REPLACE TABLE t1 (
   id number(8) NOT NULL,
   c1 varchar(255) default NULL
 );

-- Enable change tracking on the table.
 ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

 -- Initialize a session variable for the current timestamp.
 SET ts1 = (SELECT CURRENT_TIMESTAMP());

 INSERT INTO t1 (id,c1)
 VALUES
 (1,'red'),
 (2,'blue'),
 (3,'green');

 DELETE FROM t1 WHERE id = 1;

 UPDATE t1 SET c1 = 'purple' WHERE id = 2;

 -- Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the full delta of the changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => DEFAULT)
   AT(TIMESTAMP => $ts1);

 -- +----+--------+-----------------+-------------------+------------------------------------------+
 -- | ID | C1     | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
 -- |----+--------+-----------------+-------------------+------------------------------------------|
 -- |  2 | purple | INSERT          | False             | 1614e92e93f86af6348f15af01a85c4229b42907 |
 -- |  3 | green  | INSERT          | False             | 86df000054a4d1dc64d5d74a44c3131c4c046a1f |
 -- +----+--------+-----------------+-------------------+------------------------------------------+

 -- Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the append-only changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => APPEND_ONLY)
   AT(TIMESTAMP => $ts1);

 -- +----+-------+-----------------+-------------------+------------------------------------------+
 -- | ID | C1    | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
 -- |----+-------+-----------------+-------------------+------------------------------------------|
 -- |  1 | red   | INSERT          | False             | 6a964a652fa82974f3f20b4f49685de54eeb4093 |
 -- |  2 | blue  | INSERT          | False             | 1614e92e93f86af6348f15af01a85c4229b42907 |
 -- |  3 | green | INSERT          | False             | 86df000054a4d1dc64d5d74a44c3131c4c046a1f |
 -- +----+-------+-----------------+-------------------+------------------------------------------+

-- The following example consumes the append-only changes for a table from a transactional point of time before the rows were deleted from the table:

 CREATE OR REPLACE TABLE t1 (
  id number(8) NOT NULL,
  c1 varchar(255) default NULL
);

-- Enable change tracking on the table.
ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

-- Initialize a session 'start timestamp' variable for the current timestamp.
SET ts1 = (SELECT CURRENT_TIMESTAMP());

INSERT INTO t1 (id,c1)
VALUES
(1,'red'),
(2,'blue'),
(3,'green');

-- Initialize a session 'end timestamp' variable for the current timestamp.
SET ts2 = (SELECT CURRENT_TIMESTAMP());

DELETE FROM t1;

-- Create a table populated by the change data between the start and end timestamps.
CREATE OR REPLACE TABLE t2 (
  c1 varchar(255) default NULL
  )
AS SELECT C1
  FROM t1
  CHANGES(INFORMATION => APPEND_ONLY)
  AT(TIMESTAMP => $ts1)
  END(TIMESTAMP => $ts2);

SELECT * FROM t2;

+-------+
| C1    |
|-------|
| red   |
| blue  |
| green |
+-------+

-- The following example is similar to the previous example. This example uses the current offset for a stream on the source table as the start point in time for populating the new table with change data from the source table. Because a stream is created on the source object, you do not need to explicitly enable change tracking on the object:

CREATE OR REPLACE TABLE t1 (
  id number(8) NOT NULL,
  c1 varchar(255) default NULL
);

-- Create a stream on the table.
CREATE OR REPLACE STREAM s1 ON TABLE t1;

INSERT INTO t1 (id,c1)
VALUES
(1,'red'),
(2,'blue'),
(3,'green');

-- Initialize a session 'end timestamp' variable for the current timestamp.
SET ts2 = (SELECT CURRENT_TIMESTAMP());

DELETE FROM t1;

-- Create a table populated by the change data between the current
-- s1 offset and the end timestamp.
CREATE OR REPLACE TABLE t2 (
  c1 varchar(255) default NULL
  )
AS SELECT C1
  FROM t1
  CHANGES(INFORMATION => APPEND_ONLY)
  AT(STREAM => 's1')
  END(TIMESTAMP => $ts2);

SELECT * FROM t2;

+-------+
| C1    |
|-------|
| red   |
| blue  |
| green |
+-------+

