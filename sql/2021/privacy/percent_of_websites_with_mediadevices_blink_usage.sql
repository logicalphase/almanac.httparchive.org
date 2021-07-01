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
  (
    feature LIKE '%MediaDevices%' OR
    feature LIKE '%EnumerateDevices%' OR
    feature LIKE '%GetUserMedia%' OR
    feature LIKE '%GetDisplayMedia%' OR
    feature LIKE '%Camera%' OR
    feature LIKE '%Microphone%'
  )
ORDER BY
  feature

# relevant Blink features:

# MediaDevicesEnumerateDevices
# GetUserMediaSecureOrigin
# GetUserMediaPromise
# GetUserMediaLegacy
# GetUserMediaPrefixed
# GetUserMediaSecureOriginIframe
# GetUserMediaInsecureOrigin
# GetUserMediaInsecureOriginIframe
# V8MediaSession_SetMicrophoneActive_Method
# V8MediaSession_SetCameraActive_Method
# GetDisplayMedia