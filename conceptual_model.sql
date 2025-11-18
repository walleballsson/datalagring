CREATE TABLE course_layout (
 course_code   UNIQUE CHAR(10),
 course_name CHAR(10) NOT NULL,
 min_students INT NOT NULL,
 max_students INT,
 hp INT NOT NULL
);


CREATE TABLE department (
 department_name UNIQUE CHAR(10)
);


CREATE TABLE job_title (
 job_title UNIQUE CHAR(10)
);


CREATE TABLE person (
 personal_number UNIQUE CHAR(10),
 first_name CHAR(10) NOT NULL,
 last_name CHAR(10) NOT NULL,
 phone_number CHAR(10) NOT NULL,
 address CHAR(10) NOT NULL
);


CREATE TABLE teaching_activity (
 activity_name UNIQUE CHAR(10),
 factor FLOAT(10) NOT NULL
);


CREATE TABLE course_instance (
 instance_id UNIQUE CHAR(10),
 num_students CHAR(10) NOT NULL,
 study_period CHAR(10) NOT NULL,
 study_year CHAR(10) NOT NULL
);


CREATE TABLE employee (
 employment_id UNIQUE CHAR(10),
 skill_set CHAR(10) NOT NULL,
 salary CHAR(10) NOT NULL,
 supervisor/manager CHAR(10)
);


CREATE TABLE planned_activity (
 planned_hours CHAR(10) NOT NULL
);


