SELECT * FROM notes WHERE DueDate < CURDATE() AND ClosedOn IS NULL;