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
WHERE county = 'San Diego';


-- ENTITY: city
DROP TABLE IF EXISTS entity_city;
CREATE TABLE entity_city AS
SELECT
    id,
    city as name
    --,summary_description as description
FROM city_neighborhoods
WHERE county = 'San Diego';

-- ENTITY: community
DROP TABLE IF EXISTS entity_community;
CREATE TABLE entity_community AS
SELECT
    id,
    community as name
    --,summary_description as description
FROM community_neighborhoods
WHERE county = 'San Diego';

-- ENTITY: zipcode
DROP TABLE IF EXISTS entity_zipcode;
CREATE TABLE entity_zipcode AS
SELECT
    DISTINCT CAST(unnest(zipcodes) AS TEXT) AS zipcode
FROM city_neighborhoods
WHERE county = 'San Diego'

UNION

SELECT
    DISTINCT CAST(unnest(zipcodes) AS TEXT) AS zipcode
FROM community_neighborhoods
WHERE county = 'San Diego'