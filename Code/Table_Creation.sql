CREATE TABLE Student_Details
(
	Student_Id INTEGER,
	Student_Name TEXT,
	Studnt_DOB DATE,
	Student_Age INTEGER,
	Student_Address TEXT
);

CREATE TABLE Student_Details_DML_Logs
(
	OperationDttm TIMESTAMP,
	Operation TEXT,
	No_Of_Rows_Affected INTEGER
);

CREATE TABLE student_details_schema_log(
  operationdttm TIMESTAMP DEFAULT current_timestamp,
  operation TEXT,
  schema_before_change JSONB,
	schema_after_change JSONB
);
