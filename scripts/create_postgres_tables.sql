/******************************************
CREATE TABLE SCRIPT
This script:
  - Drops existing entity tables (if they exist)
  - Creates empty entity tables with defined structure
*******************************************/

/* DROP TABLES if they exist */
DROP TABLE IF EXISTS entity_state;
DROP TABLE IF EXISTS entity_county;
DROP TABLE IF EXISTS entity_city;
DROP TABLE IF EXISTS entity_community;
DROP TABLE IF EXISTS entity_zipcode;
DROP TABLE IF EXISTS entity_blockgroup;
DROP TABLE IF EXISTS entity_business;
DROP TABLE IF EXISTS entity_relationships;

/* CREATE TABLES */

-- ENTITY: state
CREATE TABLE entity_state (
    id INT,
    code TEXT,
    name TEXT
);

-- ENTITY: county
CREATE TABLE entity_county (
    id INT,
    name TEXT
);

-- ENTITY: city
CREATE TABLE entity_city (
    id INT,
    name TEXT
);

-- ENTITY: community
CREATE TABLE entity_community (
    id INT,
    name TEXT
);

-- ENTITY: zipcode
CREATE TABLE entity_zipcode (
    zipcode TEXT,
    geom geometry(Geometry, 4326),
    perimeter DOUBLE PRECISION,
    area DOUBLE PRECISION
);

-- ENTITY: blockgroup
CREATE TABLE entity_blockgroup (
    ctblockgroup INTEGER,
    geom GEOMETRY,
    n_2027BudgetExpenditures TEXT,
    n_2021ServiceEmployees NUMERIC,
    n_2021TotalBusinesses NUMERIC,
    n_2022BeefSpending TEXT,
    n_2021RealEstateHolding NUMERIC,
    n_2021HealthCare NUMERIC,
    n_2021FoodandDrinkSales NUMERIC,
    n_2021AccommodationFoodServices NUMERIC,
    n_2021EatingandDrinkingSales NUMERIC,
    n_2023MedianIncome DOUBLE PRECISION,
    n_2023AverageIncome DOUBLE PRECISION,
    n_2028GiniIndex DOUBLE PRECISION,
    n_2023Manufacturing DOUBLE PRECISION,
    n_2023TotalPop DOUBLE PRECISION,
    fem25 DOUBLE PRECISION,
    fem30 DOUBLE PRECISION,
    fem35 DOUBLE PRECISION,
    male25 DOUBLE PRECISION,
    male30 DOUBLE PRECISION,
    male35 DOUBLE PRECISION,
    n_2023TotalCrimeIndex DOUBLE PRECISION,
    "n_2023DisposableIncome100-149k" DOUBLE PRECISION,
    n_2023DisposableIncomme150k DOUBLE PRECISION,
    countyfp VARCHAR,
    tractce VARCHAR,
    population DOUBLE PRECISION,
    apportionm DOUBLE PRECISION,
    blkgrpce VARCHAR,
    ogc_fid INTEGER,
    statefp VARCHAR,
    aggregatio VARCHAR,
    source_cou VARCHAR
);

-- ENTITY: business
CREATE TABLE entity_business (
    id INTEGER,
    name TEXT,
    url TEXT,
    address TEXT,
    city TEXT,
    zip INTEGER,
    latitude NUMERIC,
    longitude NUMERIC,
    blockgroup VARCHAR,
    categories TEXT[],
    avg_rating NUMERIC,
    franchise TEXT,
    confidence DOUBLE PRECISION,
    reasoning TEXT,
    geom GEOMETRY
);

-- ENTITY RELATIONSHPS
CREATE TABLE entity_relationships (
    entity1         TEXT,
    entitytype1     TEXT,
    predicate       TEXT,
    entity2         TEXT,
    entitytype2     TEXT
);


/* GRANT ACCESS TO TABLES */
GRANT ALL PRIVILEGES ON TABLE entity_state TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_county TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_city TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_community TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_zipcode TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_blockgroup TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_business TO swhoyle, fahaque, isgonzal, fchavezsosa;
GRANT ALL PRIVILEGES ON TABLE entity_relationships TO swhoyle, fahaque, isgonzal, fchavezsosa;
