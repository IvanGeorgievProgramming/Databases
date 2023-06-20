SELECT
    Students.Id AS Num,
    Students.ClassNumber AS ClassNum,
    Students.Class AS ClassLetter,
    AVG(StudentMarks.NumericGrade) AS StudentAvg,
    Classes.AvgMark AS ClassAvg
FROM
    Students
JOIN
    StudentMarks ON Students.Id = StudentMarks.StudentId
JOIN
    Classes ON Students.ClassNumber = Classes.ClassNum AND Students.Class = Classes.ClassLetter
GROUP BY
    Students.Id
HAVING
    StudentAvg > ClassAvg;
