CREATE OR REPLACE FUNCTION log_student_details_schema_before_alter()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF tg_event = 'ddl_command_start' THEN
        INSERT INTO student_details_schema_log(operationdttm, operation, schema_before_change)
        SELECT
            current_timestamp,
            'ALTER TABLE',
			jsonb_object_agg (column_name,data_type)
        FROM information_schema.columns c
        WHERE c.table_schema = 'public'
          AND c.table_name = 'student_details';
    END IF;
END;
$$;

CREATE EVENT TRIGGER log_student_details_before_alter
ON ddl_command_start
WHEN TAG IN ('ALTER TABLE')
EXECUTE FUNCTION log_student_details_schema_before_alter();

CREATE OR REPLACE FUNCTION log_student_details_schema_after_alter()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF tg_event = 'ddl_command_end' THEN
		UPDATE student_details_schema_log SET schema_after_change = (SELECT
		jsonb_object_agg (column_name,data_type)
        FROM information_schema.columns c
        WHERE c.table_schema = 'public'
          AND c.table_name = 'student_details')
		  WHERE operationdttm = (SELECT MAX(operationdttm) FROM student_details_schema_log);
    END IF;
END;
$$;

CREATE EVENT TRIGGER log_student_details_after_alter
ON ddl_command_end
WHEN TAG IN ('ALTER TABLE')
EXECUTE FUNCTION log_student_details_schema_after_alter();
