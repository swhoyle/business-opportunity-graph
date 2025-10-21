-- ENTITY: state
DROP TABLE IF EXISTS entity_state;
CREATE TABLE entity_state AS
SELECT
    1 as id,
    'CA' as code,
    'California' as name;

-- ENTITY: county
DROP TABLE IF EXISTS entity_county;
CREATE TABLE entity_county AS
SELECT
    id,
    county as name
FROM county_neighborhoods
WHERE county IN ('San Diego', 'Imperial');

-- ENTITY: city
DROP TABLE IF EXISTS entity_city;
CREATE TABLE entity_city AS
SELECT
    CITY.id,
    CITY.city as name,
    CITY.summary_description as description
FROM city_neighborhoods CITY
JOIN entity_county COUNTY ON CITY.county = COUNTY.name

-- ENTITY: community
DROP TABLE IF EXISTS entity_community;
CREATE TABLE entity_community AS
SELECT
    COMM.id,
    COMM.community as name,
    COMM.summary_description as description
FROM community_neighborhoods COMM
JOIN entity_city CITY ON CITY.name = COMM.city

-- ENTITY: zipcode
DROP TABLE IF EXISTS entity_zipcode;
CREATE TABLE entity_zipcode AS
SELECT
    DISTINCT CAST(unnest(zipcodes) AS TEXT) AS zipcode
FROM city_neighborhoods CM
JOIN entity_city CITY ON CITY.name = CM.city

UNION

SELECT
    DISTINCT CAST(unnest(zipcodes) AS TEXT) AS zipcode
FROM community_neighborhoods CM
JOIN entity_community COMM ON COMM.name = CM.community;