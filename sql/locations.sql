-- get locations within the last 5 minutes &
-- select the one with the highest timestamp for each device &
-- ignore own device

SELECT *, cast(EXTRACT(EPOCH FROM timestamp) as integer) as timestamp FROM locations t1
JOIN(
  SELECT device, MAX(timestamp) AS max_timestamp
  FROM locations
  WHERE timestamp > (NOW() - '5 minutes'::INTERVAL)
  GROUP BY device
) t2
ON t1.device = t2.device
AND t1.timestamp = t2.max_timestamp
WHERE t1.device != $1
