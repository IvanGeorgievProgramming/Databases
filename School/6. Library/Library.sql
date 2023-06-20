-- Create the database
CREATE DATABASE library;

-- Use the library database
USE library;

-- Create the books table
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    year_published INT NOT NULL,
    isbn VARCHAR(13) NOT NULL
);

-- Create the authors table
CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

-- Create the book_authors table to establish the many-to-many relationship
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

-- Insert sample data into books table
INSERT INTO books (title, year_published, isbn)
VALUES
    ('Book 1', 2021, 'ISBN1'),
    ('Book 2', 2022, 'ISBN2'),
    ('Book 3', 2022, 'ISBN3'),
    ('Book 4', 2023, 'ISBN4'),
    ('Book 5', 2023, 'ISBN5');

-- Insert sample data into authors table
INSERT INTO authors (name)
VALUES
    ('Author 1'),
    ('Author 2'),
    ('Author 3'),
    ('Author 4');

-- Establish relationships in the book_authors table
INSERT INTO book_authors (book_id, author_id)
VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 1),
    (5, 2);

-- Query 1: The titles of all books published in a particular year.
SELECT title FROM books WHERE year_published = 2022;

-- Query 2: The title, year of publication, and ISBN number of all books by a particular author identified by his or her name.
SELECT b.title, b.year_published, b.isbn
FROM books b
JOIN book_authors ba ON b.id = ba.book_id
JOIN authors a ON ba.author_id = a.id
WHERE a.name = 'Author 1';

-- Query 3: The names of all authors of a particular book identified by its ISBN number.
SELECT a.name
FROM authors a
JOIN book_authors ba ON a.id = ba.author_id
JOIN books b ON ba.book_id = b.id
WHERE b.isbn = 'ISBN2';

-- Query 4: The number of books by each author and the author's name, listed in descending order by number of books. Include authors who have no published books.
SELECT a.name, COUNT(ba.book_id) AS num_books
FROM authors a
LEFT JOIN book_authors ba ON a.id = ba.author_id
GROUP BY a.id
ORDER BY num_books DESC;

-- Query 5: The titles of all books from a particular year and the number of authors, including only books that have at least two authors. Arrange the results in alphabetical order of book titles.
SELECT b.title, COUNT(ba.author_id) AS num_authors
FROM books b
JOIN book_authors ba ON b.id = ba.book_id
GROUP BY b.id
HAVING num_authors >= 2
ORDER BY b.title ASC;
