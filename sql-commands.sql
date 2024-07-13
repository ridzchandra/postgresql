-- Install postgresql
sudo apt update
sudo apt install postgresql 
sudo apt install postgresql-contrib

-- Configure postgresql - postgresql.conf is located at '/etc/postgresql/<version-number>/main/'

-- To check the commands that can be used with postgresql
service postgresql

-- To start postgresql
service postgresql start

-- To get the status of postgresql
service postgresql status

-- To use postgresql for the first time, it comes with a default user 'postgres' - su below is a linux command which stands for switch user, it basically switches from ridzc to postgres on linux
sudo su postgres

-- To enter into cli for postgresql after switching the user
psql

-- In the cli
-- To list all the databses availble on postgresql
\l

-- To run a bash command inside psql
\! <cmd>

-- To list all the users available on postgresql
\du 

-- To quit psql
\q

-- To get help within psql
help 

-- To get help in bash with psql command
psql --help


-- Create a database
CREATE DATABASE <db-name>;

-- Remove a database
DROP DATABASE <db-name>;

-- To change the password of a postgresql user
ALTER USER <username> WITH PASSWORD '<password>';

-- CREATE ROLE
-- General Purpose: CREATE ROLE is a more general-purpose command used to create a new role. A role can be thought of as an entity that can own database objects (like tables) and have database privileges.

-- Flexibility: Roles can be set up to act like users or groups. By default, a role cannot log in; it's essentially just a set of privileges and ownerships until login capability is granted.

-- Options: When creating a role, you can specify various attributes, such as LOGIN, SUPERUSER, CREATEDB, etc., to define the role's capabilities and access levels.

-- Create a new role
CREATE ROLE role_name;

-- To make a role similar to a traditional user, you would grant it login privileges:
CREATE ROLE role_name WITH LOGIN;

-- CREATE USER
-- Specific Purpose: CREATE USER is a specialized form of the CREATE ROLE command. It creates a new role but implicitly includes LOGIN permission, making it immediately usable as a database user account.

-- Convenience: Essentially, CREATE USER is a shortcut for CREATE ROLE ... WITH LOGIN, plus any other options you might specify. It's designed for creating roles that are specifically intended to log in to the database.

-- Create a new postgres user
CREATE USER <username> WITH PASSWORD '<password>';

-- Summary
-- CREATE ROLE is a versatile command for creating roles that can act as users, groups, or both, depending on the options specified.
-- CREATE USER is a convenience command for creating a role with login capability, intended to be used as a database user account.
-- In practice, the distinction is mainly about intent and convenience. PostgreSQL treats all roles as part of a unified role system, blurring the lines between "users" and "groups" in traditional database systems.

-- Give a postgresql user privileges
ALTER USER <username> WITH <privilege-name-in-all-caps-no-sapce>;

-- Remove a postgresql user
DROP USER <username>;

-- Connect to a database - Method 1
psql -h <hostname> -p <port-number> -U <username> <db-name>

-- Connect to a different database while already connected to one within psql -  Method 2
\c <db-name>

-- Create a table without constraints
CREATE TABLE person (
    id INT,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    gender VARCHAR(6),
    dateOfBirth DATE
);

-- Show a list of tables and sequences
\d

-- Just a list of tables
\dt

-- Describe a table
\d <tablename>

-- Expanded display - to view records when there is no enough space to view all columns on one line
\x

-- Create a table with constraints
CREATE TABLE person (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    dateOfBirth DATE NOT NULL,
    email VARCHAR(150)
);

-- Insert records into a table - since id is BIGSERIAL, it's auto increment
INSERT INTO person (
    firstname,
    lastname,
    gender,
    dateOfBirth,
    email 
) VALUES (
    'Ridz',
    'Chandra',
    'Male',
    DATE '1996-11-09',
    'ridzchandra9@gmail.com'
);

-- Select all columns from a table
SELECT * FROM person;

-- Select specified columns from  a table
SELECT firstname, email from person;

-- Sort data by a specific column - although you can sort by multiple columns it is advised to sort at most with one
SELECT * FROM person ORDER BY countryofbirth;
-- is same as
SELECT * FROM person ORDER BY countryofbirth ASC;
-- For descending order
SELECT * FROM person ORDER BY countryofbirth DESC;

-- Select distinct values of a column
SELECT DISTINCT countryofbirth FROM person;

-- Filter rows based on conditions 
SELECT * FROM person WHERE gender = 'Female';
SELECT * FROM person WHERE gender = 'Female' AND countryofbirth = 'India' OR countryofbirth = 'China';

-- Comparison operators can be used on numbers, strings, date and pretty much any datatype- usual programming operators but not equal <>, equal =
SELECT * FROM person WHERE gender <> 'Female';

-- Limit, offset and fetch - fetch does same as limit  but limit has easier syntax
-- get first 10 records
SELECT * FROM person LIMIT 10;
-- get second five records;
SELECT * FROM person OFFSET 5 LIMIT 5;
-- get records from id 6
SELECT * FROM person OFFSET 5;


-- IN keyword
SELECT * FROM person WHERE countryofbirth IN ('China', 'France', 'Brazil');

-- BETWEEN Keyword -  select a range
SELECT * FROM person 
WHERE dateOfBirth 
BETWEEN DATE '2000-01-01' AND '2020-01-01' 
ORDER BY dateOfBirth;

-- LIKE and iLike(case insensitive) operator - using wildcards, % - any num of chars, _ - one char
SELECT * FROM person
WHERE email LIKE '_______@google.%';

-- ~ to match regex
SELECT * FROM person
WHERE email ~ 'google.com$';

-- GROUP BY - aggregations
SELECT countryofbirth, COUNT(*) FROM person GROUP BY countryofbirth ORDER BY COUNT(*) DESC;

SELECT MAX(price) from car;

SELECT  make, model, MAX(price), MIN(price), ROUND(AVG(price)), COUNT(*) 
FROM car 
GROUP BY make, model 
HAVING COUNT(*) > 2 
ORDER BY make DESC;

SELECT make, SUM(price)
FROM car
GROUP BY make;


-- GROUP BY HAVING - filtering based on aggregations, HAVING should be after GROUP BY but before ORDER BY(if exists)
SELECT countryofbirth, COUNT(*) FROM person GROUP BY countryofbirth HAVING COUNT(*) < 50 ORDER BY COUNT(*) DESC;

-- Arithematic operators
SELECT 10 + 2; -- 12
SELECT 10 ^ 3; -- 1000
SELECT 3!; -- 6
SELECT 10 % 3; -- 1

-- Alias - AS KEYWORD
SELECT id, make, model, price, ROUND(price * 0.90, 2) AS discounted_price FROM car;

-- COALESCE KEYWORD - Handling nulls, outputs a default value if it's null
SELECT COALESCE(email, 'email not available') FROM person;

-- NULLIF KEYWORD - Handle division by zero error, NULLIF takes two params, returns first parm if they're not equal and returns null if they're.
SELECT NULLIF(10, 10); -- NULL
SELECT NULLIF(10, 2); -- 10
SELECT 10 / 0; -- ERROR: division by zero
SELECT 10 / NULL; -- NULL not an error
SELECT 10 / NULLIF(0, 0) -- NULL not an error
SELECT COALESCE(10 / NULLIF(0, 0), 0); -- 0 not an error

-- TIMESTAMP and DATE datatypes
SELECT NOW(); -- outputs timestamp
SELECT NOW()::DATE; -- cast it into a date
SELECT NOW()::TIME; -- cast it into a time

-- INTERVAL datatype
SELECT NOW() - INTERVAL '1 YEAR'; -- gives us a timestamp 1 year ago from now
SELECT NOW() - INTERVAL '10 YEARS';
SELECT NOW() - INTERVAL '10 MONTHS';
SELECT NOW() - INTERVAL '10 DAYS';
SELECT (NOW() + INTERVAL '10 DAYS')::DATE; -- gives us a date instead of timestamp

-- EXTRACT KEYWORD - extracts different parts from the timestamp
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(DOW FROM NOW()); -- day index of the week
SELECT EXTRACT(CENTURY FROM NOW());
SELECT EXTRACT(MILLISECONDS FROM NOW());

-- AGE function
SELECT firstname, lastName, gender, countryofbirth, dateOfBirth, AGE(NOW(), dateOfBirth) FROM person;

-- Primary keys - to identify a unique row 
-- DROP a PRIMARY KEY CONSTRAINT 
-- Get the name of the constraint from \d <tablename> under Indexes
ALTER TABLE person DROP CONSTRAINT "person_pkey";
-- ADD PRIMARY KEY 
ALTER TABLE person ADD PRIMARY KEY (id);

-- Unique Constraint - unique value per column
ALTER TABLE person ADD CONSTRAINT <constraint-name> UNIQUE(email);

-- Check constraint
ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK(gender = 'Female' OR gender = 'Male');


-- FOR DELETE AND UPDATE YOU ALWAYS MIGHT WANNA HAVE WHERE CLAUSE UNLESS YOU'RE TRYING TO DELETE OR UPDATE THE ENTIRE TABLE

-- Delete records 
DELETE FROM person 
WHERE id = 2;

-- Delete all records from person
DELETE FROM person;

-- Update Records
UPDATE person
SET email = 'adey@gmail.com', lastName = 'Montana' 
WHERE id = 5;

-- Update all records
UPDATE person 
SET lastName = 'Montana';

-- ON CONFLICT () DO NOTHING - prevents from throwing errors when you try to insert duplicate values into columns with unique constraint, make sure the columns you enter into ON CONFLICT() should always have a unique constraint, so on conflict instead of throwing error it just does nothing and inserts nothing
INSERT INTO person (id, firstName, lastName, gender, email, dateOfBirth, countryofbirth)
VALUES (17, 'Sorky', 'Hadle', 'Male', 'adey@gmail.com', DATE '1962-02-02', 'Poland')
ON CONFLICT (id,  email) DO NOTHING;

-- Upsert -  In some scenarios when you get two inserts consequently you might want the db to take the latest values rather than doing nothing on conflict. EXCLUDED.<column-name> indicates the latest value. Below it only updates firstname, lastname, email but leaves the dateofbirth unchanged. 
INSERT INTO person (id, firstName, lastName, gender, email, dateOfBirth, countryofbirth)
VALUES (17, 'Rusty', 'Hadle', 'Male', 'rusty@gmail.com', DATE '1962-02-02', 'Poland')
ON CONFLICT (id) DO UPDATE
SET firstName = EXCLUDED.firstName, lastName = EXCLUDED.lastName, email = EXCLUDED.email;

-- Foreign keys - REFERENCES <table-name> (<column-name(s)>), we  also added a unique constraint on car_id to make sure that a car has only one owner. When you try to set a car_id that doesn't exist in car table, it throws an error
create table person (
    id BIGSERIAL NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(7) NOT NULL,
	email VARCHAR(100),
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL,
	car_id BIGINT REFERENCES car (id),
    UNIQUE(car_id)
); 


-- IS NULL / IS NOT NULL - to check if a column is equal to NULL
SELECT * FROM person WHERE car_id IS NULL;

-- Inner Joins ( A ^ B ) intersection- effective way to combine two tables
-- (person.id, person.first_name, person.last_name, person.gender, person.email, person.date_of_birth, person.country_of_birth, person.car_id, car.make, car.model, car.price)
SELECT * FROM 
person JOIN car on person.car_id = car.id;
 
SELECT person.first_name, car.make, car.model, car.price
FROM
person JOIN car on person.car_id = car.id;


-- Left Joins (A + A ^ B) All in A and intersection from B
SELECT * FROM
person LEFT JOIN car on person.car_id = car.id;

SELECT * FROM
person LEFT JOIN car on person.car_id = car.id
WHERE car.* IS NULL;

-- Right Joins (A ^ B + B) All in B and intersection from A
SELECT * FROM
person RIGHT JOIN car on person.car_id = car.id;

-- Deleting a car when it has a person has a Foreign key to car violates the foreign key constraint(error). So make sure no person has a relation to the car you want to delete before you try deleting the car
UPDATE person
SET car_id = NULL
WHERE car_id = 3;

DELETE FROM car 
WHERE id = 3;

-- Exporting query results to csv
\copy (SELECT * FROM person LEFT JOIN car on person.car_id = car.id) TO './left-join.csv' DELIMITER ',' CSV HEADER;

-- Serial & Sequences
-- To get the last value of a  sequence
SELECT * FROM <sequence-name>;

-- To invoke a call to sequence without insertion, you can get the next-val command under Default value from \d <table-name>
SELECT nextval('person_id_seq'::regclass);

-- Once invoked the sequence increments and the next insert will take the next value after the invoke. So to reset
 ALTER SEQUENCE <sequence-name> RESTART <next-val-you-want>;

-- Show all available extensions
SELECT * FROM pg_available_extensions;

-- Install a extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Show list of available functions
\df

-- UUID Data type

-- generate uuide_v4
SELECT uuid_generate_v4();

-- Checkout person-car.sql to see how to create tables with uuid and insert into them

-- USING KEYWORD instead of ON  when the foreign key column name is same in both tables
SELECT * FROM
person JOIN car 
USING (car_uid);

-- VISIT THIS FOR MORE ON POSTGRES JOINS: https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-joins/

-- TRANSACTIONS
-- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-transaction/

-- SQL FUNCTIONS
-- https://www.postgresqltutorial.com/postgresql-plpgsql/postgresql-create-function/

-- TRIGGERS
-- https://www.postgresqltutorial.com/postgresql-triggers/introduction-postgresql-trigger/

-- A trigger is a special user-defined function associated with a table. To create a new trigger, you define a trigger function first, and then bind this trigger function to a table. The difference between a trigger and a user-defined function is that a trigger is automatically invoked when a triggering event occurs.

-- CURSORS
-- https://www.postgresqltutorial.com/postgresql-plpgsql/plpgsql-cursor/


-- ************************************************************
-- Derek Banas PostgreSQL Tutorial Full Course 2022 on Youtube:
-- DB for reference: sales_db

 
-- VIEWS
-- A view is a named query that provides another way to present data in the database tables. A view is defined based on one or more tables which are known as base tables. When you create a view, you basically create a query and assign a name to the query. Therefore, a view is useful for wrapping a commonly used complex query.

CREATE VIEW purchase_order_overview AS
SELECT sales_order.purchase_order_number, customer.company, 
sales_item.quantity, product.supplier, product.name, item.price, 
--Can’t use total if you want this to be updated Fix Below
(sales_item.quantity * item.price) AS Total,
--Remove concat if you want this to be updatable 
CONCAT(sales_person.first_name, ' ', sales_person.last_name) AS Salesperson
FROM sales_order     -- Join some tables
JOIN sales_item
ON sales_item.sales_order_id = sales_order.id    -- Tables go together by joining on sales order id
-- Any time you join tables you need to find foreign and primary keys that match up
JOIN item
ON item.id = sales_item.item_id    -- Join item as well using matching item id
JOIN customer
ON sales_order.cust_id = customer.id 
JOIN product
ON product.id = item.product_id
JOIN sales_person
ON sales_person.id = sales_order.sales_person_id
ORDER BY purchase_order_number;


-- A PostgreSQL view is updatable when it meets the following conditions:
-- The defining query of the view must have exactly one entry in the FROM clause, which can be a table or another updatable view.
-- The defining query must not contain one of the following clauses at the top level: GROUP BY, HAVING, LIMIT, OFFSET, DISTINCT, WITH, UNION, INTERSECT, and EXCEPT.
-- The selection list must not contain any window function , any set-returning function, or any aggregate function such as SUM, COUNT, AVG, MIN, and MAX.
-- An updatable view may contain both updatable and non-updatable columns. If you try to insert or update a non-updatable column, PostgreSQL will raise an error.

-- When you execute an update operation such as INSERT, UPDATE or DELETE, PosgreSQL will convert this statement into the corresponding statement of the underlying table.

-- In case you have a WHERE condition in the defining query of a view, you still can update or delete the rows that are not visible through the view. However, if you want to avoid this, you can use CHECK OPTION when you define the view.
-- Updatable views allow you to issue INSERT, UPDATE, and DELETE statements to update data in the base tables through the views.


-- PROCEDURES
-- A procedure is a database object similar to a function. The key differences are:

-- Procedures are defined with the CREATE PROCEDURE command, not CREATE FUNCTION.

-- Procedures do not return a function value; hence CREATE PROCEDURE lacks a RETURNS clause. However, procedures can instead return data to their callers via output parameters.

-- While a function is called as part of a query or DML command, a procedure is called in isolation using the CALL command.

-- A procedure can commit or roll back transactions during its execution (then automatically beginning a new transaction), so long as the invoking CALL command is not part of an explicit transaction block. A function cannot do that.

-- Certain function attributes, such as strictness, don't apply to procedures. Those attributes control how the function is used in a query, which isn't relevant to procedures.

-- The explanations in the following sections about how to define user-defined functions apply to procedures as well, except for the points made above.

-- Collectively, functions and procedures are also known as routines. There are commands such as ALTER ROUTINE and DROP ROUTINE that can operate on functions and procedures without having to know which kind it is. Note, however, that there is no CREATE ROUTINE command.

