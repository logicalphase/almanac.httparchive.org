#standardSQL
#type of content_encoding

SELECT
  client,
  mimeType,
  resp_content_encoding AS content_encoding,
  COUNT(0) AS num_requests,
  SUM(COUNT(0)) OVER (PARTITION BY client) AS total,
  COUNT(0) / SUM(COUNT(0)) OVER (PARTITION BY client) AS pct_m106
FROM
  `httparchive.almanac.requests`
WHERE
  mimeType = "text/html"
  AND
  date = '2021-07-01'
GROUP BY
  client,
  mimeType,
  content_encoding
ORDER BY
  num_requests DESC
