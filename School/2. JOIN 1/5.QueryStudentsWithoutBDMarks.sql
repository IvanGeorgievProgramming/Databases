SELECT Students.Name, Students.ClassNumber, StudentMarks.NumericGrade
FROM Students
LEFT JOIN StudentMarks ON Students.Id = StudentMarks.StudentId
WHERE StudentMarks.Id IS NULL OR StudentMarks.SubjectName != 'BD';
