-- Method 2
-- Ex stage -> variant tablr -> load to structured data by parsing
-- in this case problem with validation. cannot apply OM_ERROR or othi kinda validation methods

USE DATABASE uns_data_db;

CREATE OR REPLACE TABLE books_raw (v variant);

copy into books_raw
from @book_stage/sample_dblp.json;

CREATE OR REPLACE TABLE books_table
as
select
    v:"_id":"$oid"::string as oid,
    v:author::array as author,
    v:title::string as title,
    v:booktitle::string as booktitle,
    v:year::int as year,
    v:type::string as type
from books_raw;

SELECT * FROM books_table -- where booktitle is null;
DESC TABLE books_table;














