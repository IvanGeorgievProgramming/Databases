USE TasksDatabase;

CREATE TABLE Notes (
    Id INTEGER NOT NULL AUTO_INCREMENT,
    Note VARCHAR(255) NOT NULL,
    DueDate DATE,
    ClosedOn DATE,
    
    PRIMARY KEY (Id)
);