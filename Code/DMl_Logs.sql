CREATE OR REPLACE FUNCTION student_trigger_function()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE no_of_rows_affected INTEGER;
BEGIN
	IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
		no_of_rows_affected := (SELECT COUNT(*) FROM new_table);
	ELSIF (TG_OP = 'DELETE') THEN
		no_of_rows_affected := (SELECT COUNT(*) FROM old_table);
	ELSIF (TG_OP = 'TRUNCATE') THEN
		no_of_rows_affected := (SELECT COUNT(*) FROM Student_Details);
	END IF;

	INSERT INTO Student_Details_DML_Logs
	VALUES
	(CURRENT_TIMESTAMP, TG_OP, no_of_rows_affected);

	RETURN NULL;
END;
$$;


CREATE TRIGGER student_trigger_insert AFTER INSERT ON Student_Details
REFERENCING NEW TABLE AS new_table
FOR EACH STATEMENT
EXECUTE FUNCTION student_trigger_function();

CREATE TRIGGER student_trigger_update AFTER UPDATE ON Student_Details
REFERENCING NEW TABLE AS new_table OLD TABLE AS old_table
FOR EACH STATEMENT
EXECUTE FUNCTION student_trigger_function();

CREATE TRIGGER student_trigger_delete AFTER DELETE ON Student_Details
REFERENCING OLD TABLE AS old_table
FOR EACH STATEMENT
EXECUTE FUNCTION student_trigger_function();

CREATE TRIGGER student_trigger_truncate BEFORE TRUNCATE ON Student_Details
FOR EACH STATEMENT
EXECUTE FUNCTION student_trigger_function();
