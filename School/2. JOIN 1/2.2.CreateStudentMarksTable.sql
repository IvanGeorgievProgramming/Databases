USE School;

DROP TABLE IF EXISTS StudentMarks;

CREATE TABLE StudentMarks (
    Id INTEGER NOT NULL AUTO_INCREMENT,
    StudentId INTEGER NOT NULL,
    SubjectName VARCHAR(255) NOT NULL,
    TestDate DATE NOT NULL,
    NumericGrade DECIMAL(5, 2) NOT NULL,
    
    PRIMARY KEY (Id),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
);