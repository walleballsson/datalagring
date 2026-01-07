-- test the view
-- DROP VIEW IF EXISTS v_allocated_hours_per_teacher;
--CREATE VIEW v_allocated_hours_per_teacher AS
SELECT
  c.course_code                           AS `Course Code`,
  ci.instance_id                          AS `Course Instance ID`,
  c.hp                                    AS `HP`,
  CONCAT(p.first_name, ' ', p.last_name)  AS `Teacher's name`,
  j.job_title_name                        AS `Designation`,

  SUM(CASE WHEN ta.activity_name = 'Lecture'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Lecture Hours`,

  SUM(CASE WHEN ta.activity_name = 'Tutorial'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Tutorial Hours`,

  SUM(CASE WHEN ta.activity_name = 'Lab'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Lab Hours`,

  SUM(CASE WHEN ta.activity_name = 'Seminar'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Seminar Hours`,

  SUM(CASE WHEN ta.activity_name = 'Other Overhead'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Other Overhead Hours`,

  SUM(CASE WHEN ta.activity_name = 'Admin'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Admin`,

  SUM(CASE WHEN ta.activity_name = 'Exam'
           THEN COALESCE(wl.work_hours,0) * ta.factor ELSE 0 END) AS `Exam`,

  SUM(COALESCE(wl.work_hours,0) * ta.factor) AS `Total Hours`

FROM course_instance ci
JOIN course_layout c
  ON ci.course_id = c.course_id

LEFT JOIN planned_activity pa
  ON pa.instance_id = ci.instance_id

LEFT JOIN teaching_activity ta
  ON ta.activity_id = pa.activity_id

LEFT JOIN workload wl
  ON wl.planned_activity_id = pa.planned_activity_id

LEFT JOIN employee e
  ON e.employee_id = wl.employee_id

LEFT JOIN person p
  ON p.person_id = e.person_id

LEFT JOIN jobtitle j
  ON j.job_title_id = e.job_title_id

WHERE ci.study_year = YEAR(CURDATE())
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
