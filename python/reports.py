"""
reports.py
Reporting functions for dashboard and summaries.
"""

from db_connection import get_connection


def dashboard_summary():
    """Return key dashboard metrics."""
    query = """
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
    """
    connection = get_connection()
    if connection is None:
        return None

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query)
                return cursor.fetchone()
    finally:
        connection.close()


def requests_by_status():
    """Return request count by status."""
    query = """
        SELECT rs.status_name, COUNT(wr.request_id) AS request_count
        FROM request_statuses rs
        LEFT JOIN workover_requests wr ON rs.status_id = wr.status_id
        GROUP BY rs.status_name
        ORDER BY request_count DESC;
    """
    connection = get_connection()
    if connection is None:
        return []

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query)
                return cursor.fetchall()
    finally:
        connection.close()


def requests_by_priority():
    """Return request count by priority."""
    query = """
        SELECT priority, COUNT(*) AS request_count
        FROM workover_requests
        GROUP BY priority
        ORDER BY
            CASE priority
                WHEN 'Critical' THEN 1
                WHEN 'High' THEN 2
                WHEN 'Medium' THEN 3
                WHEN 'Low' THEN 4
            END;
    """
    connection = get_connection()
    if connection is None:
        return []

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query)
                return cursor.fetchall()
    finally:
        connection.close()


def equipment_maintenance_history():
    """Return maintenance history for equipment."""
    query = """
        SELECT e.equipment_name,
               e.serial_number,
               ml.maintenance_date,
               emp.full_name AS performed_by,
               ml.work_description,
               ml.result
        FROM maintenance_logs ml
        JOIN equipment e ON ml.equipment_id = e.equipment_id
        JOIN employees emp ON ml.performed_by = emp.employee_id
        ORDER BY e.equipment_name, ml.maintenance_date DESC;
    """
    connection = get_connection()
    if connection is None:
        return []

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query)
                return cursor.fetchall()
    finally:
        connection.close()
