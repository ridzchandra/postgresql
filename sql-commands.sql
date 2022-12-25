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

-- Create a new postgres user
CREATE USER <username> WITH PASSWORD '<password>';

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
ALTER TABLE person DROP CONSTRAINT 'person_pkey';
-- ADD PRIMARY KEY 
ALTER TABLE person ADD PRIMARY KEY (id);

-- Unique Constraint - unique value per column
ALTER TABLE person ADD CONSTRAINT <constraint-name> UNIQUE(email);

-- Check constraint
ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK(gender = 'Female' OR gender = 'Male');


-- FOR DELETE AND UPDATE YOU ALWAYS MIGHT WANNA HAVE WHERE CLAUSE UNLESS YOU'RE TRYINGTO DELETE OR UPDATE THE ENTIRE TABLE

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

-- Upsert -  In some scenarios when you get two inserts consequently you might want the db to take the latest values rather than doing nothing on conflict. EXCLUDED.<column-name> indicates the lasstes value. Below it only updates firstname, lastname, email but leaves the dateofbirth unchanged. 
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
WHERE id = 3;

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