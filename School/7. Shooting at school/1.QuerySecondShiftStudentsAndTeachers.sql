SELECT Name, CONCAT(ClassNumber, Class) AS Position
FROM Students
WHERE ClassNumber IN (8, 9, 11)

UNION

SELECT Name, 'Teacher' AS Position
FROM Teachers

ORDER BY Name;
