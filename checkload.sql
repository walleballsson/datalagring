DELIMITER $$

CREATE TRIGGER trg_check_teacher_load
BEFORE INSERT ON planned_activity
FOR EACH ROW
BEGIN
  DECLARE v_count INT;

  SELECT COUNT(DISTINCT pa.instance_id)
    INTO v_count
  FROM planned_activity pa
  JOIN course_instance ci_existing
      ON ci_existing.instance_id = pa.instance_id
  JOIN course_instance ci_new
      ON ci_new.instance_id = NEW.instance_id
  WHERE pa.employment_id = NEW.employment_id
    AND ci_existing.study_period = ci_new.study_period
    AND ci_existing.study_year  = ci_new.study_year;

  IF v_count >= 4 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = CONCAT(
        'Teacher ', NEW.employment_id,
        ' already has 4 course instances in that period/year'
      );
  END IF;
END$$

DELIMITER ;
