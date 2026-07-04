"""
request_operations.py
Functions for workover and maintenance requests.
"""

from db_connection import get_connection


def get_all_requests():
    """Return all workover requests with related equipment and employee names."""
    query = """
        SELECT wr.request_id,
               e.equipment_name,
               creator.full_name AS created_by,
               assigned.full_name AS assigned_to,
               rs.status_name,
               wr.priority,
               wr.created_date,
               wr.planned_completion_date,
               wr.completed_date,
               wr.request_description
        FROM workover_requests wr
        JOIN equipment e ON wr.equipment_id = e.equipment_id
        JOIN employees creator ON wr.created_by = creator.employee_id
        LEFT JOIN employees assigned ON wr.assigned_to = assigned.employee_id
        JOIN request_statuses rs ON wr.status_id = rs.status_id
        ORDER BY wr.request_id;
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


def get_active_requests():
    """Return requests with New or In Progress status."""
    query = """
        SELECT wr.request_id,
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


def create_request(equipment_id, created_by, assigned_to, status_id, priority,
                   request_description, created_date, planned_completion_date=None):
    """Create a new maintenance/workover request and return its ID."""
    query = """
        INSERT INTO workover_requests
            (equipment_id, created_by, assigned_to, status_id, priority,
             request_description, created_date, planned_completion_date)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING request_id;
    """
    connection = get_connection()
    if connection is None:
        return None

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    query,
                    (
                        equipment_id,
                        created_by,
                        assigned_to,
                        status_id,
                        priority,
                        request_description,
                        created_date,
                        planned_completion_date,
                    ),
                )
                return cursor.fetchone()["request_id"]
    finally:
        connection.close()


def update_request_status(request_id, status_id):
    """Update request status by request ID."""
    query = """
        UPDATE workover_requests
        SET status_id = %s,
            completed_date = CASE
                WHEN %s = (SELECT status_id FROM request_statuses WHERE status_name = 'Completed')
                THEN CURRENT_DATE
                ELSE completed_date
            END
        WHERE request_id = %s;
    """
    connection = get_connection()
    if connection is None:
        return False

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query, (status_id, status_id, request_id))
                return cursor.rowcount > 0
    finally:
        connection.close()


def get_requests_by_priority(priority):
    """Return requests filtered by priority."""
    query = """
        SELECT wr.request_id,
               e.equipment_name,
               wr.priority,
               rs.status_name,
               wr.created_date,
               wr.planned_completion_date,
               wr.request_description
        FROM workover_requests wr
        JOIN equipment e ON wr.equipment_id = e.equipment_id
        JOIN request_statuses rs ON wr.status_id = rs.status_id
        WHERE wr.priority = %s
        ORDER BY wr.created_date DESC;
    """
    connection = get_connection()
    if connection is None:
        return []

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query, (priority,))
                return cursor.fetchall()
    finally:
        connection.close()
