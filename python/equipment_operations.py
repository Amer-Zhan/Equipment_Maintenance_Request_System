"""
equipment_operations.py
Functions for working with the equipment table.
"""

from db_connection import get_connection


def get_all_equipment():
    """Return all equipment records."""
    query = """
        SELECT equipment_id, equipment_name, equipment_type, serial_number,
               condition_status, location, last_maintenance_date
        FROM equipment
        ORDER BY equipment_id;
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


def get_equipment_by_status(status):
    """Return equipment filtered by condition status."""
    query = """
        SELECT equipment_id, equipment_name, equipment_type, serial_number,
               condition_status, location, last_maintenance_date
        FROM equipment
        WHERE condition_status = %s
        ORDER BY equipment_name;
    """
    connection = get_connection()
    if connection is None:
        return []

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query, (status,))
                return cursor.fetchall()
    finally:
        connection.close()


def add_equipment(equipment_name, equipment_type, serial_number, condition_status, location=None,
                  last_maintenance_date=None, notes=None):
    """Add a new equipment record and return its generated ID."""
    query = """
        INSERT INTO equipment
            (equipment_name, equipment_type, serial_number, condition_status,
             location, last_maintenance_date, notes)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        RETURNING equipment_id;
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
                        equipment_name,
                        equipment_type,
                        serial_number,
                        condition_status,
                        location,
                        last_maintenance_date,
                        notes,
                    ),
                )
                new_id = cursor.fetchone()["equipment_id"]
                return new_id
    finally:
        connection.close()


def update_equipment_condition(equipment_id, new_status):
    """Update the condition status of an equipment item."""
    query = """
        UPDATE equipment
        SET condition_status = %s
        WHERE equipment_id = %s;
    """
    connection = get_connection()
    if connection is None:
        return False

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query, (new_status, equipment_id))
                return cursor.rowcount > 0
    finally:
        connection.close()


def search_equipment(keyword):
    """Search equipment by name, type, serial number, or location."""
    query = """
        SELECT equipment_id, equipment_name, equipment_type, serial_number,
               condition_status, location, last_maintenance_date
        FROM equipment
        WHERE LOWER(equipment_name) LIKE LOWER(%s)
           OR LOWER(equipment_type) LIKE LOWER(%s)
           OR LOWER(serial_number) LIKE LOWER(%s)
           OR LOWER(COALESCE(location, '')) LIKE LOWER(%s)
        ORDER BY equipment_name;
    """
    search_pattern = f"%{keyword}%"
    connection = get_connection()
    if connection is None:
        return []

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query, (search_pattern, search_pattern, search_pattern, search_pattern))
                return cursor.fetchall()
    finally:
        connection.close()
