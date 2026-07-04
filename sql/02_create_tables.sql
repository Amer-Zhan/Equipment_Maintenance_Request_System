-- =============================================================
-- 02_create_tables.sql
-- Creates all tables for the Equipment Maintenance and Workover
-- Request Tracking System.
--
-- IMPORTANT: Run this script after connecting to leopard_practice_db.
-- =============================================================

-- Drop tables in reverse dependency order so the script can be rerun.
DROP TABLE IF EXISTS maintenance_logs;
DROP TABLE IF EXISTS workover_requests;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS request_statuses;
DROP TABLE IF EXISTS departments;

-- =============================================================
-- departments
-- Stores company departments involved in equipment and workover operations.
-- =============================================================
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- =============================================================
-- employees
-- Stores employees who create, receive, or perform maintenance requests.
-- =============================================================
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    position VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    phone VARCHAR(30),
    email VARCHAR(100),
    CONSTRAINT fk_employees_departments
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =============================================================
-- equipment
-- Stores oilfield service equipment used for workover operations.
-- =============================================================
CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    equipment_name VARCHAR(150) NOT NULL,
    equipment_type VARCHAR(100) NOT NULL,
    serial_number VARCHAR(100) UNIQUE NOT NULL,
    condition_status VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    last_maintenance_date DATE,
    notes TEXT,
    CONSTRAINT chk_equipment_condition
        CHECK (condition_status IN ('Operational', 'Needs Maintenance', 'Under Repair', 'Out of Service'))
);

-- =============================================================
-- request_statuses
-- Stores possible statuses for workover and maintenance requests.
-- =============================================================
CREATE TABLE request_statuses (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

-- =============================================================
-- workover_requests
-- Stores requests related to equipment inspection, repair, or maintenance.
-- =============================================================
CREATE TABLE workover_requests (
    request_id SERIAL PRIMARY KEY,
    equipment_id INT NOT NULL,
    created_by INT NOT NULL,
    assigned_to INT,
    status_id INT NOT NULL,
    priority VARCHAR(20) NOT NULL,
    request_description TEXT NOT NULL,
    created_date DATE NOT NULL,
    planned_completion_date DATE,
    completed_date DATE,
    CONSTRAINT fk_requests_equipment
        FOREIGN KEY (equipment_id)
        REFERENCES equipment(equipment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_requests_created_by
        FOREIGN KEY (created_by)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_requests_assigned_to
        FOREIGN KEY (assigned_to)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_requests_status
        FOREIGN KEY (status_id)
        REFERENCES request_statuses(status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_request_priority
        CHECK (priority IN ('Low', 'Medium', 'High', 'Critical'))
);

-- =============================================================
-- maintenance_logs
-- Stores completed maintenance activities linked to equipment and requests.
-- =============================================================
CREATE TABLE maintenance_logs (
    log_id SERIAL PRIMARY KEY,
    equipment_id INT NOT NULL,
    request_id INT,
    performed_by INT NOT NULL,
    maintenance_date DATE NOT NULL,
    work_description TEXT NOT NULL,
    result TEXT,
    CONSTRAINT fk_logs_equipment
        FOREIGN KEY (equipment_id)
        REFERENCES equipment(equipment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_logs_request
        FOREIGN KEY (request_id)
        REFERENCES workover_requests(request_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_logs_employee
        FOREIGN KEY (performed_by)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Helpful indexes for faster search and filtering.
CREATE INDEX idx_equipment_condition ON equipment(condition_status);
CREATE INDEX idx_equipment_serial_number ON equipment(serial_number);
CREATE INDEX idx_requests_status ON workover_requests(status_id);
CREATE INDEX idx_requests_priority ON workover_requests(priority);
CREATE INDEX idx_requests_equipment ON workover_requests(equipment_id);
CREATE INDEX idx_logs_equipment ON maintenance_logs(equipment_id);

-- End of table creation script.
