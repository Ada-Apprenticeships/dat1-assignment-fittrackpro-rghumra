.open fittrackpro.db
.mode column

-- 3.1 
SELECT 
    equipment_id,
    name,
    next_maintenance_date
FROM equipment
WHERE next_maintenance_date BETWEEN '2025-01-01' AND date('2025-01-01', '+30 days'); --need to explain this
-- 3.2 
SELECT
    type AS equipment_type
    COUNT(*) AS count 
FROM equipment
-- 3.3 
SELECT
    type,
    AVG((strftime('%s','now') - strftime('%s', purchase_date)) / 86400) AS avg_age_days --need to explain this
FROM equipment
GROUP BY type;