#standardSQL
# Percent of websites using a specific CMP (Based on wappalyzer 'Cookie compliance' category)
# Alternatively, `core_web_vitals.technologies` could be used, but then we do not have
#  access to the total number of websites

WITH totals AS (
  SELECT
    _TABLE_SUFFIX,
    COUNT(DISTINCT url) AS total_websites
  FROM
    `httparchive.technologies.2021_07_01_*`
  GROUP BY
    _TABLE_SUFFIX
)

SELECT
  _TABLE_SUFFIX AS client,
  app,
  ANY_VALUE(total_websites) AS total_websites,
  COUNT(DISTINCT url) AS number_of_websites,
  COUNT(DISTINCT url) / ANY_VALUE(total_websites) AS percent_of_websites
FROM
  `httparchive.technologies.2021_07_01_*`
JOIN totals USING (_TABLE_SUFFIX)
WHERE
  category = "Cookie compliance" AND
  app != ""
GROUP BY
  client,
  app
ORDER BY
  client ASC,
  number_of_websites DESC
