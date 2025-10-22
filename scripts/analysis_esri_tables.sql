-- View ESRI Tables
SELECT table_name
FROM information_schema.tables
WHERE table_catalog = 'nourish' AND table_schema = 'public' AND table_name ILIKE '%ESRI%'
ORDER BY table_name;

-- (1) ESRI_SD_County_Tract_Level_Market_Potential_Data
--> NO DATA
SELECT * FROM "ESRI_SD_County_Tract_Level_Market_Potential_Data"

-- (2) ESRI_SD_County_Tract_Level_business_data
--> 736 Unique Tracts + 2021 business, employee, sales data
--> Contains shape of Tract with "rings" and geo data
SELECT * FROM "ESRI_SD_County_Tract_Level_business_data"
SELECT COUNT(*) FROM "ESRI_SD_County_Tract_Level_business_data"
SELECT COUNT(DISTINCT std_geography_id) FROM "ESRI_SD_County_Tract_Level_business_data"

-- (3) ESRI_SD_County_Tract_Level_consumer_spending
--> NO DATA
SELECT * FROM "ESRI_SD_County_Tract_Level_consumer_spending"

-- (4) esri_business_data
--> 1000 Unique Block Groups + 2021 business, employee, sales data
--> Does not contain shape or geo data
SELECT * FROM esri_business_data
SELECT COUNT(*) FROM esri_business_data
SELECT COUNT(DISTINCT std_geography_id) FROM esri_business_data

-- (5) esri_consumer_spending_data_
--> 1000 Unique Block Groups + 2022 consumer spending data
--> Same Block Groups as (4) esri_business_data
--> Contains shape of Tract with "rings" and geo data
SELECT * FROM esri_consumer_spending_data_
SELECT COUNT(*) - 1 FROM esri_consumer_spending_data_
SELECT COUNT(DISTINCT c3) - 1 FROM esri_consumer_spending_data_
SELECT * FROM esri_business_data WHERE std_geography_id NOT IN (SELECT std_geography_id FROM esri_consumer_spending_data_);

-- (6) esri_market_potential_data
--> NO DATA
SELECT * FROM esri_market_potential_data

-- (7) reduced_esri_variable_set
--> Descriptions of column names from ESRI tables
--> Data Not complete. ArcGIS_Schema is complete
SELECT * FROM reduced_esri_variable_set
SELECT * FROM reduced_esri_variable_set WHERE variablename ILIKE '%_bus'
SELECT * FROM reduced_esri_variable_set WHERE variablename ILIKE '%_emp'
SELECT * FROM reduced_esri_variable_set WHERE variablename ILIKE '%_sales'
SELECT * FROM reduced_esri_variable_set WHERE variablename ILIKE '%_x'

-- (8) ArcGIS_Schema
--> Descriptions of column names from ESRI tables
SELECT * FROM "ArcGIS_Schema" WHERE "VariableName" ILIKE '%_bus'
SELECT * FROM "ArcGIS_Schema" WHERE "VariableName" ILIKE '%_emp'
SELECT * FROM "ArcGIS_Schema" WHERE "VariableName" ILIKE '%_sales'
SELECT * FROM "ArcGIS_Schema" WHERE "VariableName" ILIKE '%_x'

-- Are there any tables that have geography id?
--> Only the same ESRI tables
SELECT * FROM information_schema.columns WHERE column_name ILIKE '%geography_id%'