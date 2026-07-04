# Equipment Maintenance and Workover Request Tracking System

## 1. Project Description

This project is a database-oriented prototype of an internal information system for an oilfield service company. It was prepared as part of an Industrial Practice project for a 2nd-year Computer Science student.

The system is designed for LLP “Service Oil Company Leopard”, an oilfield service company whose activities are related to services supporting oil and natural gas extraction, including workover and underground well repair operations.

The main purpose of the prototype is to organize and demonstrate how the company could store and process information about:

- departments;
- employees;
- technical equipment;
- maintenance and workover requests;
- request statuses;
- maintenance history.

The project does not use a backend web framework. It focuses on PostgreSQL, SQL, Python scripts, and static HTML/CSS interface prototypes.

## 2. Technologies Used

- Python
- PostgreSQL
- SQL
- psycopg2-binary
- HTML
- CSS
- GitHub
- pgAdmin
- diagrams.net / draw.io for ERD diagram preparation

## 3. Project Structure

```text
 equipment-maintenance-request-system/
 │
 ├── sql/
 │   ├── 01_create_database.sql
 │   ├── 02_create_tables.sql
 │   ├── 03_insert_sample_data.sql
 │   └── 04_queries.sql
 │
 ├── python/
 │   ├── db_config.py
 │   ├── db_connection.py
 │   ├── equipment_operations.py
 │   ├── request_operations.py
 │   ├── reports.py
 │   └── main.py
 │
 ├── interface/
 │   ├── index.html
 │   ├── dashboard.html
 │   ├── equipment.html
 │   ├── requests.html
 │   ├── add_equipment.html
 │   ├── create_request.html
 │   └── style.css
 │
 ├── screenshots/
 │   └── screenshots_guide.md
 │
 ├── docs/
 │   ├── erd_entities_and_relationships.md
 │   └── project_explanation_for_presentation.md
 │
 ├── diagrams/
 ├── README.md
 ├── requirements.txt
 └── .gitignore
```

## 4. Database Structure

The PostgreSQL database is called:

```sql
leopard_practice_db
```

It contains six main tables:

1. `departments`
2. `employees`
3. `equipment`
4. `request_statuses`
5. `workover_requests`
6. `maintenance_logs`

### Main Relationships

- One department can have many employees.
- One equipment item can have many workover requests.
- One request status can be assigned to many workover requests.
- One employee can create many requests.
- One employee can be assigned to many requests.
- One equipment item can have many maintenance logs.
- One workover request can have maintenance log records.

A detailed ERD explanation is available in:

```text
docs/erd_entities_and_relationships.md
```

## 5. PostgreSQL Setup

### Step 1: Open pgAdmin or psql

Connect to your local PostgreSQL server.

### Step 2: Create the database

Run:

```sql
sql/01_create_database.sql
```

This will create the database:

```sql
leopard_practice_db
```

### Step 3: Connect to the new database

In pgAdmin, select `leopard_practice_db` before running the next scripts.

### Step 4: Create tables

Run:

```sql
sql/02_create_tables.sql
```

### Step 5: Insert sample data

Run:

```sql
sql/03_insert_sample_data.sql
```

### Step 6: Test SQL queries

Run queries from:

```sql
sql/04_queries.sql
```

## 6. Python Setup

### Step 1: Create a virtual environment

From the project folder, run:

```bash
python -m venv venv
```

Activate it on Windows:

```bash
venv\Scripts\activate
```

Activate it on macOS/Linux:

```bash
source venv/bin/activate
```

### Step 2: Install dependencies

```bash
pip install -r requirements.txt
```

### Step 3: Configure database password

Open:

```text
python/db_config.py
```

Replace:

```python
DB_PASSWORD = "your_password_here"
```

with your local PostgreSQL password.

If your PostgreSQL username is not `postgres`, also update:

```python
DB_USER = "postgres"
```

## 7. Running the Python Program

Open terminal in the `python` folder:

```bash
cd python
python main.py
```

The command-line menu allows you to:

1. Show all equipment
2. Search equipment
3. Show active requests
4. Show dashboard summary
5. Show requests by status
6. Show maintenance history

## 8. Opening the HTML/CSS Interface

The interface is a static prototype. It does not connect directly to the database.

Open these files in a browser:

```text
interface/index.html
interface/dashboard.html
interface/equipment.html
interface/requests.html
interface/add_equipment.html
interface/create_request.html
```

The HTML pages visually demonstrate how the final system interface could look.

## 9. Main Implemented Features

### Database Features

- PostgreSQL database schema
- Six related tables
- Primary keys and foreign keys
- Constraints for equipment condition and request priority
- Sample data for departments, employees, equipment, requests, and logs

### SQL Features

- Equipment list
- Equipment requiring maintenance
- Active requests
- High-priority and critical requests
- Completed requests
- Request count by status
- Request count by priority
- Maintenance history
- Dashboard summary
- Search examples

### Python Features

- PostgreSQL connection with psycopg2
- Equipment operations
- Request operations
- Reporting functions
- Simple command-line menu
- Beginner-friendly structure

### Interface Features

- Landing page
- Dashboard page
- Equipment table page
- Requests table page
- Add equipment form prototype
- Create request form prototype
- Professional internal corporate style with pure HTML/CSS

## 10. Suggested Screenshots for the Industrial Practice Report

Recommended screenshots:

1. GitHub repository structure
2. README.md preview
3. PostgreSQL database in pgAdmin
4. Tables in pgAdmin
5. ERD diagram
6. SQL query results
7. Python code in VS Code
8. Python script output in terminal
9. Dashboard HTML page
10. Equipment page
11. Requests page

A more detailed guide is available in:

```text
screenshots/screenshots_guide.md
```

## 11. Possible Future Improvements

This prototype can be expanded in the future by adding:

- user authentication;
- real backend web application;
- role-based access control;
- file upload for technical documents;
- automated report generation;
- advanced filtering and search;
- email notifications for critical requests;
- integration with company inventory systems.

## 12. Project Status

This project is a completed educational prototype prepared for Industrial Practice demonstration. It shows database design, SQL usage, Python database connection, and static interface prototyping.
