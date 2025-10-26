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
WHERE county = 'San Diego';

ALTER TABLE entity_zipcode
ADD COLUMN geom geometry(Geometry, 4326);

ALTER TABLE entity_zipcode
ADD COLUMN perimeter DOUBLE PRECISION;

ALTER TABLE entity_zipcode
ADD COLUMN area DOUBLE PRECISION;

UPDATE entity_zipcode
SET
    geom = ST_Transform(s.geom, 4326),
    perimeter = s.shape_length,
    area = s.shape_area
FROM nourish.public.test_zipcodes s
WHERE entity_zipcode.zipcode = s.zip::text;


-- ENTITY: block groups
DROP TABLE IF EXISTS entity_blockgroup;
CREATE TABLE entity_blockgroup AS
select sbg.ctblockgroup,
       sbg.geom,
       cs.X1001FY_X as "n_2027BudgetExpenditures",
       S23_EMP as "n_2021ServiceEmployees",
       N01_BUS as "n_2021TotalBusinesses",
       cs.X1024_X as "n_2022BeefSpending",
       S22_BUS as "n_2021RealEstateHolding",
       N14_BUS as "n_2021HealthCare",
       N37_SALES as "n_2021FoodandDrinkSales",
       N35_BUS as "n_2021AccommodationFoodServices",
       S16_SALES as "n_2021EatingandDrinkingSales",
       MEDHINC_CY as "n_2023MedianIncome",
       AVGHINC_CY as "n_2023AverageIncome",
       GINI_FY as "n_2028GiniIndex",
       INDMANU_CY as "n_2023Manufacturing",
       TOTPOP_CY as "n_2023TotalPop",
       FEM25,
       FEM30,
       FEM35,
       MALE25,
       MALE30,
       MALE35,
       CRMCYTOTC as "n_2023TotalCrimeIndex",
       DI100_CY as"n_2023DisposableIncome100-149k",
       DI150_CY as "n_2023DisposableIncomme150k",
       countyfp,
       tractce,
       population,
       apportionm,
       blkgrpce,
       sbg.ogc_fid,
       statefp,
       aggregatio,
       source_cou
       from sandag_layer_census_block_groups sbg
LEFT JOIN "bgs_sd_imp" imp ON CAST(sbg.ctblockgroup AS TEXT) = CAST(CONCAT(LTRIM(imp.tractce, '0'), imp.blkgrpce) AS TEXT)
left join esri_business_data bd ON TRIM(LEADING '0' FROM SUBSTR(CAST(bd.std_geography_id AS TEXT), 5)) = CAST(sbg.ctblockgroup AS TEXT)
left join esri_consumer_spending_cols cs on TRIM(LEADING '0' FROM SUBSTR(CAST(cs.std_geography_id AS TEXT), 5)) = CAST(sbg.ctblockgroup AS TEXT)
order by sbg.ctblockgroup asc;


-- ENTITY: business
DROP TABLE IF EXISTS entity_business;
CREATE TABLE entity_business AS
SELECT *
FROM nourish.public.ca_businesses_with_ai_franchise
LIMIT 2000;
