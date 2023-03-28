CREATE DATABASE outdoor_pollution;
use outdoor_pollution;

SET GLOBAL local_infile = 'ON';

create table COUNTRIES(
	country_id INT NOT NULL AUTO_INCREMENT,
    country_name varchar(255),
    country_code varchar(10),
    PRIMARY KEY(country_id)
);

create table PERCENTAGE_OF_DEATHS_BY_AIR_POLLUTION(
	country_id INT,
    year INT NOT NULL,
    percentage FLOAT,
    PRIMARY KEY(country_id, year),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
    
);

create table concentrations_of_air_pollution(
	country_id INT,
    year INT NOT NULL,
    concentration FLOAT,
    PRIMARY KEY(country_id, year),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
    
);

create table pollution_rates_age(
	country_id int,
	year int not null,
	PRIMARY KEY(country_id, year),
	FOREIGN KEY (country_id) REFERENCES countries(country_id),
	death_under_5 float,
	death_5_14 float,
	death_15_49 float,
	death_50_69 float,
	death_over_70 float
);

create table Death_rates_from_ozone_and_particulate_matter_polution(
	country_id INT,
    year INT NOT NULL,
    MatterPollution FLOAT,
    OzonePollution FLOAT,
    PRIMARY KEY(country_id, year),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
    
);
LOAD DATA LOCAL INFILE 'C:/Users/Kemal/Desktop/COUNTRIES.csv'
   INTO TABLE countries
   FIELDS TERMINATED BY ','
   IGNORE 1 ROWS
   (country_name, country_code);

LOAD DATA LOCAL INFILE 'C:/Users/Kemal/Desktop/PERCENTAGE_OF_DEATHS_BY_AIR_POLLUTION.csv'
   INTO TABLE PERCENTAGE_OF_DEATHS_BY_AIR_POLLUTION
   FIELDS TERMINATED BY ','
   IGNORE 1 ROWS
   (@Entity, Year, Percentage)
   SET country_id = (SELECT countries.country_id FROM countries where @Entity = country_name);

LOAD DATA LOCAL INFILE 'C:/Users/Kemal/Desktop/outdoor_pollution_rates_by_age.csv'
   INTO TABLE pollution_rates_age
   FIELDS TERMINATED BY ','
   IGNORE 1 ROWS
   (@Entity, Year, death_under_5, death_5_14, death_15_49, death_50_69, death_over_70)
   SET country_id = (SELECT countries.country_id FROM countries where @Entity = country_name);

LOAD DATA LOCAL INFILE'C:/Users/Kemal/Desktop/Death_rates_from_ozone_and_particulate_matter_polution.csv'
   INTO TABLE Death_rates_from_ozone_and_particulate_matter_polution
   FIELDS TERMINATED BY ','
   IGNORE 1 ROWS
   (@Entity, Year, MatterPollution, OzonePollution)
   SET country_id = (SELECT countries.country_id FROM countries where @Entity = country_name);

LOAD DATA LOCAL INFILE 'C:/Users/Kemal/Desktop/concentrations_of_air_pollution.csv'
   INTO TABLE concentrations_of_air_pollution
   FIELDS TERMINATED BY ','
   IGNORE 1 ROWS
   (@Entity, Year, concentration)
   SET country_id = ((SELECT countries.country_id FROM countries where @Entity = country_name));
						

Create Table causes_of_death(
	Country_name Varchar(100),
	Years INT,
	Outdoor_air_pollution INT,
	High_blood_pressure INT,
	Alcohol_use INT,
	Smoking INT,
	Drug_use INT
);

ALTER TABLE causes_of_death
ADD COLUMN country_id INT;

ALTER TABLE causes_of_death
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id) REFERENCES countries(country_id);

UPDATE causes_of_death cd
INNER JOIN countries c ON c.country_name = cd.Country_name
SET cd.country_id = c.country_id;

ALTER TABLE causes_of_death
DROP COLUMN Country_name;













