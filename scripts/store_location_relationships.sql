CREATE TABLE store_locale_relationships AS 

(SELECT
  name,
  id,
  city AS locale,
  'city' AS locale_type,
  'contained_in' AS predicate

FROM nourish.public.ca_businesses_sd_imperial)

  UNION ALL
  
(SELECT
  name ,
  id,
  zip::TEXT AS locale,
    'zip' AS locale_type,
  'contained_in' AS predicate

FROM nourish.public.ca_businesses_sd_imperial
  )

UNION ALL
  
(SELECT
  name,
  id,
  blockgroup::TEXT AS locale,
  'blockgroup' AS locale_type,
  'contained_in' AS predicate

FROM nourish.public.ca_businesses_sd_imperial
  );
