SELECT CONCAT(s.ClassNum, s.ClassLetter) AS Position, s.Name FROM Students s
WHERE s.ClassNum IN (8, 9, 11)
ORDER BY s.Name ASC;