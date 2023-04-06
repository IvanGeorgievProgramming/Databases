DROP DATABASE IF EXISTS school;
CREATE DATABASE school CHARSET 'utf8';
USE school;

CREATE TABLE Students(
	Id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(150) NOT NULL,
	Num INTEGER NOT NULL,
	ClassNum INTEGER NOT NULL,
	ClassLetter CHAR(1) NOT NULL,
	Birthday DATE,
	EGN CHAR(10),
	EntranceExamResult NUMERIC(3,2)
);

CREATE TABLE Subjects(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Name VARCHAR(100),
	
	PRIMARY KEY(Id)
);

CREATE TABLE StudentMarks(
	StudentId INTEGER NOT NULL,
	SubjectId INTEGER NOT NULL,
	ExamDate DATETIME NOT NULL,
	Mark NUMERIC(3,2) NOT NULL,
	
	PRIMARY KEY( StudentId, SubjectId, ExamDate ),
	FOREIGN KEY (StudentId) REFERENCES Students(Id),
	FOREIGN KEY (SubjectId) REFERENCES Subjects(Id)
);

CREATE TABLE MarkWords(
	RangeStart NUMERIC(3,2) NOT NULL,
	RangeEnd NUMERIC(3,2) NOT NULL,
	MarkAsWord VARCHAR(15),
	
	PRIMARY KEY(RangeStart, RangeEnd)
);

CREATE TABLE Teachers(
	Id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(150) NOT NULL
);

INSERT INTO Students(Id, Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 101, 'Ivan Georgiev', 10, 11, 'а', '1999-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Alexander Ivanov', 15, 10, 'б', '2000-02-29', '0042294120' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Alexandra Stoicheva', 20, 10, 'б', '2000-05-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Desislava Stefanova', 20, 10, 'а', '1999-12-25', '9912256301' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Matei Zahariev', 1, 8, 'а', '2002-06-11', NULL );

INSERT INTO Subjects(Id, Name) VALUES( 11, 'English' );
INSERT INTO Subjects(Name) VALUES( 'Literature' );
INSERT INTO Subjects(Name) VALUES( 'Math' );
INSERT INTO Subjects(Name) VALUES( 'Databases' );

INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-03', 6 );
INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-31', 5.50 );
INSERT INTO StudentMarks VALUES( 102, 11, '2017-04-28', 5 );
INSERT INTO StudentMarks VALUES( 103, 12, '2017-04-28', 4 );
INSERT INTO StudentMarks VALUES( 104, 13, '2017-03-03', 5 );
INSERT INTO StudentMarks VALUES( 104, 13, '2017-04-07', 6 );
INSERT INTO StudentMarks VALUES( 104, 11, '2017-04-07', 4.50 );

INSERT INTO MarkWords VALUES( 2, 2.50, '2' );
INSERT INTO MarkWords VALUES( 2.50, 3.50, '3' );
INSERT INTO MarkWords VALUES( 3.50, 4.50, '4' );
INSERT INTO MarkWords VALUES( 4.50, 5.50, '5' );
INSERT INTO MarkWords VALUES( 5.50, 6, '6' );

INSERT INTO Teachers(Name) VALUES( 'Alexander Petrov');
INSERT INTO Teachers(Name) VALUES( 'Krasimir Trenchev');
INSERT INTO Teachers(Name) VALUES( 'Magdalina Uzunova');
