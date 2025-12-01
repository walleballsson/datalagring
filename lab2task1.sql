-- test the view
--CREATE VIEW v_planned_hours_per_instance AS
SELECT
    c.course_code                              AS `Course Code`,
    ci.instance_id                             AS `Course Instance ID`,
    c.hp                                       AS `HP`,
    ci.study_period                            AS `Period`,
    ci.num_students                            AS `# Students`,

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

    SUM(pa.planned_hours * ta.factor)                     AS `Total Hours`

FROM course_instance ci
JOIN course_layout     c  ON ci.course_id     = c.course_id
LEFT JOIN planned_activity   pa ON pa.instance_id  = ci.instance_id
LEFT JOIN teaching_activity  ta ON ta.activity_id  = pa.activity_id
WHERE ci.study_year = YEAR(CURDATE())   -- "current year"
GROUP BY
    c.course_code,
    ci.instance_id,
    c.hp,
    ci.study_period,
    ci.num_students
ORDER BY
    c.course_code,
    ci.instance_id;

-- test the view
--SELECT * FROM v_planned_hours_per_instance;
