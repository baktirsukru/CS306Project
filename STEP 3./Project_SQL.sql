use outdoor_pollution;

/* Part 1.a */
CREATE VIEW percentage_under_4
AS SELECT country_id, percentage, year
FROM percentage_of_deaths_by_air_pollution
WHERE percentage < 4;

CREATE VIEW causes_of_death_view AS
SELECT country_id, Years, Outdoor_air_pollution
FROM CAUSES_OF_DEATH
WHERE Outdoor_air_pollution > 999;

CREATE VIEW pollution_rates_age_under_5 AS
SELECT country_id, year, death_under_5
FROM pollution_rates_age
WHERE death_under_5 > 50;

CREATE VIEW Death_rates_from_ozone_and_particulate_matter_polution_VIEW AS
SELECT country_id , year , MatterPollution , OzonePollution
FROM Death_rates_from_ozone_and_particulate_matter_polution
WHERE MatterPollution >= 100 AND OzonePollution >= 6 ;

CREATE VIEW concentrations_VIEW AS
SELECT country_id, year, concentration
FROM concentrations_of_air_pollution
WHERE  concentration > 6e18;


/* Part 1.b */
SELECT country_id, year FROM pollution_rates_age_under_5
WHERE country_id NOT IN (
    SELECT country_id FROM percentage_under_4
);

SELECT p.country_id, p.year
FROM pollution_rates_age_under_5 p
LEFT JOIN percentage_under_4 u ON p.country_id = u.country_id
WHERE u.country_id IS NULL;



/* Part 1.c */
/* 1.c With IN */
SELECT * FROM pollution_rates_age
WHERE country_id IN ( SELECT country_id FROM countries WHERE country_name = 'Turkey'
);

/* 1.c With exits */
SELECT * FROM pollution_rates_age
WHERE EXISTS (
  SELECT 1 FROM countries WHERE country_name = 'Turkey' AND countries.country_id = pollution_rates_age.country_id
);



/* Part 1.d */

/* AVG */
SELECT percentage_of_deaths_by_air_pollution.country_id, 
AVG(percentage_of_deaths_by_air_pollution.percentage) AS avg_percentage, 
AVG(death_rates_from_ozone_and_particulate_matter_polution.MatterPollution) AS avg_matter_pollution,
AVG(death_rates_from_ozone_and_particulate_matter_polution.OzonePollution) AS avg_ozone_pollution
FROM percentage_of_deaths_by_air_pollution
LEFT JOIN death_rates_from_ozone_and_particulate_matter_polution
ON percentage_of_deaths_by_air_pollution.country_id = death_rates_from_ozone_and_particulate_matter_polution.country_id 
GROUP BY percentage_of_deaths_by_air_pollution.country_id 
HAVING avg_percentage > 10;

/* SUM */
SELECT causes_of_death.country_id,
SUM(causes_of_death.Outdoor_air_pollution) AS death_sum,
SUM(pollution_rates_age.death_under_5) AS under5_sum
FROM causes_of_death
LEFT JOIN pollution_rates_age
ON causes_of_death.country_id = pollution_rates_age.country_id
GROUP BY causes_of_death.country_id, causes_of_death.Years
HAVING death_sum > 999;

/* MAX */
SELECT concentrations_of_air_pollution.country_id, 
max(concentrations_of_air_pollution.Concentration) AS Max_Concentration, 
max(Death_rates_from_ozone_and_particulate_matter_polution.MatterPollution) AS Max_MatterPollution, 
max(Death_rates_from_ozone_and_particulate_matter_polution.OzonePollution) AS Max_OzonePollution
FROM concentrations_of_air_pollution
LEFT JOIN Death_rates_from_ozone_and_particulate_matter_polution ON 
concentrations_of_air_pollution.country_id = Death_rates_from_ozone_and_particulate_matter_polution.country_id 
GROUP BY concentrations_of_air_pollution.country_id 
HAVING Max_Concentration >= 6e18 ;

/* MIN */
SELECT concentrations_of_air_pollution.country_id, 
min(concentrations_of_air_pollution.Concentration) AS Min_Concentration, 
min(Death_rates_from_ozone_and_particulate_matter_polution.MatterPollution) AS Min_MatterPollution, 
min(Death_rates_from_ozone_and_particulate_matter_polution.OzonePollution) AS Min_OzonePollution
FROM concentrations_of_air_pollution 
LEFT JOIN Death_rates_from_ozone_and_particulate_matter_polution ON 
concentrations_of_air_pollution.country_id = Death_rates_from_ozone_and_particulate_matter_polution.country_id 
GROUP BY concentrations_of_air_pollution.country_id 
HAVING Min_Concentration <= 6e18 ;

/* COUNT */
SELECT pollution_rates_age_under_5.country_id, count(*) AS total
FROM pollution_rates_age_under_5 
GROUP BY pollution_rates_age_under_5.country_id
HAVING total > 10 ;


/* Part 2 */
SELECT MIN(percentage) AS min_perc, MAX(percentage) AS max_perc FROM percentage_of_deaths_by_air_pollution;

ALTER TABLE percentage_of_deaths_by_air_pollution ADD CONSTRAINT chk_percentage_range CHECK 
(percentage >= 0.23
AND percentage <= 17.20
);

INSERT INTO percentage_of_deaths_by_air_pollution (country_id, year, percentage) VALUES (1, 2020, 18);

DELIMITER $$

CREATE TRIGGER tr_insert BEFORE INSERT ON percentage_of_deaths_by_air_pollution FOR EACH ROW
BEGIN
  IF NEW.percentage < 0.24 THEN
    SET NEW.percentage = 0.24;
  ELSEIF NEW.percentage > 17.19 THEN
    SET NEW.percentage = 17.19;
  END IF;
END $$

CREATE TRIGGER tr_update BEFORE UPDATE ON percentage_of_deaths_by_air_pollution FOR EACH ROW
BEGIN
  IF NEW.percentage < 0.24 THEN
    SET NEW.percentage = 0.24;
  ELSEIF NEW.percentage > 17.19 THEN
    SET NEW.percentage = 17.19;
  END IF;
END $$

DELIMITER ;

INSERT INTO percentage_of_deaths_by_air_pollution (country_id, year, percentage) VALUES (1, 2020, 18);

/* Part 2 End */



/* Part 3 */
DELIMITER $$
CREATE PROCEDURE get_data(IN c_name VARCHAR(255))
BEGIN
	SELECT * FROM pollution_rates_age
    WHERE pollution_rates_age.country_id = (
    SELECT country_id FROM countries where c_name = countries.country_name);
END $$
DELIMITER ;

CALL get_data("Turkey");
CALL get_data("Albania");

