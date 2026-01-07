-- data.sql
USE mydb;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE workload;
TRUNCATE TABLE salary;
TRUNCATE TABLE planned_activity;
TRUNCATE TABLE course_instance;
TRUNCATE TABLE course_layout;
TRUNCATE TABLE teaching_activity;
TRUNCATE TABLE skillset;
TRUNCATE TABLE skilltype;
TRUNCATE TABLE employee;
TRUNCATE TABLE department;
TRUNCATE TABLE phone;
TRUNCATE TABLE person;
TRUNCATE TABLE jobtitle;
TRUNCATE TABLE address;

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

-- 5. DEPARTMENT (manager set after employees exist)
INSERT INTO department (department_id, department_name, manager_employee_id) VALUES
('D00000001', 'Computer Science',       NULL),
('D00000002', 'Electrical Engineering', NULL);

-- 6. EMPLOYEE
INSERT INTO employee (employee_id, employment_id, department_id, person_id, job_title_id) VALUES
('E000000001', '500001', 'D00000001', 'P000000001', 'JT0000001'),
('E000000002', '500004', 'D00000001', 'P000000002', 'JT0000002'),
('E000000003', '500009', 'D00000001', 'P000000003', 'JT0000002'),
('E000000004', '500012', 'D00000002', 'P000000004', 'JT0000003'),
('E000000005', '500015', 'D00000001', 'P000000005', 'JT0000004'),
('E000000006', '500020', 'D00000002', 'P000000006', 'JT0000005');

UPDATE department SET manager_employee_id = 'E000000001' WHERE department_id = 'D00000001';
UPDATE department SET manager_employee_id = 'E000000002' WHERE department_id = 'D00000002';

-- 7. SKILL TYPES
INSERT INTO skilltype (skill_id, skill_name) VALUES
('SKILL0001', 'Databases'),
('SKILL0002', 'Distributed Systems'),
('SKILL0003', 'Algorithms'),
('SKILL0004', 'Machine Learning');

-- 8. SKILLSET
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

-- 9. TEACHING ACTIVITIES
INSERT INTO teaching_activity (activity_id, activity_name, factor) VALUES
('ACT0000001', 'Lecture',          1.00),
('ACT0000002', 'Tutorial',         1.00),
('ACT0000003', 'Lab',              1.00),
('ACT0000004', 'Seminar',          1.00),
('ACT0000005', 'Other Overhead',   1.50),
('ACT0000006', 'Admin',            1.25),
('ACT0000007', 'Exam',             1.50);

-- 10. COURSE LAYOUT
INSERT INTO course_layout (course_id, course_code, course_name, min_students, max_students, hp, course_start_date, course_end_date) VALUES
('C000000001', 'IV1351', 'Applied Database Technology',  50, 300, 7.5, '2025-01-15', '2025-03-15'),
('C000000002', 'IX1500', 'Introduction to Programming',  40, 250, 7.5, '2025-08-25', '2025-10-25'),
('C000000003', 'ID2214', 'Advanced DB Systems',          20, 120, 7.5, '2025-03-16', '2025-05-31'),
('C000000004', 'IV1350', 'Data Storage Systems',         30, 200, 7.5, '2025-11-01', '2026-01-15'),
('C000000005', 'IX1600', 'Systems Programming',          30, 150, 7.5, '2025-08-25', '2025-10-25');

-- 11. COURSE INSTANCES
INSERT INTO course_instance (instance_id, num_students, study_period, study_year, course_id) VALUES
('2025-50273', 200, 'P2', 2025, 'C000000001'),
('2025-50413', 150, 'P1', 2025, 'C000000002'),
('2025-50341',  80, 'P2', 2025, 'C000000003'),
('2025-60104', 120, 'P3', 2025, 'C000000004'),
('2025-50999',  60, 'P1', 2025, 'C000000005');

-- 12. PLANNED ACTIVITY
INSERT INTO planned_activity (planned_activity_id, planned_hours, activity_id, instance_id) VALUES
('PA00000001',  72.0, 'ACT0000001', '2025-50273'),
('PA00000002', 100.0, 'ACT0000005', '2025-50273'),
('PA00000003',  43.0, 'ACT0000006', '2025-50273'),
('PA00000004',  61.0, 'ACT0000007', '2025-50273'),
('PA00000005',  64.0, 'ACT0000004', '2025-50273'),
('PA00000006', 100.0, 'ACT0000005', '2025-50273'),
('PA00000007',  62.0, 'ACT0000007', '2025-50273'),
('PA00000008',  64.0, 'ACT0000004', '2025-50273'),
('PA00000009', 100.0, 'ACT0000005', '2025-50273'),
('PA00000010',  43.0, 'ACT0000006', '2025-50273'),
('PA00000011',  61.0, 'ACT0000007', '2025-50273'),
('PA00000012',  50.0, 'ACT0000003', '2025-50273'),
('PA00000013', 100.0, 'ACT0000005', '2025-50273'),
('PA00000014',  50.0, 'ACT0000003', '2025-50273'),
('PA00000015',  50.0, 'ACT0000004', '2025-50273'),
('PA00000016', 159.0, 'ACT0000001', '2025-50413'),
('PA00000017', 100.0, 'ACT0000005', '2025-50413'),
('PA00000018', 141.0, 'ACT0000006', '2025-50413'),
('PA00000019',  73.0, 'ACT0000007', '2025-50413'),
('PA00000020',  44.0, 'ACT0000001', '2025-50341'),
('PA00000021',  36.0, 'ACT0000002', '2025-50341'),
('PA00000022',  40.0, 'ACT0000005', '2025-50341'),
('PA00000023',  20.0, 'ACT0000007', '2025-50341'),
('PA00000024',  25.0, 'ACT0000002', '2025-60104'),
('PA00000025', 100.0, 'ACT0000005', '2025-60104'),
('PA00000026',  74.0, 'ACT0000007', '2025-60104'),
('PA00000027',  60.0, 'ACT0000001', '2025-50999'),
('PA00000028',  30.0, 'ACT0000003', '2025-50999'),
('PA00000029',  40.0, 'ACT0000005', '2025-50999');

-- 13. SALARY
INSERT INTO salary (employee_id, salary_date, salary_hour) VALUES
('E000000001', '2025-01-01', 800.00),
('E000000002', '2025-01-01', 700.00),
('E000000003', '2025-01-01', 650.00),
('E000000004', '2025-01-01', 450.00),
('E000000005', '2025-01-01', 300.00),
('E000000006', '2025-01-01', 500.00);

-- 14. WORKLOAD
INSERT INTO workload (employee_id, planned_activity_id, work_hours) VALUES
('E000000001', 'PA00000001', 70.0),
('E000000001', 'PA00000002', 95.0),
('E000000002', 'PA00000005', 60.0),
('E000000003', 'PA00000008', 64.0),
('E000000003', 'PA00000016', 150.0),
('E000000003', 'PA00000024', 24.0),
('E000000004', 'PA00000012', 48.0),
('E000000005', 'PA00000014', 50.0),
('E000000005', 'PA00000015', 48.0),
('E000000001', 'PA00000003', 40.0),
('E000000001', 'PA00000004', 55.0),
('E000000002', 'PA00000007', 50.0),
('E000000003', 'PA00000010', 30.0),
('E000000003', 'PA00000011', 45.0),
('E000000003', 'PA00000018', 120.0),
('E000000003', 'PA00000019', 60.0),
('E000000003', 'PA00000023', 15.0),
('E000000003', 'PA00000026', 60.0);

SET FOREIGN_KEY_CHECKS = 1;
