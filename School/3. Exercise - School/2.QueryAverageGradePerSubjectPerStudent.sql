SELECT Students.Name, Students.ClassNumber, StudentMarks.SubjectName, AVG(StudentMarks.NumericGrade) AS AverageGrade
FROM Students
INNER JOIN StudentMarks ON Students.Id = StudentMarks.StudentId
GROUP BY Students.Id, StudentMarks.SubjectName;
