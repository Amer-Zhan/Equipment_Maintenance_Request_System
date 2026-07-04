-- =============================================================
-- 04_queries.sql
-- Useful SQL queries for demonstration, testing, and reporting.
-- Run after inserting sample data.
-- =============================================================

-- 1. Show all equipment
SELECT
    equipment_id,
    equipment_name,
    equipment_type,
    serial_number,
    condition_status,
    location,
    last_maintenance_date
FROM equipment
ORDER BY equipment_id;

-- 2. Show equipment requiring maintenance or repair
SELECT
    equipment_id,
    equipment_name,
    equipment_type,
    serial_number,
    condition_status,
    location,
    last_maintenance_date
FROM equipment
WHERE condition_status IN ('Needs Maintenance', 'Under Repair', 'Out of Service')
ORDER BY condition_status, equipment_name;

-- 3. Show all active requests
SELECT
    wr.request_id,
    e.equipment_name,
    wr.priority,
    rs.status_name,
    wr.created_date,
    wr.planned_completion_date,
    assigned.full_name AS assigned_to
FROM workover_requests wr
JOIN equipment e ON wr.equipment_id = e.equipment_id
JOIN request_statuses rs ON wr.status_id = rs.status_id
LEFT JOIN employees assigned ON wr.assigned_to = assigned.employee_id
WHERE rs.status_name IN ('New', 'In Progress')
ORDER BY wr.created_date DESC;

-- 4. Show high-priority and critical requests
SELECT
    wr.request_id,
    e.equipment_name,
    wr.priority,
    rs.status_name,
    wr.request_description,
    wr.created_date,
    wr.planned_completion_date
FROM workover_requests wr
JOIN equipment e ON wr.equipment_id = e.equipment_id
JOIN request_statuses rs ON wr.status_id = rs.status_id
WHERE wr.priority IN ('High', 'Critical')
ORDER BY
    CASE wr.priority
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        ELSE 3
    END,
    wr.created_date DESC;

-- 5. Show completed requests
SELECT
    wr.request_id,
    e.equipment_name,
    wr.priority,
    wr.created_date,
    wr.completed_date,
    assigned.full_name AS completed_by_or_assigned_to
FROM workover_requests wr
JOIN equipment e ON wr.equipment_id = e.equipment_id
LEFT JOIN employees assigned ON wr.assigned_to = assigned.employee_id
JOIN request_statuses rs ON wr.status_id = rs.status_id
WHERE rs.status_name = 'Completed'
ORDER BY wr.completed_date DESC;

-- 6. Show request count by status
SELECT
    rs.status_name,
    COUNT(wr.request_id) AS request_count
FROM request_statuses rs
LEFT JOIN workover_requests wr ON rs.status_id = wr.status_id
GROUP BY rs.status_name
ORDER BY request_count DESC;

-- 7. Show request count by priority
SELECT
    priority,
    COUNT(*) AS request_count
FROM workover_requests
GROUP BY priority
ORDER BY
    CASE priority
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;

-- 8. Show maintenance history for each equipment item
SELECT
    e.equipment_name,
    e.serial_number,
    ml.maintenance_date,
    emp.full_name AS performed_by,
    ml.work_description,
    ml.result
FROM maintenance_logs ml
JOIN equipment e ON ml.equipment_id = e.equipment_id
JOIN employees emp ON ml.performed_by = emp.employee_id
ORDER BY e.equipment_name, ml.maintenance_date DESC;

-- 9. Show requests with employee names
SELECT
    wr.request_id,
    e.equipment_name,
    creator.full_name AS created_by,
    assigned.full_name AS assigned_to,
    rs.status_name,
    wr.priority,
    wr.created_date,
    wr.planned_completion_date,
    wr.request_description
FROM workover_requests wr
JOIN equipment e ON wr.equipment_id = e.equipment_id
JOIN employees creator ON wr.created_by = creator.employee_id
LEFT JOIN employees assigned ON wr.assigned_to = assigned.employee_id
JOIN request_statuses rs ON wr.status_id = rs.status_id
ORDER BY wr.request_id;

-- 10. Show overdue requests
SELECT
    wr.request_id,
    e.equipment_name,
    wr.priority,
    rs.status_name,
    wr.planned_completion_date,
    assigned.full_name AS assigned_to
FROM workover_requests wr
JOIN equipment e ON wr.equipment_id = e.equipment_id
JOIN request_statuses rs ON wr.status_id = rs.status_id
LEFT JOIN employees assigned ON wr.assigned_to = assigned.employee_id
WHERE wr.planned_completion_date < CURRENT_DATE
  AND rs.status_name NOT IN ('Completed', 'Cancelled')
ORDER BY wr.planned_completion_date;

-- 11. Dashboard summary
SELECT
    (SELECT COUNT(*) FROM equipment) AS total_equipment,
    (SELECT COUNT(*) FROM workover_requests) AS total_requests,
    (SELECT COUNT(*)
     FROM workover_requests wr
     JOIN request_statuses rs ON wr.status_id = rs.status_id
     WHERE rs.status_name IN ('New', 'In Progress')) AS active_requests,
    (SELECT COUNT(*)
     FROM workover_requests wr
     JOIN request_statuses rs ON wr.status_id = rs.status_id
     WHERE rs.status_name = 'Completed') AS completed_requests,
    (SELECT COUNT(*)
     FROM workover_requests
     WHERE priority = 'Critical') AS critical_requests;

-- 12. Search equipment by keyword example
SELECT
    equipment_id,
    equipment_name,
    equipment_type,
    serial_number,
    condition_status
FROM equipment
WHERE LOWER(equipment_name) LIKE LOWER('%pump%')
   OR LOWER(equipment_type) LIKE LOWER('%pump%')
   OR LOWER(serial_number) LIKE LOWER('%pump%');
