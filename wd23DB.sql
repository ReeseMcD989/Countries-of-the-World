-- The purpose of this PostgresSQL script is to create a relational database with the five separate csv files that were divided 
-- from wd23 (variable that stores cleaned and transformed world-data-2023.csv data) from the python script in this same repository.

-- First I create empty tables by the same names and columns/data types as the csvs that were written. I then use the command prompt to copy the csv data
-- (from the csv files) from the directory where they reside to the tables of corresponding name and columns.

-- Next, I link all five tables by primary and foreign key assignment using the columns 'country', 'abbreviation', and 'row_number'.

-- Lastly, I create some queries of varying complexity to showcase my ability to extract information from a RDB using SQL.

DROP TABLE IF EXISTS wd23_categorical;

CREATE TABLE wd23_categorical (
    country VARCHAR(40),
    abbreviation VARCHAR(5) PRIMARY KEY,
    calling_code FLOAT,
	"capital/major_city" VARCHAR(40),
	currency_code VARCHAR(10),
	largest_city VARCHAR(40),
	official_language VARCHAR(40)
);

DROP TABLE IF EXISTS wd23_geo;

CREATE TABLE wd23_geo (
	abbreviation VARCHAR(5),
	"row_number" FLOAT PRIMARY KEY,
	"agricultural_land_%" FLOAT,
	land_area_km2 FLOAT,
	"forested_area_%" FLOAT,
	latitude FLOAT,
	longitude FLOAT
);

DROP TABLE IF EXISTS wd23_pop;

CREATE TABLE wd23_pop (
	abbreviation VARCHAR(5),
	"row_number" FLOAT PRIMARY KEY,
	"density_p/km2" FLOAT,
	"armed_forces_size_%" FLOAT,
	population FLOAT,
	"urban_population_%" FLOAT
);

DROP TABLE IF EXISTS wd23_health;

CREATE TABLE wd23_health (
	"row_number" FLOAT,
	birth_rate FLOAT,
	fertility_rate FLOAT,
	infant_mortality FLOAT,
	life_expectancy FLOAT,
	maternal_mortality_ratio FLOAT,
	oop_health_expense FLOAT,
	physicians_per_thousand FLOAT
);

DROP TABLE IF EXISTS wd23_econ;

CREATE TABLE wd23_econ (
	"row_number" FLOAT,
	cpi FLOAT,
	"cpi_change_%" FLOAT,
	gasoline_price FLOAT,
	gdp FLOAT,
	co2_emissions FLOAT,
	"gpe_enrollment_%" FLOAT,
	"gth_enrollment_%" FLOAT,
	minimum_wage FLOAT,
	"lf_participation_%" FLOAT,
	"tax_revenue_%" FLOAT,
	total_tax_rate FLOAT,
	unemployment_rate FLOAT
);

-- Now to add primary and foreign keys to each table so they relate and can be joined.

ALTER TABLE wd23_geo
ADD FOREIGN KEY(abbreviation)
REFERENCES wd23_categorical(abbreviation)
ON DELETE CASCADE;

ALTER TABLE wd23_pop
ADD FOREIGN KEY(abbreviation)
REFERENCES wd23_categorical(abbreviation)
ON DELETE CASCADE;

ALTER TABLE wd23_health
ADD FOREIGN KEY("row_number")
REFERENCES wd23_pop("row_number")
ON DELETE CASCADE;

ALTER TABLE wd23_econ
ADD FOREIGN KEY("row_number")
REFERENCES wd23_geo("row_number")
ON DELETE CASCADE;

-- This next section is necessary due to an issue with permissions that has yet to be resolved.
-- Run the following commands from the command prompts in order to populate the tables that were just created with the .csv data:

-- psql -h localhost -p 5432 -U postgres -d "First Database"
-- \copy wd23_categorical FROM 'C:\Users\rsmcd\OneDrive\Desktop\Github Showcase\Countries-of-the-World\wd23_categorical.csv' DELIMITER ',' CSV HEADER;
-- \copy wd23_econ FROM 'C:\Users\rsmcd\OneDrive\Desktop\Github Showcase\Countries-of-the-World\wd23_econ.csv' DELIMITER ',' CSV HEADER;
-- \copy wd23_geo FROM 'C:\Users\rsmcd\OneDrive\Desktop\Github Showcase\Countries-of-the-World\wd23_geo.csv' DELIMITER ',' CSV HEADER;
-- \copy wd23_health FROM 'C:\Users\rsmcd\OneDrive\Desktop\Github Showcase\Countries-of-the-World\wd23_health.csv' DELIMITER ',' CSV HEADER;
-- \copy wd23_pop FROM 'C:\Users\rsmcd\OneDrive\Desktop\Github Showcase\Countries-of-the-World\wd23_pop.csv' DELIMITER ',' CSV HEADER;

-- Run one line at a time from the SELECT statements below to ensure that the command prompts populated the tables in this environment

SELECT * FROM wd23_categorical;
SELECT * FROM wd23_geo;
SELECT * FROM wd23_pop;
SELECT * FROM wd23_health;
SELECT * FROM wd23_econ;

-- The next two queries demonstrate that the two branches of the data set were successfuly linked by primary and foreign key by joining them and returning all columns
-- from all tables.

SELECT *
FROM wd23_categorical
INNER JOIN wd23_geo ON wd23_categorical.abbreviation = wd23_geo.abbreviation
INNER JOIN wd23_econ ON wd23_geo."row_number" = wd23_econ."row_number";

SELECT *
FROM wd23_categorical
INNER JOIN wd23_pop ON wd23_categorical.abbreviation = wd23_pop.abbreviation
INNER JOIN wd23_health ON wd23_pop."row_number" = wd23_health."row_number";

-- This query demonstrates how joins can be used to return all columns of every table in the database.

SELECT *
FROM wd23_categorical
INNER JOIN wd23_geo ON wd23_categorical.abbreviation = wd23_geo.abbreviation
INNER JOIN wd23_econ ON wd23_geo."row_number" = wd23_econ."row_number"
INNER JOIN wd23_pop ON wd23_categorical.abbreviation = wd23_pop.abbreviation
INNER JOIN wd23_health ON wd23_pop."row_number" = wd23_health."row_number";


























-- TBC...
-------------------------------------------------------