SELECT * FROM sql_inventory.products;

SELECT *
FROM customers
WHERE first_name regexp 'lka|ambur';

-- if nothing - the text that contains the string
-- | means logical OR 
-- ^ takes records that starts with the following string 
-- $ takes records that ends with the following string
-- () separates multiple regexs
-- [asf] takes if at least one of chars exists
-- [a-h] takes if at least one char from a to h exists

Use sql_hr;
select e.employee_id, 
	e.first_name,
    m.first_name manager
FROM employees e, employees m
	ON e.reports_to = m.employee_id;
    
SELECT 
	o.customer_id,
    c.first_name,
    sh.name as shipper
FROM orders o
JOIN customers c
	USING (customer_id)  -- USING (column1, ...) <=> `ON o.column = c.column AND ...`
LEFT JOIN shippers sh
	USING (shipper_id);

------------- OR -----------------

SELECT *
FROM orders o
NATURAL JOIN customers c;  -- Finds common column names and joins them based on the common column 

-- CROSS JOIN is also available

-- If you want to define default value nof a column during INSERT, just type 'DEFAULT' in the VALUES clause. For example for auto increment columns.

-- LAST_INSERT_ID() returns previuous insertion query's incremented pk. You can do atomic actions by using this function
	-- For example, when user create order, other table named order_items should also polulated. the order_items table includes 
    -- order_id as PK, product id, quantityt, etc while order table contains order id as PK, user_id, date, etc. In this case oe order
    -- can have many order_items, so order_itsm table is called CHILD table while order table is PARENT table.
    -- so, after inserting a row to order table, order items with identical order_id s should also inserted to the order_items table
    -- But how to get the last inserted order's id? By using LAST_INSERT_ID()


-- CTAS is also available in MySQL as well as IIS insert into <table> SELECT ...

;
------------------------------------------ MySQL Advanced --------------------------------------------------
----------------- SP and Functions

------ Variables
-- you can declare and set a variable & value for a session
-- You can init&set a variable by these 3 methods
set @var=12;
SELECT @var:=MAX(points) from customers;
SELECT MIN(points) into @var from customers;
select @var;

-- Some variables should not get out of its environment, for example, variables used inside the SP should not get out. So we can use local variables
	-- local variables: inside environments like stored procedures you need to declare a variable firstly and set values by SET variable_name (wothout @)
    -- You can also set regulare user-defined variables as well in SP 
DELIMITER //
CREATE PROCEDURE RepeatExample()
BEGIN
   DECLARE val INT;
   DECLARE squares INT;
   DECLARE res VARCHAR(100);
   SET val=1;
   SET squares=1;
   SET res = '';
   REPEAT
      SET squares = val*val;
      SET res = CONCAT(res, squares,',');
      SET val = val + 1;
   UNTIL val >= 10
   END REPEAT;
   set @var_rep = 12;
   SELECT res;
END//
DELIMITER ;
CALL RepeatExample;
Select @var_rep;
DROP PROCEDURE RepeatExample;
------

------ Parameteres
-- In  Parameteres: regular parameter that you pass variable into object
CREATE PROCEDURE taxCal(IN salary int) SELECT salary*0.12 as TAX;
call taxCal(1000);

-- Out parameters: the value of the parameter will be set to the defined variable which is defined during calling object:
CREATE PROCEDURE assignTaxCal(IN salary int, Out Var_name int) SELECT salary*0.12 into Var_name;
call assignTaxCal(1000, @tax);
Select @tax; 					-- now SP takes @tax as a out parameter and assign the value to the parameter

-- Inout parameteres: Just receive a variable as a parameter and assigns proccessed new value for that
SET @netSalary = 1000;
CREATE PROCEDURE netSalary(INOut Var_name int) set Var_name = Var_name - Var_name*0.12;
call netSalary(@netSalary);
Select @netSalary;


SELECT * fROM customers natural join orders;


