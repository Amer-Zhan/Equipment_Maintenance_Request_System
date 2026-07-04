-- =============================================================
-- 03_insert_sample_data.sql
-- Inserts realistic demonstration data for the project.
-- Run this script after 02_create_tables.sql.
-- =============================================================

INSERT INTO departments (department_name, description) VALUES
('IT Department', 'Responsible for internal software support, data processing, and digital tools.'),
('Workover Operations Department', 'Responsible for planning and performing workover and underground well repair operations.'),
('Equipment Maintenance Department', 'Responsible for inspection, repair, and maintenance of technical equipment.'),
('Safety Department', 'Responsible for occupational safety, risk monitoring, and field safety procedures.'),
('Administration', 'Responsible for general administrative support and documentation.');

INSERT INTO employees (full_name, position, department_id, phone, email) VALUES
('Tlemisov Artur Konysbaevich', 'Company Director', 5, '8-7132-56-27-87', 'director@leopard.kz'),
('Sultangaliev Adilzhan Ruslanovich', 'Technical Supervisor', 3, '8-701-111-22-33', 'adilzhan.sultangaliev@leopard.kz'),
('Kairatov Nursultan Maratovich', 'Workover Engineer', 2, '8-701-234-56-78', 'n.kairatov@leopard.kz'),
('Akhmetova Aigerim Bolatovna', 'Data Analyst', 1, '8-702-345-67-89', 'a.akhmetova@leopard.kz'),
('Orazbek Daniyar Serikovich', 'Equipment Maintenance Specialist', 3, '8-705-456-78-90', 'd.orazbek@leopard.kz'),
('Muratova Dana Yerlanovna', 'Safety Specialist', 4, '8-707-567-89-01', 'd.muratova@leopard.kz'),
('Smagulov Alibek Kanatovich', 'Field Mechanic', 3, '8-701-678-90-12', 'a.smagulov@leopard.kz'),
('Iskakov Timur Erlanovich', 'Workover Crew Leader', 2, '8-702-789-01-23', 't.iskakov@leopard.kz'),
('Zhumabekova Amina Rustemovna', 'Administrative Assistant', 5, '8-707-890-12-34', 'a.zhumabekova@leopard.kz'),
('Dauletbaev Amirzhan Askarovich', 'Intern Software Developer', 1, '8-700-000-00-00', 'amirzhan.dauletbaev@student.astanait.edu.kz');

INSERT INTO equipment (equipment_name, equipment_type, serial_number, condition_status, location, last_maintenance_date, notes) VALUES
('Hydraulic Tong HT-120', 'Well Service Tool', 'HT-120-AKT-001', 'Operational', 'Aktobe Base Warehouse', '2026-05-18', 'Used for tubing handling during workover operations.'),
('Mud Pump MP-500', 'Pumping Equipment', 'MP-500-AKT-002', 'Needs Maintenance', 'Workshop Area 1', '2026-03-28', 'Requires inspection of valves and seals.'),
('Workover Rig WR-75', 'Workover Rig', 'WR-75-AKT-003', 'Operational', 'Field Site 12', '2026-05-30', 'Assigned to workover crew 2.'),
('Tubing Elevator TE-90', 'Lifting Tool', 'TE-90-AKT-004', 'Operational', 'Aktobe Base Warehouse', '2026-04-22', 'No visible defects after last inspection.'),
('Pressure Gauge PG-700', 'Measurement Tool', 'PG-700-AKT-005', 'Under Repair', 'Workshop Area 2', '2026-02-15', 'Calibration issue detected.'),
('Blowout Preventer BOP-180', 'Safety Equipment', 'BOP-180-AKT-006', 'Operational', 'Field Site 7', '2026-06-01', 'Critical safety equipment. Monthly inspection required.'),
('Diesel Generator DG-300', 'Power Equipment', 'DG-300-AKT-007', 'Needs Maintenance', 'Field Site 12', '2026-03-10', 'Oil and filter replacement required.'),
('Wellhead Tool Kit WTK-45', 'Tool Kit', 'WTK-45-AKT-008', 'Operational', 'Vehicle Unit 4', '2026-05-12', 'Complete set after inventory check.'),
('Cementing Hose CH-60', 'Hose Equipment', 'CH-60-AKT-009', 'Out of Service', 'Workshop Area 1', '2026-01-20', 'Surface damage found during inspection.'),
('Torque Wrench TW-1000', 'Measurement Tool', 'TW-1000-AKT-010', 'Operational', 'Aktobe Base Warehouse', '2026-06-03', 'Recently calibrated.');

INSERT INTO request_statuses (status_name) VALUES
('New'),
('In Progress'),
('Completed'),
('Cancelled');

INSERT INTO workover_requests (equipment_id, created_by, assigned_to, status_id, priority, request_description, created_date, planned_completion_date, completed_date) VALUES
(2, 3, 5, 2, 'High', 'Inspect mud pump valves and replace worn seals before next field operation.', '2026-06-08', '2026-06-14', NULL),
(5, 6, 7, 2, 'Medium', 'Check pressure gauge calibration and prepare report for safety department.', '2026-06-09', '2026-06-15', NULL),
(7, 8, 5, 1, 'High', 'Perform diesel generator oil and filter replacement.', '2026-06-10', '2026-06-16', NULL),
(9, 5, 7, 1, 'Critical', 'Inspect damaged cementing hose and decide whether replacement is required.', '2026-06-11', '2026-06-13', NULL),
(1, 8, 5, 3, 'Medium', 'Routine hydraulic tong inspection after field operation.', '2026-06-05', '2026-06-10', '2026-06-10'),
(3, 3, 7, 3, 'Low', 'Check workover rig hydraulic system and fluid level.', '2026-06-04', '2026-06-12', '2026-06-12'),
(6, 6, 5, 3, 'Critical', 'Monthly safety inspection of blowout preventer.', '2026-06-03', '2026-06-07', '2026-06-07'),
(4, 8, 7, 4, 'Low', 'Tubing elevator visual inspection request duplicated by another crew.', '2026-06-06', '2026-06-09', NULL),
(10, 5, 5, 3, 'Medium', 'Torque wrench calibration check after field usage.', '2026-06-13', '2026-06-18', '2026-06-18'),
(2, 3, 7, 1, 'Medium', 'Prepare spare parts list for mud pump maintenance.', '2026-06-17', '2026-06-21', NULL),
(3, 8, 5, 2, 'High', 'Check rig lifting mechanism before planned workover operation.', '2026-06-18', '2026-06-24', NULL),
(8, 6, 7, 3, 'Low', 'Inventory check for wellhead tool kit.', '2026-06-19', '2026-06-22', '2026-06-22'),
(6, 3, 5, 1, 'Critical', 'Additional BOP pressure test before transportation to field site.', '2026-06-23', '2026-06-27', NULL),
(1, 8, 7, 2, 'Medium', 'Check hydraulic tong jaws for wear.', '2026-06-24', '2026-06-29', NULL),
(7, 3, 5, 1, 'High', 'Generator startup issue reported by field crew.', '2026-06-25', '2026-06-30', NULL);

INSERT INTO maintenance_logs (equipment_id, request_id, performed_by, maintenance_date, work_description, result) VALUES
(1, 5, 5, '2026-06-10', 'Hydraulic tong was inspected after field operation. Moving parts were cleaned and lubricated.', 'Equipment remained operational.'),
(3, 6, 7, '2026-06-12', 'Workover rig hydraulic system and fluid level were checked.', 'No serious issues found.'),
(6, 7, 5, '2026-06-07', 'Monthly BOP safety inspection was performed according to internal checklist.', 'Inspection completed successfully.'),
(10, 9, 5, '2026-06-18', 'Torque wrench calibration was verified after field usage.', 'Calibration result acceptable.'),
(8, 12, 7, '2026-06-22', 'Wellhead tool kit inventory was checked.', 'Tool kit complete.'),
(4, NULL, 7, '2026-05-22', 'Tubing elevator visual inspection was performed.', 'No defects found.'),
(2, NULL, 5, '2026-03-28', 'Mud pump basic inspection was performed.', 'Valve wear detected. Maintenance recommended.'),
(5, NULL, 7, '2026-02-15', 'Pressure gauge test was performed.', 'Calibration issue detected.'),
(7, NULL, 5, '2026-03-10', 'Diesel generator routine check was performed.', 'Oil and filter replacement required.'),
(6, NULL, 5, '2026-06-01', 'BOP external inspection and documentation check.', 'Ready for field use.');
