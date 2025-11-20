-- Drop tables if they already exist (optional, but useful while developing)
DROP TABLE IF EXISTS planned_activity;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS course_instance;
DROP TABLE IF EXISTS teaching_activity;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS job_title;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS course_layout;

-- COURSE LAYOUT
CREATE TABLE course_layout (
  course_code   CHAR(10) PRIMARY KEY,
  course_name   VARCHAR(100) NOT NULL,
  min_students  INT NOT NULL,
  max_students  INT NOT NULL,
 hp DECIMAL(4,1) NOT NULL
);

-- DEPARTMENT
CREATE TABLE department (
  department_name VARCHAR(50) PRIMARY KEY,
   manager_id      CHAR(10) 
);

-- JOB TITLE
CREATE TABLE job_title (
  job_title VARCHAR(50) PRIMARY KEY
);

-- PERSON
CREATE TABLE person (
  personal_number CHAR(10) PRIMARY KEY,
  first_name      VARCHAR(50) NOT NULL,
  last_name       VARCHAR(50) NOT NULL,
  phone_number    VARCHAR(20) NOT NULL,
  address         VARCHAR(100) NOT NULL
);

-- TEACHING ACTIVITY
CREATE TABLE teaching_activity (
  activity_name VARCHAR(50) PRIMARY KEY,
  factor        DECIMAL(5,2) NOT NULL
);

-- COURSE INSTANCE
CREATE TABLE course_instance (
  instance_id   CHAR(10) PRIMARY KEY,
  course_code   CHAR(10) NOT NULL,
  num_students  INT NOT NULL,
  study_period  INT NOT NULL,
  study_year    INT NOT NULL,
  FOREIGN KEY (course_code) REFERENCES course_layout(course_code)
);

-- EMPLOYEE (subtype of PERSON)
CREATE TABLE employee (
  employment_id       CHAR(10) PRIMARY KEY,
  personal_number     CHAR(10) NOT NULL UNIQUE,
  department_name     VARCHAR(50) NOT NULL,
  job_title           VARCHAR(50) NOT NULL,
  skill_set           VARCHAR(100) NOT NULL,
  salary              DECIMAL(10,2) NOT NULL,
  supervisor_manager  TINYINT(1),  -- 0/1 flag

  FOREIGN KEY (personal_number) REFERENCES person(personal_number),
  FOREIGN KEY (department_name) REFERENCES department(department_name),
  FOREIGN KEY (job_title)       REFERENCES job_title(job_title)
);

ALTER TABLE department
  ADD CONSTRAINT fk_department_manager
  FOREIGN KEY (manager_id) REFERENCES employee(employment_id);


-- PLANNED ACTIVITY (allocation of teachers to course instances)
CREATE TABLE planned_activity (
  planned_activity_id INT AUTO_INCREMENT PRIMARY KEY,
  planned_hours       INT NOT NULL,
  instance_id         CHAR(10) NOT NULL,
  employment_id       CHAR(10) NOT NULL,
  activity_name       VARCHAR(50) NOT NULL,

  FOREIGN KEY (instance_id)   REFERENCES course_instance(instance_id),
  FOREIGN KEY (employment_id) REFERENCES employee(employment_id),
  FOREIGN KEY (activity_name) REFERENCES teaching_activity(activity_name)
);
