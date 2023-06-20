SELECT Students.Name, Students.ClassNumber, StudentMarks.NumericGrade, Students.Class, AVG(StudentMarks.NumericGrade) AS GradePointAverage
FROM Students
INNER JOIN StudentMarks ON Students.Id = StudentMarks.StudentId
GROUP BY Students.Id
HAVING GradePointAverage >= 5.00;
