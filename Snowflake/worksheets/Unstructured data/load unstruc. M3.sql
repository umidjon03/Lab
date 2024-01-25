-- Method 3
-- Ex stage -> parsing and copy to internal stage -> load data into struc. table
use database uns_data_db;

CREATE OR REPLACE TABLE books_table_m3
like books_table;
desc table books_table_m3;
truncate table books_table_m3;

-- BEGIN
-- !!!!!!!!!!!!
-- Why do we need internal staging instead of just load =ing data directly from external stage to snow table?:

copy into books_table_m3
from(
select 
$1:"_id":"$oid"::string as OID,
$1:"author"::array as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::string as YEAR,
$1:"type"::string as TYPE 
from @book_stage/sample_dblp.json
)
ON_ERROR='CONTINUE';

-- In this case, if the expression data type is not possible to cast to table datatype, snowflake will return error
-- For example: the year expression is defined as `$1:"year"::boolean`, an error will pops up, since it is ispossible
-- to cast bool to integer. (array to int, int to array)
-- In this case the validation won't work
-- That is why we need validatable copy cammand to load data

-- END

COPY INTO @%books_table_m3/book
FROM (
select
    $1:"_id":"$oid"::string as oid,
    $1:author::array as author,
    $1:title::string as title,
    $1:booktitle::string as booktitle,
    $1:year::int as year,
    $1:type::string as type
from @book_stage
)
overwrite=true;


-- ls @%books_table_m3/book;

copy into books_table_m3
from @%books_table_m3
ON_ERROR='CONTINUE'
purge = true; --  not to store a data to 2 staging are, it is goot to set purge true

ls @%books_table_m3/book;
desc table books_table_m3;





