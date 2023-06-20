CREATE VIEW Classes AS
SELECT
    ClassNumber AS ClassNum,
    Class AS ClassLetter,
    AVG(NumericGrade) AS AvgMark
FROM
    Students
JOIN
    StudentMarks ON Students.Id = StudentMarks.StudentId
GROUP BY
    ClassNumber, Class;
