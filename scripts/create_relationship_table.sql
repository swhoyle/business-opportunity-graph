-- ENTITY RELATIONSHIPS
DROP TABLE IF EXISTS entity_relationships;
CREATE TABLE entity_relationships AS

-- (county) -> contained_in -> (state)
(
    SELECT
        county AS entity1,
        'county' AS entityType1,
        'contained_in' AS predicate,
        state_name AS entity2,
        'state' AS entityType2
    FROM county_neighborhoods
)

UNION

-- (city) -> contained_in -> (county)
(
    SELECT
        city AS entity1,
        'city' AS entityType1,
        'contained_in' AS predicate,
        county AS entity2,
        'county' AS entityType2
    FROM city_neighborhoods
)

UNION

-- (community) -> contained_in -> (city)
(
    SELECT
        community AS entity1,
        'community' AS entityType1,
        'contained_in' AS predicate,
        city AS entity2,
        'city' AS entityType2
    FROM community_neighborhoods
)

UNION

-- (county) -> adjacent_to -> (county)
(
    SELECT
        county AS entity1,
        'county' AS entityType1,
        'adjacent_to' AS predicate,
        unnest(neighboring_counties) AS entity2,
        'county' AS entityType2
    FROM county_neighborhoods
)

UNION

-- (city) -> adjacent_to -> (city)
(
    SELECT
        city AS entity1,
        'city' AS entityType1,
        'adjacent_to' AS predicate,
        unnest(neighboring_cities) AS entity2,
        'city' AS entityType2
    FROM city_neighborhoods
)

UNION

-- (community) -> adjacent_to -> (community)
(
    SELECT
        community AS entity1,
        'community' AS entityType1,
        'adjacent_to' AS predicate,
        unnest(neighboring_communities) AS entity2,
        'community' AS entityType2
    FROM community_neighborhoods
)

UNION

-- (city) -> nearby -> (city)
(
    SELECT
        city AS entity1,
        'city' AS entityType1,
        'nearby' AS predicate,
        unnest(nearby_cities) AS entity2,
        'city' AS entityType2
    FROM city_neighborhoods
)

UNION

-- (community) -> nearby -> (community)
(
    SELECT
        community AS entity1,
        'community' AS entityType1,
        'nearby' AS predicate,
        unnest(nearby_communities) AS entity2,
        'community' AS entityType2
    FROM community_neighborhoods
)

UNION

-- (community) -> overlaps_with -> (zipcode)
(
    SELECT
        community AS entity1,
        'community' AS entityType1,
        'overlaps_with' AS predicate,
        unnest(zipcodes)::text AS entity2,
        'zipcode' AS entityType2
    FROM community_neighborhoods
)