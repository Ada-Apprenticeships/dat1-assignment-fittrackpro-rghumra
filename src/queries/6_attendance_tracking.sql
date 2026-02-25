.open fittrackpro.db
.mode column

-- 6.1 
INSERT INTO attendance (
    member_id,
    location_id,
    check_in_time
)
VALUES (
    7,
    1,
    '2025-02-14 16:30:00'
);

-- 6.2 
SELECT
    DATE(check_in_time) AS visit_date,
    check_in_time,
    check_out_time
FROM attendance
WHERE member_id = 5;

-- 6.3 
SELECT
    CASE weekday_number
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    visit_count
FROM (
    SELECT
        strftime('%w', check_in_time) AS weekday_number,
        COUNT(*) AS visit_count
    FROM attendance
    GROUP BY weekday_number
)
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4 
SELECT
    l.name AS location_name,
    SUM(d.daily_count) * 1.0 / COUNT(DISTINCT d.visit_date) AS avg_daily_attendance
FROM locations l
LEFT JOIN (
    SELECT
        location_id,
        DATE(check_in_time) AS visit_date,
        COUNT(*) AS daily_count
    FROM attendance
    GROUP BY location_id, visit_date
) d
ON l.location_id = d.location_id
GROUP BY l.location_id;