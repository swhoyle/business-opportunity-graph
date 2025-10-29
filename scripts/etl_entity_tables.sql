/******************************************
ETL INSERT INTO SCRIPT
This script:
  1. Truncates all entity tables
  2. Inserts fresh data into each
*******************************************/

/* TRUNCATE existing data */
TRUNCATE TABLE entity_state;
TRUNCATE TABLE entity_county;
TRUNCATE TABLE entity_city;
TRUNCATE TABLE entity_community;
TRUNCATE TABLE entity_zipcode;
TRUNCATE TABLE entity_blockgroup;
TRUNCATE TABLE entity_business;

/* =============================
   ENTITY: state
============================= */
INSERT INTO entity_state (id, code, name)
SELECT 1, 'CA', 'California';

/* =============================
   ENTITY: county
============================= */
INSERT INTO entity_county (id, name)
SELECT id, county
FROM county_neighborhoods
WHERE county = 'San Diego';

/* =============================
   ENTITY: city
============================= */
INSERT INTO entity_city (id, name)
SELECT id, city
FROM city_neighborhoods
WHERE county = 'San Diego';

/* =============================
   ENTITY: community
============================= */
INSERT INTO entity_community (id, name)
SELECT id, community
FROM community_neighborhoods
WHERE county = 'San Diego';

/* =============================
   ENTITY: zipcode
============================= */
INSERT INTO entity_zipcode (zipcode)
SELECT DISTINCT CAST(unnest(zipcodes) AS TEXT)
FROM city_neighborhoods
WHERE county = 'San Diego'

UNION

SELECT DISTINCT CAST(unnest(zipcodes) AS TEXT)
FROM community_neighborhoods
WHERE county = 'San Diego';

/* =============================
   ENTITY: blockgroup
============================= */
INSERT INTO entity_blockgroup
SELECT
       sbg.ctblockgroup,
       sbg.geom,
       cs.X1001FY_X,
       S23_EMP,
       N01_BUS,
       cs.X1024_X,
       S22_BUS,
       N14_BUS,
       N37_SALES,
       N35_BUS,
       S16_SALES,
       MEDHINC_CY,
       AVGHINC_CY,
       GINI_FY,
       INDMANU_CY,
       TOTPOP_CY,
       FEM25,
       FEM30,
       FEM35,
       MALE25,
       MALE30,
       MALE35,
       CRMCYTOTC,
       DI100_CY,
       DI150_CY,
       countyfp,
       tractce,
       population,
       apportionm,
       blkgrpce,
       sbg.ogc_fid,
       statefp,
       aggregatio,
       source_cou
FROM sandag_layer_census_block_groups sbg
LEFT JOIN bgs_sd_imp imp
    ON CAST(sbg.ctblockgroup AS TEXT) = CAST(CONCAT(LTRIM(imp.tractce, '0'), imp.blkgrpce) AS TEXT)
LEFT JOIN esri_business_data bd
    ON TRIM(LEADING '0' FROM SUBSTR(CAST(bd.std_geography_id AS TEXT), 5)) = CAST(sbg.ctblockgroup AS TEXT)
LEFT JOIN esri_consumer_spending_cols cs
    ON TRIM(LEADING '0' FROM SUBSTR(CAST(cs.std_geography_id AS TEXT), 5)) = CAST(sbg.ctblockgroup AS TEXT)
ORDER BY sbg.ctblockgroup ASC;

/* =============================
   ENTITY: business
============================= */
INSERT INTO entity_business (
    id, name, url, address, city, zip,
    latitude, longitude, blockgroup, categories,
    avg_rating, franchise, confidence, reasoning, geom
)
SELECT
    id,
    name,
    url,
    address,
    city,
    zip,
    latitude,
    longitude,
    blockgroup,
    categories,
    avg_rating,
    franchise,
    confidence,
    reasoning,
    geom
FROM nourish.public.ca_businesses_with_ai_franchise
LIMIT 2000;
