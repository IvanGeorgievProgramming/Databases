SELECT Students.Name, StudentMarks.NumericGrade, Students.Class, Students.ClassNumber
FROM Students
INNER JOIN StudentMarks ON Students.Id = StudentMarks.StudentId
WHERE Students.Class IN ('11th', '12th')
ORDER BY StudentMarks.NumericGrade DESC, Students.Class, Students.Name;
