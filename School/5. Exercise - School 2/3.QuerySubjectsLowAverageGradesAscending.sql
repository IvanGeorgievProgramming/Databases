SELECT SubjectName, AVG(NumericGrade) AS average_grade
FROM StudentMarks
GROUP BY SubjectName
HAVING average_grade < (
    SELECT AVG(NumericGrade)
    FROM StudentMarks
)
ORDER BY average_grade ASC;
