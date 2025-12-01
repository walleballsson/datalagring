-- ADDRESS
CREATE TABLE address (
  address_id   CHAR(10) PRIMARY KEY,
  city         VARCHAR(100),
  country      VARCHAR(100),
  address_line VARCHAR(200)
);

-- COURSE LAYOUT
CREATE TABLE course_layout (
  course_id         CHAR(10) PRIMARY KEY,
  course_code       CHAR(10) UNIQUE,
  course_name       VARCHAR(100),
  min_students      INT,
  max_students      INT,
  hp                NUMERIC(4,1),      
  course_start_date DATE,
  course_end_date   DATE
);

-- JOB TITLE
CREATE TABLE jobtitle (
  job_title_id   CHAR(10) PRIMARY KEY,
  job_title_name VARCHAR(50)
);

-- MANAGER
CREATE TABLE manager (
  employee_id   CHAR(10) PRIMARY KEY,
  department_id CHAR(10)
);

-- PERSON
CREATE TABLE person (
  person_id       CHAR(10) PRIMARY KEY,
  personal_number CHAR(12),           
  first_name      VARCHAR(50),
  last_name       VARCHAR(50),
  address_id      CHAR(10),
  CONSTRAINT fk_person_address
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- PHONE (one person can have many phones)
CREATE TABLE phone (
  person_id CHAR(10) NOT NULL,
  phone_id  CHAR(10) NOT NULL,    --might need a change
  PRIMARY KEY (person_id, phone_id),
  CONSTRAINT fk_phone_person
    FOREIGN KEY (person_id) REFERENCES person(person_id)
);

-- SKILL TYPE
CREATE TABLE skilltype (
  skill_id   CHAR(10) PRIMARY KEY,
  skill_name VARCHAR(50)
);

-- TEACHING ACTIVITY
CREATE TABLE teaching_activity (
  activity_id   CHAR(10) PRIMARY KEY,
  activity_name VARCHAR(50) UNIQUE,
  factor        NUMERIC(4,2)         
);

-- COURSE INSTANCE
CREATE TABLE course_instance (
  instance_id   CHAR(10) PRIMARY KEY,
  num_students  INT,
  study_period  CHAR(5),             
  study_year    INT,
  course_id     CHAR(10) NOT NULL,
  CONSTRAINT fk_ci_course
    FOREIGN KEY (course_id) REFERENCES course_layout(course_id)
);

-- DEPARTMENT
CREATE TABLE department (
  department_id   CHAR(10) PRIMARY KEY,
  department_name VARCHAR(100) UNIQUE,
  employee_id     CHAR(10),
  CONSTRAINT fk_department_manager
    FOREIGN KEY (employee_id) REFERENCES manager(employee_id)
);

-- EMPLOYEE
CREATE TABLE employee (
  employee_id   CHAR(10) PRIMARY KEY,
  employment_id CHAR(10) UNIQUE,
  department_id CHAR(10) NOT NULL,
  person_id     CHAR(10) NOT NULL UNIQUE,
  job_title_id  VARCHAR(50) NOT NULL,
  CONSTRAINT fk_employee_department
    FOREIGN KEY (department_id) REFERENCES department(department_id),
  CONSTRAINT fk_employee_person
    FOREIGN KEY (person_id) REFERENCES person(person_id),
  CONSTRAINT fk_employee_jobtitle
    FOREIGN KEY (job_title_id) REFERENCES jobtitle(job_title_id),
  CONSTRAINT fk_employee_manager
    FOREIGN KEY (employee_id) REFERENCES manager(employee_id)
);

-- PLANNED ACTIVITY
CREATE TABLE planned_activity (
  planned_activity_id CHAR(10) PRIMARY KEY,
  planned_hours       NUMERIC(5,1),
  activity_id         CHAR(10) NOT NULL,
  employee_id         CHAR(10),
  instance_id         CHAR(10) NOT NULL,
  CONSTRAINT fk_pa_activity
    FOREIGN KEY (activity_id) REFERENCES teaching_activity(activity_id),
  CONSTRAINT fk_pa_instance
    FOREIGN KEY (instance_id) REFERENCES course_instance(instance_id),
  CONSTRAINT fk_pa_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

-- SALARY
CREATE TABLE salary (
  employee_id  CHAR(10) PRIMARY KEY,
  salary_hour  NUMERIC(10,2),
  salary_date  DATE,
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

-- WORKLOAD
CREATE TABLE workload (
  employee_id          CHAR(10) NOT NULL,
  planned_activity_id  CHAR(10) NOT NULL,
  work_hours           NUMERIC(5,1),
  PRIMARY KEY (employee_id, planned_activity_id),
  CONSTRAINT fk_workload_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
  CONSTRAINT fk_workload_planned_activity
    FOREIGN KEY (planned_activity_id) REFERENCES planned_activity(planned_activity_id)
);
