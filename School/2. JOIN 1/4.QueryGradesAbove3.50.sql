SELECT 
    Students.Name AS 'Student name',
    Students.ClassNumber AS 'Class number',
    StudentMarks.NumericGrade AS 'Grade',
    StudentMarks.SubjectName AS 'Subject',
    MarksAsWord.grade_in_words AS 'Grade in words',
    StudentMarks.NumericGrade AS 'Grade in numbers'
FROM 
    Students 
    JOIN StudentMarks ON Students.Id = StudentMarks.StudentId
    JOIN MarksAsWord ON StudentMarks.NumericGrade BETWEEN MarksAsWord.grade_from AND MarksAsWord.grade_to
WHERE 
    StudentMarks.NumericGrade > 3.50
ORDER BY 
    StudentMarks.NumericGrade DESC;
