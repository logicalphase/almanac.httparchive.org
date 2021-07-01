SELECT
  client,
  feature,
  num_urls,
  total_urls,
  ROUND(pct_urls * 100, 2) AS pct_urls
FROM
  `httparchive.blink_features.usage`
WHERE
  yyyymmdd = '20210801' AND
  feature = 'InterestCohortAPI_interestCohort_Method'
ORDER BY
  feature

# relevant Blink features:

# InterestCohortAPI_interestCohort_Method
