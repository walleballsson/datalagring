# University Staff Database

A relational database system modelling teaching staff, course instances,
workload allocation, and salary at a university.
Built across three labs for KTH course IV1351 Database Technology.

## What it does
- Models employees, departments, courses, planned activities, and salary history
- Analytical SQL queries that show worked hours per teacher per course
- Enforces a business rule: max 4 course instances per teacher per study period
- Java CLI application for querying and updating the database

## Tech
- MySQL
- Java with JDBC
- SQL (schema design, OLAP queries, triggers)

## Structure
schema.sql        - database schema (3NF, 12 tables)
data.sql          - sample data
lab2task1.sql     - query: list all course instances
lab2task2.sql     - query: hours per teacher per course instance
lab2task3.sql     - query: hours per teacher across all courses
lab2task4.sql     - query: salary cost per course
lab3Main.java     - Java CLI with transaction control

## Setup
1. Create the database: mysql -u root -p < schema.sql
2. Load sample data:    mysql -u root -p mydb < data.sql
3. Run the Java app:    javac lab3Main.java && java lab3Main
