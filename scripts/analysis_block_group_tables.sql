-- Are there any tables that have block group?
SELECT * FROM information_schema.columns WHERE column_name ILIKE '%block%' and column_name ILIKE '%group%'

-- (1) sandag_layer_census_block_groups
-- 2057 Unique Block Groups + geom shape data
-- ctblock group and ogc_fid are unique primary keys
SELECT * FROM sandag_layer_census_block_groups
SELECT COUNT(*) FROM sandag_layer_census_block_groups
SELECT COUNT(DISTINCT ctblockgroup) FROM sandag_layer_census_block_groups
SELECT COUNT(DISTINCT ogc_fid) FROM sandag_layer_census_block_groups

-- (2) nourish_community_block_group_intersection
-- List of community names and intersecting block groups
-- 636 rows but 204 unique community names (there are duplicate intersected block groups)
-- What is ogc_fid? That is the primary key.
-- ogc_fid shows up in alot of other tables, including (1) sandag_layer_census_block_groups
/*
How can each row in sandag_layer_census_block_groups represent a block group
and each row in nourish_community_block_group_intersection also represent a block group
but there is intersected_block_groups?

What exactly is this table showing? What is ogc_fid mean?
 */
SELECT * FROM nourish_community_block_group_intersection;
SELECT COUNT(*) FROM nourish_community_block_group_intersection;
SELECT COUNT(DISTINCT name) FROM nourish_community_block_group_intersection;
SELECT COUNT(DISTINCT ogc_fid) FROM nourish_community_block_group_intersection;
SELECT name, COUNT(*) FROM nourish_community_block_group_intersection GROUP BY name HAVING COUNT(*) > 1;
SELECT * FROM nourish_community_block_group_intersection WHERE name = 'EL CAJON UNINCORPORATED';
SELECT * FROM information_schema.columns WHERE column_name ilike '%ogc_fid%'
SELECT ogc_fid, name, unnest(intersected_block_groups) FROM nourish_community_block_group_intersection

-- (3) nourish_blockgroup_stores
-- List of stores per block group
-- I don't think we need to use this. We have a business table and will link to block group based on geo data.
SELECT * FROM nourish_blockgroup_stores
SELECT COUNT(*) FROM nourish_blockgroup_stores

-- ESRI Block Group Tables
-- (see analysis_esri_tables.sql for more details)
-- esri_business_data: 1000 Block Groups
-- esri_consumer_spending_data_: 1000 Block Groups