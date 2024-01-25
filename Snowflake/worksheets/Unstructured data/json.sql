CREATE database uns_data_DB;
USE DATABASE uns_data_db;

CREATE OR replace TABLE json_demo (v variant);

INSERT INTO json_demo
SELECT parse_json(
'{
   "fullName":"Johnny Appleseed",
   "age":42,
   "gender":"Male",
   "phoneNumber":{
      "areaCode":"415",
      "subscriberNumber":"5551234"
   },
   "children":[
      {
         "name":"Jayden",
         "gender":"Male",
         "age":"10"
      },
      {
         "name":"Emma",
         "gender":"Female",
         "age":"8"
      },
      {
         "name":"Madelyn",
         "gender":"Female",
         "age":"6"
      }
   ],
   "citiesLived":[
      {
         "cityName":"London",
         "yearsLived":[
            "1989",
            "1993",
            "1998",
            "2002"
         ]
      },
      {
         "cityName":"San Francisco",
         "yearsLived":[
            "1990",
            "1993",
            "1998",
            "2008"
         ]
      },
      {
         "cityName":"Portland",
         "yearsLived":[
            "1993",
            "1998",
            "2003",
            "2005"
         ]
      },
      {
         "cityName":"Austin",
         "yearsLived":[
            "1973",
            "1998",
            "2001",
            "2005"
         ]
      }
   ]
}'
);

SELECT * FROM json_demo;

SELECT v:age::int as age
FROM json_demo;

SELECT v:children[0]:age::int
FROM json_demo;

-- Flatten table func
-- flatten(<list>) - break each obj of list into table records
SELECT *
FROM TABLE(Flatten((select v:children from json_demo)));

-- Cross join with flatten table

SELECT
    v:fullName::string as parentName,
    value:name::string as Name,
    VALUE:age::int as Age
FROM json_demo, TABLE(Flatten(v:children)) f;

-- How many children each person has

SELECT 
    v:fullName::string as Name,
    array_size(v:children) as childCount
FROM json_demo;

-- deeper flatten

SELECT
    v:fullName::string as "Full Name",
    c.value:cityName::string as City,
    y.value as "Lived Years"
FROM json_demo, table(flatten(v:citiesLived)) c, table(flatten(c.value:yearsLived)) y;

-- filter

-- NOTE!!!!!!!!!!!!!!!!!!!!!!!!!
-- IN snowflake, once you define an expression to an alies, you can use 
-- the alies for next expressions (in select or where/ join clauses) inlike other DM systems

select
 cl.value:cityName::string as city_name,
 count(*) as years_lived
from json_demo,
 table(flatten(v:citiesLived)) cl,
 table(flatten(cl.value:yearsLived)) yl
where city_name = 'Portland'
group by 1;
