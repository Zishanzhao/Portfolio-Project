Data_Cleaning_Project [Using_Automobile_data]

/* Cleaning Data in SQL Queries */

SELECT *
FROM `project-1-366402.Cars.Automobile_data`;

------------------------------------------------------------------

/* Replace '?' string with NULL */

--We must convert '?' to NULL so it does not hinder conversions from string to integer/float data. 

UPDATE `project-1-366402.Cars.Automobile_data`
SET normalized_losses = NULL WHERE normalized_losses = '?';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_doors = NULL WHERE num_of_doors = '?';

UPDATE `project-1-366402.Cars.Automobile_data`
SET bore = NULL WHERE bore = '?';

UPDATE `project-1-366402.Cars.Automobile_data`
SET stroke = NULL WHERE stroke = '?';

UPDATE `project-1-366402.Cars.Automobile_data`
SET horsepower = NULL WHERE horsepower = '?';

UPDATE `project-1-366402.Cars.Automobile_data`
SET peak_rpm = NULL WHERE peak_rpm = '?';

UPDATE `project-1-366402.Cars.Automobile_data`
SET price = NULL WHERE price = '?';
  
------------------------------------------------------------------

/* Modify Table Schemas */

--Convert [normalized_losses] from string to integer so the data can be sorted. 

SELECT
  CAST(normalized_losses AS int64) 
FROM
  `project-1-366402.Cars.Automobile_data`;

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (normalized_losses),
  CAST(normalized_losses AS int64) AS normalized_losses
  FROM `project-1-366402.Cars.Automobile_data`;

--Convert [num_of_cylinders] from string to integer

SELECT DISTINCT(num_of_cylinders)
FROM `project-1-366402.Cars.Automobile_data`;

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '6' WHERE num_of_cylinders = 'six';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '8' WHERE num_of_cylinders = 'eight';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '3' WHERE num_of_cylinders = 'three';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '2' WHERE num_of_cylinders = 'two';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '12' WHERE num_of_cylinders = 'twelve';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '4' WHERE num_of_cylinders = 'four';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_cylinders = '5' WHERE num_of_cylinders = 'five';

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (num_of_cylinders),
  CAST(num_of_cylinders AS int64) AS num_of_cylinders
  FROM `project-1-366402.Cars.Automobile_data`;

--Convert [horsepower] from string to integer

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (horsepower),
  CAST(horsepower AS int64) AS horse_power
  FROM `project-1-366402.Cars.Automobile_data`;

--Convert [peak_rpm] from string to integer

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (peak_rpm),
  CAST(peak_rpm AS int64) AS peak_rpm
  FROM `project-1-366402.Cars.Automobile_data`;

--Convert [price] from string to integer

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (price),
  CAST(price AS int64) AS price
  FROM `project-1-366402.Cars.Automobile_data`;

--Convert [bore] from string to float

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (bore),
  CAST(bore AS float64) AS bore
  FROM `project-1-366402.Cars.Automobile_data`;

--Convert [stroke] from string to float

CREATE OR REPLACE TABLE `project-1-366402.Cars.Automobile_data` AS
SELECT * EXCEPT (stroke),
  CAST(stroke AS float64) AS stroke
  FROM `project-1-366402.Cars.Automobile_data`;

------------------------------------------------------------------

/* Checking and Fixing Typos/Inconsistencies */

SELECT
  DISTINCT(drive_wheels)
FROM `project-1-366402.Cars.Automobile_data`;

--Results show fwd and 4wd. They both stand for 4-wheel drive, so change is made for consistency.--

UPDATE `project-1-366402.Cars.Automobile_data`
SET drive_wheels = 'fwd'
WHERE drive_wheels = '4wd';

SELECT
  DISTINCT(fuel_system)
FROM `project-1-366402.Cars.Automobile_data`;

--mfi is not a fuel system. 

UPDATE `project-1-366402.Cars.Automobile_data`
SET fuel_system = 'mpfi'
WHERE fuel_system = 'mfi';

------------------------------------------------------------------

/* Identify and Fill in Missing Data */

SELECT*
FROM `project-1-366402.Cars.Automobile_data`
WHERE num_of_doors IS NULL;

--All Mazda/Diesel/Sedans and Dodge/Gas/Sedans sold had four doors. 

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_doors = 'four'
WHERE make='mazda' AND fuel_type='diesel' AND body_style='sedan';

UPDATE `project-1-366402.Cars.Automobile_data`
SET num_of_doors = 'four'
WHERE make='dodge' AND fuel_type='gas' AND body_style='sedan';
------------------------------------------------------------------

/* Check that min and max [length] align with the data [length is continuous from 141.1 to 208.1] */

SELECT
  min(length) AS min_length,
  max(length) AS max_length
FROM `project-1-366402.Cars.Automobile_data`;
 
--min and max [length] aligns with the data. 

------------------------------------------------------------------

/* Identify and Delete Incorrect Data [compression-ration is continuous from 7 to 23] */

SELECT
  min(compression_ratio) AS min_compression_ratio,
  max(compression_ratio) AS max_compression_ratio
FROM `project-1-366402.Cars.Automobile_data`;
 
--The maximum in incorrect, run the query again without the row(s) containing a compression_ratio of 70 to make sure the rest of the values fall within range. 

SELECT
  min(compression_ratio) AS min_compression_ratio,
  max(compression_ratio) AS max_compression_ratio
FROM `project-1-366402.Cars.Automobile_data`
WHERE compression_ratio <> 70;

--Now the range is correct, we must find the number of rows containing the erroneous compression_ratio = 70 and delete them. 

SELECT COUNT(*) AS num_of_rows_to_delete
FROM `project-1-366402.Cars.Automobile_data`
WHERE compression_ratio = 70;

DELETE `project-1-366402.Cars.Automobile_data`
WHERE compression_ratio = 70;

