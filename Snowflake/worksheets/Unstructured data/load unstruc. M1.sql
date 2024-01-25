-- Method 1
-- Ex stage -> variant table -> parsing and returning data
-- (always parsing data regularly is not recommended)

-- a sample of the json data
{ 
    "_id" : { "$oid" : "595c2c59a7986c0872002043" }, 
    "mdate" : "2017-05-24",
    "author" : [
                "Injoon Hong",
                "Seongwook Park",
                "Junyoung Park",
                "Hoi-Jun Yoo"
                ],
    "ee" : "https://doi.org/10.1109/ASSCC.2015.7387453",
    "booktitle" : "A-SSCC",
    "title" : "A 1.9nJ/pixel embedded deep neural network ...",
    "pages" : "1-4",
    "url" : "db/conf/asscc/asscc2015.html#HongPPY15",
    "year" : "2015",
    "type" : "inproceedings",
    "_key" : "conf::asscc::HongPPY15",
    "crossref" : [ "conf::asscc::2015" ]
};


ALTER STORAGE INTEGRATION s3_int
set STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-mejohn/unload/',
                    's3://snowflake-mejohn/emp/',
                    's3://snowflake-mejohn/emp_partition',
                    's3://snowflake-mejohn/books/');

CREATE OR REPLACE FILE FORMAT json_format
type = json;

CREATE OR REPLACE TABLE books_raw (v variant);

CREATE OR REPLACE STAGE book_stage
storage_integration = s3_int
url = 's3://snowflake-mejohn/books/'
file_format = json_format;

SELECT *
FROM @book_stage/sample_dblp.json;
-- (file_format =>JSON_FORMAT)


copy into books_raw
from @book_stage/sample_dblp.json;

select * from books_raw;

select
    v:"_id":"$oid"::string as oid,
    v:author::array as author,
    v:title::string as title,
    v:booktitle::string as booktitle,
    v:year::string as year,
    v:type::string as type
from books_raw;









