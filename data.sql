-- 1) course_layout
INSERT INTO course_layout (course_code, course_name, min_students, max_students, hp) VALUES
('IE1206', 'Emb. Elec', 10, 60, 7),
('IF1330', 'Elec Prin', 15, 80, 9),
('DA1001', 'Prog',      20, 100, 7),
('MA1101', 'Calc1',     20, 100, 7);

-- 2) department
INSERT INTO department (department_name) VALUES
('EECS'),
('MATH'),
('PHYS'),
('LANG');

-- 3) job_title
INSERT INTO job_title (job_title) VALUES
('Lecturer'),
('Professor'),
('TA'),
('Adjunct');

-- 4) person
INSERT INTO person (personal_number, first_name, last_name, phone_number, address) VALUES
('19900101AA', 'Lina',  'Andersson', '0700000001', 'KTH St 1'),
('19920202BB', 'Bo',    'Bengtsson', '0700000002', 'KTH St 2'),
('19930303CC', 'Carla', 'Carlsson',  '0700000003', 'KTH St 3'),
('19940404DD', 'David', 'Dahl',      '0700000004', 'KTH St 4');

-- 5) employee
INSERT INTO employee (employment_id, personal_number, department_name, job_title, skill_set, salary, supervisor_manager) VALUES
('E001', '19900101AA', 'EECS', 'Lecturer',  'C, VHDL', 35000.00, 1),
('E002', '19920202BB', 'EECS', 'Professor', 'Signals', 55000.00, 0),
('E003', '19930303CC', 'MATH', 'TA',        'Python',  30000.00, 0),
('E004', '19940404DD', 'PHYS', 'Adjunct',   'Mech',    42000.00, 0);

-- 6) teaching_activity
INSERT INTO teaching_activity (activity_name, factor) VALUES
('Lecture',  1.00),
('Lab',      0.50),
('Seminar',  0.75),
('Project',  1.50);

-- 7) course_instance
INSERT INTO course_instance (instance_id, course_code, num_students, study_period, study_year) VALUES
('IE1206-1', 'IE1206', 40, 1, 2025),
('IE1206-2', 'IE1206', 35, 2, 2025),
('IF1330-1', 'IF1330', 50, 2, 2025),
('IE1206-3', 'IE1206', 32, 3, 2025),
('IF1330-2', 'IF1330', 45, 2, 2025),
('DA1001-1', 'DA1001', 60, 1, 2025),
('DA1001-2', 'DA1001', 55, 2, 2026),
('MA1101-1', 'MA1101', 48, 1, 2025),
('MA1101-2', 'MA1101', 52, 2, 2025);

-- 8) planned_activity
-- Original rows
INSERT INTO planned_activity (planned_hours, instance_id, employment_id, activity_name) VALUES
(20, 'IE1206-1', 'E001', 'Lecture'),
(10, 'IE1206-1', 'E001', 'Lab'),
(15, 'IE1206-2', 'E001', 'Lecture'),
(20, 'IF1330-1', 'E002', 'Lecture');

-- Extra rows
-- E001 (Lina):
--   Period 1 / 2025: IE1206-1, DA1001-1, MA1101-1  -> 3 distinct instances
--   Period 2 / 2025: IE1206-2, IF1330-1, IF1330-2, MA1101-2 -> 4 distinct instances (max)
INSERT INTO planned_activity (planned_hours, instance_id, employment_id, activity_name) VALUES
-- extra, period 1 / 2025
(12, 'DA1001-1', 'E001', 'Lecture'),
( 8, 'MA1101-1', 'E001', 'Seminar'),
-- extra, period 2 / 2025
(10, 'IF1330-1', 'E001', 'Lab'),
(18, 'IF1330-2', 'E001', 'Lecture'),
(16, 'MA1101-2', 'E001', 'Project');

-- E002 (Bo):
--   P2 2025: IF1330-1, IE1206-3 -> 2
--   P1 2025: DA1001-1 -> 1
--   P2 2026: DA1001-2 -> 1
INSERT INTO planned_activity (planned_hours, instance_id, employment_id, activity_name) VALUES
(15, 'IE1206-3', 'E002', 'Lecture'),
(10, 'DA1001-1', 'E002', 'Lab'),
(25, 'DA1001-2', 'E002', 'Project');

-- E003 (Carla) – well below limit in all periods
INSERT INTO planned_activity (planned_hours, instance_id, employment_id, activity_name) VALUES
(10, 'MA1101-1', 'E003', 'Lab'),
(15, 'MA1101-2', 'E003', 'Seminar'),
( 8, 'DA1001-2', 'E003', 'Lab');

-- E004 (David) – also below limit
INSERT INTO planned_activity (planned_hours, instance_id, employment_id, activity_name) VALUES
(12, 'IF1330-2', 'E004', 'Lab'),
(20, 'IE1206-3', 'E004', 'Project');

