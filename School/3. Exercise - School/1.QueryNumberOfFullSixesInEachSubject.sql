SELECT SubjectName, COUNT(*) AS FullSixCount
FROM StudentMarks
WHERE NumericGrade = 6.00
GROUP BY SubjectName;
