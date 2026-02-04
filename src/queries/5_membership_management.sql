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
JOIN members m ON ms.member_id = m.member_id
WHERE ms.status = 'Active';
-- 5.2 


-- 5.3 

