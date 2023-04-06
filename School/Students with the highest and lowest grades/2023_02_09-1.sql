SELECT
    Students.Name,
    Students.ClassNum,
    Students.ClassLetter,
    ROUND(AVG(StudentMarks.Mark), 2)
FROM
    Students
JOIN
    StudentMarks ON Students.Id = StudentMarks.StudentId
GROUP BY
    Students.Id
HAVING
    COUNT(*) >= 3
ORDER BY
    AVG(StudentMarks.Mark) DESC
LIMIT 3

UNION ALL

SELECT
    Students.Name,
    Students.ClassNum,
    Students.ClassLetter,
    ROUND(AVG(StudentMarks.Mark), 2)
FROM
    Students
JOIN
    StudentMarks ON Students.Id = StudentMarks.StudentId
GROUP BY
    Students.Id
HAVING
    COUNT(*) >= 3
ORDER BY
    AVG(StudentMarks.Mark) ASC
LIMIT 3;
