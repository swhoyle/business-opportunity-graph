TRUNCATE TABLE entity_relationships;

INSERT INTO entity_relationships (entity1, entitytype1, predicate, entity2, entitytype2)

-- (county) -> contained_in -> (state)
(
    SELECT
        county AS entity1,
        'county' AS entitytype1,
        'contained_in' AS predicate,
        state_name AS entity2,
        'state' AS entitytype2
    FROM county_neighborhoods
)

UNION

-- (city) -> contained_in -> (county)
(
    SELECT
        city AS entity1,
        'city' AS entitytype1,
        'contained_in' AS predicate,
        county AS entity2,
        'county' AS entitytype2
    FROM city_neighborhoods
)

UNION

-- (community) -> contained_in -> (city)
(
    SELECT
        community AS entity1,
        'community' AS entitytype1,
        'contained_in' AS predicate,
        city AS entity2,
        'city' AS entitytype2
    FROM community_neighborhoods
)

UNION

-- (county) -> adjacent_to -> (county)
(
    SELECT
        county AS entity1,
        'county' AS entitytype1,
        'adjacent_to' AS predicate,
        unnest(neighboring_counties) AS entity2,
        'county' AS entitytype2
    FROM county_neighborhoods
)

UNION

-- (city) -> adjacent_to -> (city)
(
    SELECT
        city AS entity1,
        'city' AS entitytype1,
        'adjacent_to' AS predicate,
        unnest(neighboring_cities) AS entity2,
        'city' AS entitytype2
    FROM city_neighborhoods
)

UNION

-- (community) -> adjacent_to -> (community)
(
    SELECT
        community AS entity1,
        'community' AS entitytype1,
        'adjacent_to' AS predicate,
        unnest(neighboring_communities) AS entity2,
        'community' AS entitytype2
    FROM community_neighborhoods
)

UNION

-- (city) -> nearby -> (city)
(
    SELECT
        city AS entity1,
        'city' AS entitytype1,
        'nearby' AS predicate,
        unnest(nearby_cities) AS entity2,
        'city' AS entitytype2
    FROM city_neighborhoods
)

UNION

-- (community) -> nearby -> (community)
(
    SELECT
        community AS entity1,
        'community' AS entitytype1,
        'nearby' AS predicate,
        unnest(nearby_communities) AS entity2,
        'community' AS entitytype2
    FROM community_neighborhoods
)

UNION

-- (community) -> overlaps_with -> (zipcode)
(
    SELECT
        community AS entity1,
        'community' AS entitytype1,
        'overlaps_with' AS predicate,
        unnest(zipcodes)::text AS entity2,
        'zipcode' AS entitytype2
    FROM community_neighborhoods
)

UNION

-- (community) -> overlaps_with -> (blockgroup)
select name as entity1, 'community' as entitytype1,
       'overlaps_with' as predicate,
      unnest(intersected_block_groups)::text as entity2, 'blockgroup' as entitytype2
from nourish_community_block_group_intersection

UNION

-- (business) -> contained_in -> (blockgroup)
(
    SELECT
        id::TEXT AS entity1,
        'business' AS entitytype1,
        'contained_in' AS predicate,
        blockgroup::TEXT AS entity2,
        'blockgroup' AS entitytype2
    FROM entity_business
);