#standardSQL
# Usage of Feature-Policy or Permissions-Policy

WITH page_ranks AS (
  SELECT
    client,
    page,
    rank
  FROM
    `httparchive.almanac.requests`
  WHERE
    date = '2021-07-01' AND
    firstHtml = TRUE
),

response_headers AS (
  SELECT
    client,
    page,
    LOWER(JSON_VALUE(response_header, '$.name')) AS header_name,
    LOWER(JSON_VALUE(response_header, '$.value')) AS header_value
  FROM
    `httparchive.almanac.requests`,
    UNNEST(JSON_QUERY_ARRAY(response_headers)) response_header
  WHERE
    date = '2021-07-01' AND
    firstHtml = TRUE
),

meta_tags AS (
  SELECT
    client,
    url AS page,
    LOWER(JSON_VALUE(meta_node, '$.http-equiv')) AS tag_name,
    LOWER(JSON_VALUE(meta_node, '$.content')) AS tag_value
  FROM (
    SELECT
      _TABLE_SUFFIX AS client,
      url,
      JSON_VALUE(payload, "$._almanac") AS metrics
    FROM
      `httparchive.pages.2021_07_01_*`
    ),
    UNNEST(JSON_QUERY_ARRAY(metrics, "$.meta-nodes.nodes")) meta_node
  WHERE
    JSON_VALUE(meta_node, '$.http-equiv') IS NOT NULL
)

SELECT
  *,
  number_of_websites_with_feature_policy / number_of_websites AS pct_websites_with_feature_policy,
  number_of_websites_with_permissions_policy / number_of_websites AS pct_websites_with_permissions_policy,
  number_of_websites_with_any_policy / number_of_websites AS pct_websites_with_any_policy
FROM (
  SELECT
    client,
    rank,
    COUNTIF(
      header_name = 'feature-policy' OR
      tag_name = 'feature-policy'
    ) AS number_of_websites_with_feature_policy,
    COUNTIF(
      header_name = 'permissions-policy' OR
      tag_name = 'permissions-policy'
    ) AS number_of_websites_with_permissions_policy,
    COUNTIF(
      header_name = 'feature-policy' OR
      tag_name = 'feature-policy' OR
      header_name = 'permissions-policy' OR
      tag_name = 'permissions-policy'
    ) AS number_of_websites_with_any_policy,
    COUNT(0) AS number_of_websites
  FROM
    response_headers
  FULL OUTER JOIN
    meta_tags
  USING (client, page)
  JOIN
    page_ranks
  USING (client, page)
  GROUP BY
    client,
    rank
)
ORDER BY
  rank,
  client
