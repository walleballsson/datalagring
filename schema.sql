-- schema.sql
DROP DATABASE IF EXISTS mydb;
CREATE DATABASE mydb;
USE mydb;

SET FOREIGN_KEY_CHECKS = 0;

-- ADDRESS
CREATE TABLE address (
  address_id   CHAR(10) PRIMARY KEY,
  city         VARCHAR(100) NOT NULL,
  country      VARCHAR(100) NOT NULL,
  address_line VARCHAR(200) NOT NULL
);

-- COURSE LAYOUT
CREATE TABLE course_layout (
  course_id         CHAR(10) PRIMARY KEY,
  course_code       CHAR(10) NOT NULL UNIQUE,
  course_name       VARCHAR(100) NOT NULL,
  min_students      INT NOT NULL,
  max_students      INT NOT NULL,
  hp                NUMERIC(4,1) NOT NULL,
  course_start_date DATE NOT NULL,
  course_end_date   DATE NOT NULL
);

-- JOB TITLE
CREATE TABLE jobtitle (
  job_title_id   CHAR(10) PRIMARY KEY,
  job_title_name VARCHAR(50) NOT NULL
);

-- PERSON
CREATE TABLE person (
  person_id       CHAR(10) PRIMARY KEY,
  personal_number CHAR(12) NOT NULL UNIQUE,
  first_name      VARCHAR(50) NOT NULL,
  last_name       VARCHAR(50) NOT NULL,
  address_id      CHAR(10),
  CONSTRAINT fk_person_address
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- PHONE (one person can have many phones)
CREATE TABLE phone (
  person_id CHAR(10) NOT NULL,
  phone_id  CHAR(10) NOT NULL,
  PRIMARY KEY (person_id, phone_id),
  CONSTRAINT fk_phone_person
    FOREIGN KEY (person_id) REFERENCES person(person_id)
);

-- SKILL TYPE
CREATE TABLE skilltype (
  skill_id   CHAR(10) PRIMARY KEY,
  skill_name VARCHAR(50) NOT NULL UNIQUE
);

-- TEACHING ACTIVITY
CREATE TABLE teaching_activity (
  activity_id   CHAR(10) PRIMARY KEY,
  activity_name VARCHAR(50) NOT NULL UNIQUE,
  factor        NUMERIC(4,2) NOT NULL
);

-- DEPARTMENT (manager is an employee; FK added after employee exists)
CREATE TABLE department (
  department_id       CHAR(10) PRIMARY KEY,
  department_name     VARCHAR(100) NOT NULL UNIQUE,
  manager_employee_id CHAR(10) NULL
);

-- EMPLOYEE
CREATE TABLE employee (
  employee_id   CHAR(10) PRIMARY KEY,
  employment_id CHAR(10) NOT NULL UNIQUE,
  department_id CHAR(10) NOT NULL,
  person_id     CHAR(10) NOT NULL UNIQUE,
  job_title_id  CHAR(10) NOT NULL,
  CONSTRAINT fk_employee_department
    FOREIGN KEY (department_id) REFERENCES department(department_id),
  CONSTRAINT fk_employee_person
    FOREIGN KEY (person_id) REFERENCES person(person_id),
  CONSTRAINT fk_employee_jobtitle
    FOREIGN KEY (job_title_id) REFERENCES jobtitle(job_title_id)
);

-- Add department manager FK now that employee exists
ALTER TABLE department
  ADD CONSTRAINT fk_department_manager_employee
    FOREIGN KEY (manager_employee_id) REFERENCES employee(employee_id);

-- COURSE INSTANCE
CREATE TABLE course_instance (
  instance_id   CHAR(10) PRIMARY KEY,
  num_students  INT NOT NULL,
  study_period  CHAR(5) NOT NULL,
  study_year    INT NOT NULL,
  course_id     CHAR(10) NOT NULL,
  CONSTRAINT fk_ci_course
    FOREIGN KEY (course_id) REFERENCES course_layout(course_id)
);

-- PLANNED ACTIVITY (no employee_id)
CREATE TABLE planned_activity (
  planned_activity_id CHAR(10) PRIMARY KEY,
  planned_hours       NUMERIC(5,1) NOT NULL,
  activity_id         CHAR(10) NOT NULL,
  instance_id         CHAR(10) NOT NULL,
  CONSTRAINT fk_pa_activity
    FOREIGN KEY (activity_id) REFERENCES teaching_activity(activity_id),
  CONSTRAINT fk_pa_instance
    FOREIGN KEY (instance_id) REFERENCES course_instance(instance_id)
);

-- SALARY HISTORY
CREATE TABLE salary (
  employee_id CHAR(10) NOT NULL,
  salary_date DATE NOT NULL,
  salary_hour NUMERIC(10,2) NOT NULL,
  PRIMARY KEY (employee_id, salary_date),
  CONSTRAINT fk_salary_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

-- SKILLSET
CREATE TABLE skillset (
  employee_id CHAR(10) NOT NULL,
  skill_id    CHAR(10) NOT NULL,
  PRIMARY KEY (employee_id, skill_id),
  CONSTRAINT fk_skillset_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
  CONSTRAINT fk_skillset_skill
    FOREIGN KEY (skill_id) REFERENCES skilltype(skill_id)
);

-- WORKLOAD (allocated hours)
CREATE TABLE workload (
  employee_id         CHAR(10) NOT NULL,
  planned_activity_id CHAR(10) NOT NULL,
  work_hours          NUMERIC(5,1) NOT NULL,
  PRIMARY KEY (employee_id, planned_activity_id),
  CONSTRAINT fk_workload_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
  CONSTRAINT fk_workload_planned_activity
    FOREIGN KEY (planned_activity_id) REFERENCES planned_activity(planned_activity_id)
);

SET FOREIGN_KEY_CHECKS = 1;
