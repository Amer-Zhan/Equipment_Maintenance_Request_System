"""
db_connection.py
Reusable PostgreSQL connection function.
"""

import psycopg2
from psycopg2.extras import RealDictCursor
from db_config import DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT


def get_connection():
    """Create and return a PostgreSQL connection.

    Returns:
        psycopg2 connection object or None if connection fails.
    """
    try:
        connection = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT,
            cursor_factory=RealDictCursor,
        )
        return connection
    except psycopg2.Error as error:
        print("Database connection error:", error)
        print("Check db_config.py and make sure PostgreSQL is running.")
        return None
