-- Jedna konkretni jizda
SELECT stop_name, arrival_time FROM stop_times st
JOIN stops s ON st.stop_id=s.stop_id
WHERE trip_id='223/4'
ORDER BY stop_sequence ASC

-- Pijezdy a odjezdy na konkretni zastavce
SELECT route_short_name, trip_headsign, arrival_time, direction_id FROM stop_times st
JOIN trips t ON st.trip_id=t.trip_id
JOIN routes r ON r.route_id=t.route_id
WHERE stop_id='402' AND t.service_id='MN'
ORDER BY arrival_time ASC

-- Linky co zastavuji na dane zastavce
SELECT DISTINCT route_short_name FROM stop_times st
JOIN trips t ON st.trip_id=t.trip_id
JOIN routes r ON r.route_id=t.route_id
WHERE stop_id='402' AND t.service_id='MN'

-- Normalizace casu
CASE WHEN length(arrival_time)<8 THEN '0'||arrival_time ELSE arrival_time END AS arrival_time

-- Cela normalizace
SELECT trip_id,
CASE WHEN length(arrival_time)<8 THEN '0'||arrival_time ELSE arrival_time END AS arrival_time,
CASE WHEN length(departure_time)<8 THEN '0'||departure_time ELSE departure_time END AS departure_time,
stop_id, stop_sequence, pickup_type, drop_off_type
FROM stop_times