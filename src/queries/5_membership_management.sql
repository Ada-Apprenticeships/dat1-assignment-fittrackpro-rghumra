.open fittrackpro.db
.mode column

-- 5.1 
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    ms.type AS membership_type,
    m.join_date
FROM memberships ms
JOIN members m 
    ON ms.member_id = m.member_id
WHERE ms.status = 'Active';

-- 5.2 
SELECT
    ms.type AS membership_type,
    AVG(
        (strftime('%s', a.check_out_time) -
         strftime('%s', a.check_in_time)) / 60.0
    ) AS avg_visit_duration_minutes
FROM attendance a
JOIN memberships ms 
    ON a.member_id = ms.member_id
    AND ms.status = 'Active'
WHERE a.check_out_time IS NOT NULL
GROUP BY ms.type;

-- 5.3 
SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    m.email,
    ms.end_date
FROM memberships ms
JOIN members m 
    ON ms.member_id = m.member_id
WHERE ms.end_date >= '2025-01-01'
  AND ms.end_date <= '2025-12-31';
