-------------------------------------------- LAB 1 ----------------------------------------
-- I tried to know the differences between scoped and ordinary file url in a Stage
-- Existing objects: stage (@test_st) with a file, role (r1)
CREATE view url_file
as
select BUILD_SCOPED_FILE_URL(@test_st, 'f1/file_1_0_0_0.csv.gz') scoped,
       BUILD_STAGE_FILE_URL(@test_st, 'f1/file_1_0_0_0.csv.gz') ordinary;


grant select on view url_file to role r1;
show grants to role r1;
grANT usage on database db1 to role r1;
grant usage on schema public to role r1;

use role r1;
SELECT * FROM url_file;

-- Result

-- When I call the view I got 2 urls:
-- 1.  https://ydb23948.us-east-1.snowflakecomputing.com/api/files/01b0ce53-0604-db2a-0002-0e6f00051026/8832122889/QkEoo%2fPgbltbh%2bhsSSolMy3HNtoMYqxDeWgkd6ZWd0EXIT7FkIw3oHaEbWc%2f91EavZz%2bjznCwxgCE0brmLoi5qJ%2bhJiEcR%2fiOuTDaROPhpO1TOyXDSJgMurfHq%2f5t1BJYDlPNww6mWEuQdiCEXLzISWy43NWA5AsMc66PlbRacw3nxvCWW2qi5ir%2bWNq2AWK%2f3%2f%2f3niR9rnNb1opHj5eKx4%2bzzt1RmQmQAyDXPkp9Awj
-- 2. https://ydb23948.us-east-1.snowflakecomputing.com/api/files/DB1/PUBLIC/TEST_ST/f1%2ffile_1_0_0_0%2ecsv%2egz
-- The first is scoped while another is ordinary url
-- When I click the scoped one the file has been downloaded eventhough I have no any access to the stage
-- But when I click the second the ordinary url it throw an error that says I have no access to read a file from the stage

-- Conclusion

-- Scoped url returns the file to user who built the url (as long as persisted query result is available. 24 hours )
-- Ordinary url, when you send request, checks your privileges to the stage
-- To build both urls you need proper privilege (read/usage), but in this case a user with R1 role is calling the view.
-- This is key point of usage of scoped URL.




-------------------------------------------- LAB 2 ----------------------------------------
