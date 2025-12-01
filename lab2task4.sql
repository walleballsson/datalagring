-- test the view 
-- DROP VIEW IF EXISTS v_allocated_hours_per_teacher;
-- CREATE VIEW v_courses_per_teacher_period AS
SET @min_courses := 1;     
SET @current_period := 'P1'; 

SELECT
    e.employment_id                               AS `Employment ID`,
    CONCAT(p.first_name, ' ', p.last_name)        AS `Teacher's Name`,
    ci.study_period                               AS `Period`,
    COUNT(DISTINCT ci.instance_id)                AS `No of courses`
FROM planned_activity pa
JOIN employee       e  ON pa.employee_id   = e.employee_id
JOIN person         p  ON e.person_id      = p.person_id
JOIN course_instance ci ON pa.instance_id  = ci.instance_id
WHERE ci.study_year   = YEAR(CURDATE())     
  AND ci.study_period = @current_period     
GROUP BY
    e.employment_id,
    `Teacher's Name`,
    ci.study_period
HAVING
    COUNT(DISTINCT ci.instance_id) > @min_courses
ORDER BY
    `No of courses` DESC;

-- Test the view. remove: set @min_courses := 1; and set @current_period := 'P1'; and the WHERE clause and HAVING clause ORDER BY no_of_courses DESC;
--SET @min_courses := 1;
--SET @current_period := 'P1';
--SELECT *
--FROM v_courses_per_teacher_period
--WHERE study_year = YEAR(CURDATE())
  --AND period = @current_period
  --AND no_of_courses > @min_courses
--ORDER BY no_of_courses DESC;
