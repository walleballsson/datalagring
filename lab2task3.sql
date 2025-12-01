-- test the view
-- DROP VIEW IF EXISTS v_allocated_hours_per_teacher;
--CREATE VIEW v_allocated_hours_per_teacher AS
SELECT
c.course_code                              AS `Course Code`,
ci.instance_id                             AS `Course Instance ID`,
c.hp                                       AS `HP`,
CONCAT(p.first_name, ' ', p.last_name)    AS `Teacher's name`,
j.job_title_name                            AS `Designation`,

SUM(CASE WHEN ta.activity_name = 'Lecture'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Lecture Hours`,

SUM(CASE WHEN ta.activity_name = 'Tutorial'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Tutorial Hours`,

SUM(CASE WHEN ta.activity_name = 'Lab'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Lab Hours`,

SUM(CASE WHEN ta.activity_name = 'Seminar'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Seminar Hours`,

SUM(CASE WHEN ta.activity_name = 'Other Overhead'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Other Overhead Hours`,

SUM(CASE WHEN ta.activity_name = 'Admin'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Admin`,

SUM(CASE WHEN ta.activity_name = 'Exam'
         THEN pa.planned_hours * ta.factor ELSE 0 END) AS `Exam`,

-- total planned hours * factor over all activities
SUM(pa.planned_hours * ta.factor)                     AS `Total Hours`

FROM course_instance ci
JOIN course_layout     c ON ci.course_id     = c.course_id
LEFT JOIN planned_activity   pa ON pa.instance_id  = ci.instance_id
LEFT JOIN teaching_activity  ta ON ta.activity_id  = pa.activity_id
LEFT JOIN employee e ON pa.employee_id = e.employee_id
LEFT JOIN person p ON e.person_id = p.person_id
LEFT JOIN jobtitle j           ON e.job_title_id   = j.job_title_id
WHERE ci.study_year = YEAR(CURDATE())   -- "current year"
AND p.last_name = 'Carbone'
GROUP BY
c.course_code,
ci.instance_id,
c.hp,
p.last_name,
p.first_name,
j.job_title_name
ORDER BY
c.course_code,
ci.instance_id;

-- Test the view, remove: AND p.last_name = 'Carbone'
--SELECT *
--FROM v_allocated_hours_per_teacher
--WHERE teacher_name = 'Niharika Gauraha';
