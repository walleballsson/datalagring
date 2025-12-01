

-- 1. ADDRESS
INSERT INTO address (address_id, city, country, address_line) VALUES
('ADDR0001', 'Stockholm', 'Sweden', 'KTH Campus Valhallavägen 1'),
('ADDR0002', 'Stockholm', 'Sweden', 'Lindstedtsvägen 3'),
('ADDR0003', 'Stockholm', 'Sweden', 'Drottning Kristinas väg 15'),
('ADDR0004', 'Uppsala',   'Sweden', 'Science Street 10'),
('ADDR0005', 'Göteborg',  'Sweden', 'Techvägen 5');

-- 2. PERSON
INSERT INTO person (person_id, personal_number, first_name, last_name, address_id) VALUES
('P000000001', '900101123456', 'Paris',    'Carbone',   'ADDR0001'),
('P000000002', '850305567890', 'Leif',     'Lindbäck',  'ADDR0002'),
('P000000003', '880620987654', 'Niharika', 'Gauraha',   'ADDR0003'),
('P000000004', '920210222233', 'Brian',    'Smith',     'ADDR0004'),
('P000000005', '970715333344', 'Adam',     'Johansson', 'ADDR0005'),
('P000000006', '810101444455', 'Anna',     'Admin',     'ADDR0001');

-- 3. PHONE
INSERT INTO phone (person_id, phone_id) VALUES
('P000000001', 'PHONE0001'),
('P000000002', 'PHONE0002'),
('P000000003', 'PHONE0003'),
('P000000004', 'PHONE0004'),
('P000000005', 'PHONE0005'),
('P000000006', 'PHONE0006');

-- 4. JOB TITLES
INSERT INTO jobtitle (job_title_id, job_title_name) VALUES
('JT0000001', 'Professor'),
('JT0000002', 'Lecturer'),
('JT0000003', 'PhD Student'),
('JT0000004', 'TA'),
('JT0000005', 'Administrator');

-- 5. MANAGER 
-- (One row per employee_id, because employee.employee_id references manager.employee_id)
INSERT INTO manager (employee_id, department_id) VALUES
('E000000001', 'D00000001'),   -- Paris, will head CS
('E000000002', 'D00000002'),   -- Leif, will head EE
('E000000003', NULL),          -- Niharika
('E000000004', NULL),          -- Brian
('E000000005', NULL),          -- Adam
('E000000006', NULL);          -- Anna

-- 6. DEPARTMENT
INSERT INTO department (department_id, department_name, employee_id) VALUES
('D00000001', 'Computer Science',      'E000000001'),
('D00000002', 'Electrical Engineering','E000000002');

-- 7. EMPLOYEE
INSERT INTO employee (employee_id, employment_id, department_id, person_id, job_title_id) VALUES
('E000000001', '500001', 'D00000001', 'P000000001', 'Professor'), -- Paris Carbone, Ass. Prof, CS
('E000000002', '500004', 'D00000001', 'P000000002', 'Lecturer'), -- Leif Lindbäck, Lecturer, CS
('E000000003', '500009', 'D00000001', 'P000000003', 'Lecturer'), -- Niharika Gauraha, Lecturer, CS
('E000000004', '500012', 'D00000002', 'P000000004', 'student'), -- Brian, PhD Student, EE
('E000000005', '500015', 'D00000001', 'P000000005', 'TA'), -- Adam, TA, CS
('E000000006', '500020', 'D00000002', 'P000000006', 'Admin'); -- Anna, Admin, EE

-- 8. SKILL TYPES
INSERT INTO skilltype (skill_id, skill_name) VALUES
('SKILL0001', 'Databases'),
('SKILL0002', 'Distributed Systems'),
('SKILL0003', 'Algorithms'),
('SKILL0004', 'Machine Learning');

-- 9. SKILLSET
INSERT INTO skillset (employee_id, skill_id) VALUES
('E000000001', 'SKILL0001'),
('E000000001', 'SKILL0002'),
('E000000002', 'SKILL0001'),
('E000000002', 'SKILL0003'),
('E000000003', 'SKILL0001'),
('E000000003', 'SKILL0004'),
('E000000004', 'SKILL0002'),
('E000000004', 'SKILL0004'),
('E000000005', 'SKILL0003'),
('E000000006', 'SKILL0001');

-- 10. TEACHING ACTIVITIES (with example factors)
INSERT INTO teaching_activity (activity_id, activity_name, factor) VALUES
('ACT0000001', 'Lecture',          1.00),
('ACT0000002', 'Tutorial',         1.00),
('ACT0000003', 'Lab',              1.00),
('ACT0000004', 'Seminar',          1.00),
('ACT0000005', 'Other Overhead',   1.50),
('ACT0000006', 'Admin',            1.25),
('ACT0000007', 'Exam',             1.50);

-- 11. COURSE LAYOUT
INSERT INTO course_layout (course_id, course_code, course_name, min_students, max_students, hp, course_start_date, course_end_date) VALUES
('C000000001', 'IV1351', 'Applied Database Technology',  50, 300, 7.5, '2025-01-15', '2025-03-15'),
('C000000002', 'IX1500', 'Introduction to Programming',  40, 250, 7.5, '2025-08-25', '2025-10-25'),
('C000000003', 'ID2214', 'Advanced DB Systems',          20, 120, 7.5, '2025-03-16', '2025-05-31'),
('C000000004', 'IV1350', 'Data Storage Systems',         30, 200, 7.5, '2025-11-01', '2026-01-15'),
('C000000005', 'IX1600', 'Systems Programming',          30, 150, 7.5, '2025-08-25', '2025-10-25');

-- 12. COURSE INSTANCES (current year 2025)
INSERT INTO course_instance (instance_id, num_students, study_period, study_year, course_id) VALUES
('2025-50273', 200, 'P2', 2025, 'C000000001'), -- IV1351
('2025-50413', 150, 'P1', 2025, 'C000000002'), -- IX1500
('2025-50341',  80, 'P2', 2025, 'C000000003'), -- ID2214
('2025-60104', 120, 'P3', 2025, 'C000000004'), -- IV1350
('2025-50999',  60, 'P1', 2025, 'C000000005'); -- IX1600 (extra P1 course)

-- 13. PLANNED ACTIVITY
-- Hours are chosen to be “interesting” for OLAP, not to match the example exactly.

-- IV1351, instance 2025-50273
-- Paris Carbone
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000001',  72.0, 'ACT0000001', 'E000000001', '2025-50273'), -- Lecture
('PA00000002', 100.0, 'ACT0000005', 'E000000001', '2025-50273'), -- Overhead
('PA00000003',  43.0, 'ACT0000006', 'E000000001', '2025-50273'), -- Admin
('PA00000004',  61.0, 'ACT0000007', 'E000000001', '2025-50273'); -- Exam

-- Leif Lindbäck
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000005',  64.0, 'ACT0000004', 'E000000002', '2025-50273'), -- Seminar
('PA00000006', 100.0, 'ACT0000005', 'E000000002', '2025-50273'), -- Overhead
('PA00000007',  62.0, 'ACT0000007', 'E000000002', '2025-50273'); -- Exam

-- Niharika Gauraha
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000008',  64.0, 'ACT0000004', 'E000000003', '2025-50273'), -- Seminar
('PA00000009', 100.0, 'ACT0000005', 'E000000003', '2025-50273'), -- Overhead
('PA00000010',  43.0, 'ACT0000006', 'E000000003', '2025-50273'), -- Admin
('PA00000011',  61.0, 'ACT0000007', 'E000000003', '2025-50273'); -- Exam

-- Brian
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000012',  50.0, 'ACT0000003', 'E000000004', '2025-50273'), -- Lab
('PA00000013', 100.0, 'ACT0000005', 'E000000004', '2025-50273'); -- Overhead

-- Adam
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000014',  50.0, 'ACT0000003', 'E000000005', '2025-50273'), -- Lab
('PA00000015',  50.0, 'ACT0000004', 'E000000005', '2025-50273'); -- Seminar

-- IX1500, instance 2025-50413 (Niharika only, for teacher-based OLAP)
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000016', 159.0, 'ACT0000001', 'E000000003', '2025-50413'), -- Lecture
('PA00000017', 100.0, 'ACT0000005', 'E000000003', '2025-50413'), -- Overhead
('PA00000018', 141.0, 'ACT0000006', 'E000000003', '2025-50413'), -- Admin
('PA00000019',  73.0, 'ACT0000007', 'E000000003', '2025-50413'); -- Exam

-- ID2214, instance 2025-50341 (Niharika again)
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000020',  44.0, 'ACT0000001', 'E000000003', '2025-50341'), -- Lecture
('PA00000021',  36.0, 'ACT0000002', 'E000000003', '2025-50341'), -- Tutorial
('PA00000022',  40.0, 'ACT0000005', 'E000000003', '2025-50341'), -- Overhead
('PA00000023',  20.0, 'ACT0000007', 'E000000003', '2025-50341'); -- Exam

-- IV1350, instance 2025-60104 (Niharika again, P3)
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000024',  25.0, 'ACT0000002', 'E000000003', '2025-60104'), -- Tutorial
('PA00000025', 100.0, 'ACT0000005', 'E000000003', '2025-60104'), -- Overhead
('PA00000026',  74.0, 'ACT0000007', 'E000000003', '2025-60104'); -- Exam

-- IX1600, instance 2025-50999 (extra P1 course so Niharika has 2 P1 courses)
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, employee_id, instance_id) VALUES
('PA00000027',  60.0, 'ACT0000001', 'E000000003', '2025-50999'), -- Lecture
('PA00000028',  30.0, 'ACT0000003', 'E000000003', '2025-50999'), -- Lab
('PA00000029',  40.0, 'ACT0000005', 'E000000003', '2025-50999'); -- Overhead

-- 14. SALARY
INSERT INTO salary (employee_id, salary_hour, salary_date) VALUES
('E000000001', 800.00, '2025-01-01'),
('E000000002', 700.00, '2025-01-01'),
('E000000003', 650.00, '2025-01-01'),
('E000000004', 450.00, '2025-01-01'),
('E000000005', 300.00, '2025-01-01'),
('E000000006', 500.00, '2025-01-01');

-- 15. WORKLOAD (example mapping of planned activities to actual worked hours)
INSERT INTO workload (employee_id, planned_activity_id, work_hours) VALUES
('E000000001', 'PA00000001', 70.0),
('E000000001', 'PA00000002', 95.0),
('E000000002', 'PA00000005', 60.0),
('E000000003', 'PA00000008', 64.0),
('E000000003', 'PA00000016', 150.0),
('E000000003', 'PA00000020', 42.0),
('E000000003', 'PA00000024', 24.0),
('E000000004', 'PA00000012', 48.0),
('E000000005', 'PA00000014', 50.0),
('E000000005', 'PA00000015', 48.0);
