USE School;

DROP TABLE IF EXISTS MarksAsWord;

CREATE TABLE MarksAsWord (
  grade_from DECIMAL(2,1),
  grade_to DECIMAL(2,1),
  grade_in_words VARCHAR(255)
);

INSERT INTO MarksAsWord (grade_from, grade_to, grade_in_words)
VALUES 
    (2.00, 2.99, 'Weak'),
    (3.00, 3.99, 'Medium'),
    (4.00, 4.99, 'Good'),
    (5.00, 5.99, 'Very good'),
    (6.00, 6.00, 'Excellent');