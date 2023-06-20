SELECT *
FROM
    (
        SELECT
            S.Name AS 'Student Name',
            S.ClassNumber AS 'Class number',
            S.Class AS 'Grade',
            AVG(SM.NumericGrade) AS 'Grade Point Average'
        FROM
            Students S
            INNER JOIN StudentMarks SM ON S.Id = SM.StudentId
        GROUP BY
            S.Id
        ORDER BY
            AVG(SM.NumericGrade) DESC
        LIMIT 3
    ) AS BestStudents
UNION
SELECT *
FROM
    (
        SELECT
            S.Name AS 'Student Name',
            S.ClassNumber AS 'Class number',
            S.Class AS 'Grade',
            AVG(SM.NumericGrade) AS 'Grade Point Average'
        FROM
            Students S
            INNER JOIN StudentMarks SM ON S.Id = SM.StudentId
        GROUP BY
            S.Id
        ORDER BY
            AVG(SM.NumericGrade) ASC
        LIMIT 3
    ) AS WorstStudents;
