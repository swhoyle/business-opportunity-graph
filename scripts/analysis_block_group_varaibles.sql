SELECT
    'ArcGIS_Schema' as source_table,
    "Variable_Category" as variable_category,
    "VariableName" as variable_name,
    "LongName" as variable_desc,
    LEFT("LongName", 4) as year
FROM "ArcGIS_Schema"

UNION

SELECT
    'reduced_esri_variable_set' as source_table,
    variable_category,
    variablename as variable_name,
    longname as variable_desc,
    year
FROM reduced_esri_variable_set

UNION

SELECT
    'reduced_esri_variable_set' as source_table,
    data_collection as variable_category,
    name as variable_name,
    description as variable_desc,
    vintage as year
FROM enrich_variables