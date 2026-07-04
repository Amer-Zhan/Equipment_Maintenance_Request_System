# ERD Entities and Relationships

This file describes the database structure so that the ERD diagram can be created manually in diagrams.net / draw.io.

## Entities

### 1. departments
Stores departments of the organization.

Primary key:
- department_id

Important fields:
- department_name
- description

### 2. employees
Stores employees who create, receive, or perform maintenance requests.

Primary key:
- employee_id

Foreign key:
- department_id → departments.department_id

Important fields:
- full_name
- position
- phone
- email

### 3. equipment
Stores technical equipment used in workover operations.

Primary key:
- equipment_id

Important fields:
- equipment_name
- equipment_type
- serial_number
- condition_status
- location
- last_maintenance_date
- notes

### 4. request_statuses
Stores possible request statuses.

Primary key:
- status_id

Important fields:
- status_name

### 5. workover_requests
Stores maintenance and workover-related requests.

Primary key:
- request_id

Foreign keys:
- equipment_id → equipment.equipment_id
- created_by → employees.employee_id
- assigned_to → employees.employee_id
- status_id → request_statuses.status_id

Important fields:
- priority
- request_description
- created_date
- planned_completion_date
- completed_date

### 6. maintenance_logs
Stores maintenance history and completed work records.

Primary key:
- log_id

Foreign keys:
- equipment_id → equipment.equipment_id
- request_id → workover_requests.request_id
- performed_by → employees.employee_id

Important fields:
- maintenance_date
- work_description
- result

## Relationships

1. One department can have many employees.
   - departments 1 → many employees

2. One employee can create many workover requests.
   - employees 1 → many workover_requests through created_by

3. One employee can be assigned to many workover requests.
   - employees 1 → many workover_requests through assigned_to

4. One equipment item can have many workover requests.
   - equipment 1 → many workover_requests

5. One request status can be used by many workover requests.
   - request_statuses 1 → many workover_requests

6. One equipment item can have many maintenance logs.
   - equipment 1 → many maintenance_logs

7. One workover request can have zero or many maintenance logs.
   - workover_requests 1 → many maintenance_logs

8. One employee can perform many maintenance log activities.
   - employees 1 → many maintenance_logs through performed_by

## Suggested ERD Layout

Place tables in this order:

- departments on the left
- employees near departments
- equipment in the center
- request_statuses near workover_requests
- workover_requests in the center-right
- maintenance_logs on the far right

This layout makes the foreign key connections easy to understand.
