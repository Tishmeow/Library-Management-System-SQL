USE LibraryManagementSystem;

SELECT *
FROM Book;
-- Displaying books with authors
SELECT
    B.Book_ID,
    B.Title,
    A.Author_Name,
    B.Publish_Year,
    B.Copies
FROM Book B
JOIN Author A
    ON B.Author_ID = A.Author_ID;
    -- Display books with category and publisher
SELECT
B.Title,
A.Author_Name,
P.Publisher_Name,
C.Category_Name
FROM Book B
JOIN Author A
    ON B.Author_ID = A.Author_ID
JOIN Publisher P
    ON B.Publisher_ID = P.Publisher_ID
JOIN Category C
    ON B.Category_ID = C.Category_ID;
    -- Display borrowing information
SELECT
L.Loan_ID,
M.Member_Name,
B.Title,
L.Borrow_Date,
L.Due_Date,
L.Return_Date
FROM Loan L
JOIN Member M
    ON L.Member_ID = M.Member_ID
JOIN Book B
    ON L.Book_ID = B.Book_ID;
   -- Find currently borrowed books
SELECT
M.Member_Name,
B.Title,
L.Borrow_Date,
L.Due_Date
FROM Loan L
JOIN Member M
    ON L.Member_ID = M.Member_ID
JOIN Book B
    ON L.Book_ID = B.Book_ID
WHERE L.Return_Date IS NULL;
-- Find overdue books
SELECT
    M.Member_Name,
    B.Title,
    L.Due_Date
FROM Loan L
JOIN Member M
    ON L.Member_ID = M.Member_ID
JOIN Book B
    ON L.Book_ID = B.Book_ID
WHERE L.Return_Date IS NULL
AND L.Due_Date < '2026-08-14';
-- Count books by category
SELECT
    C.Category_Name,
    COUNT(B.Book_ID) AS Number_of_Books
FROM Category C
LEFT JOIN Book B
    ON C.Category_ID = B.Category_ID
GROUP BY C.Category_ID, C.Category_Name;
-- Count borrowing transactions for each book
SELECT
    B.Title,
    COUNT(L.Loan_ID) AS Times_Borrowed
FROM Book B
LEFT JOIN Loan L
    ON B.Book_ID = L.Book_ID
GROUP BY B.Book_ID, B.Title
ORDER BY Times_Borrowed DESC;
-- Members who borrowed more than one book
SELECT
    M.Member_ID,
    M.Member_Name,
    COUNT(L.Loan_ID) AS Number_of_Books
FROM Member M
JOIN Loan L
    ON M.Member_ID = L.Member_ID
GROUP BY M.Member_ID, M.Member_Name
HAVING COUNT(L.Loan_ID) > 1;
-- Books published after 2000
SELECT
    Book_ID,
    Title,
    Publish_Year
FROM Book
WHERE Publish_Year > 2000;
-- Find books with more than 4 copies
-- Complete library report
SELECT
    Title,
    Copies
FROM Book
WHERE Copies > 4;
-- Complete library report
SELECT
    B.Book_ID,
    B.Title,
    A.Author_Name,
    P.Publisher_Name,
    C.Category_Name,
    B.Publish_Year,
    B.Copies
FROM Book B
JOIN Author A
    ON B.Author_ID = A.Author_ID
JOIN Publisher P
    ON B.Publisher_ID = P.Publisher_ID
JOIN Category C
    ON B.Category_ID = C.Category_ID
ORDER BY B.Title;
-- A subquery for  project
SELECT
    Title,
    Copies
FROM Book
WHERE Copies > (
    SELECT AVG(Copies)
    FROM Book
);
-- Update and Delete examples
UPDATE Book
SET Copies = Copies + 1
WHERE Book_ID = 101;
SELECT *
FROM Book
WHERE Book_ID = 101;
SELECT *
FROM Member
WHERE Member_ID NOT IN (
    SELECT Member_ID
    FROM Loan
);
-- Add the Librarian table
CREATE TABLE Librarian (
    Librarian_ID INT PRIMARY KEY,
    Librarian_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);
INSERT INTO Librarian
(Librarian_ID, Librarian_Name, Email, Phone)
VALUES
(1, 'Karim Hasan', 'karim@library.com', '01811111111'),
(2, 'Mim Akter', 'mim@library.com', '01822222222'),
(3, 'Sakib Rahman', 'sakib@library.com', '01833333333');
--  Modify the Loan table
DROP TABLE IF EXISTS Loan;

CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY,
    Member_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    Librarian_ID INT NOT NULL,
    Borrow_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Return_Date DATE,

    FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID),

    FOREIGN KEY (Book_ID)
        REFERENCES Book(Book_ID),

    FOREIGN KEY (Librarian_ID)
        REFERENCES Librarian(Librarian_ID),

    CHECK (Due_Date >= Borrow_Date)
);
SHOW TABLES;
-- Updated Loan sample data
INSERT INTO Loan
(Loan_ID, Member_ID, Book_ID, Librarian_ID,
 Borrow_Date, Due_Date, Return_Date)
VALUES
(1001, 1, 101, 1, '2026-07-01', '2026-07-15', '2026-07-12'),
(1002, 2, 103, 2, '2026-07-05', '2026-07-19', '2026-07-18'),
(1003, 3, 104, 1, '2026-07-10', '2026-07-24', NULL),
(1004, 1, 102, 3, '2026-07-15', '2026-07-29', '2026-07-28'),
(1005, 4, 101, 2, '2026-07-20', '2026-08-03', NULL),
(1006, 5, 105, 1, '2026-07-25', '2026-08-08', '2026-08-05'),
(1007, 2, 104, 3, '2026-08-01', '2026-08-15', NULL),
(1008, 3, 103, 2, '2026-08-02', '2026-08-16', NULL);
-- New query: Show which librarian processed each loan
SELECT
    L.Loan_ID,
    M.Member_Name,
    B.Title,
    Lib.Librarian_Name,
    L.Borrow_Date,
    L.Due_Date,
    L.Return_Date
FROM Loan L
JOIN Member M
    ON L.Member_ID = M.Member_ID
JOIN Book B
    ON L.Book_ID = B.Book_ID
JOIN Librarian Lib
    ON L.Librarian_ID = Lib.Librarian_ID;
    -- Count loans handled by each librarian
    SELECT
    Lib.Librarian_Name,
    COUNT(L.Loan_ID) AS Total_Loans
FROM Librarian Lib
LEFT JOIN Loan L
    ON Lib.Librarian_ID = L.Librarian_ID
GROUP BY Lib.Librarian_ID, Lib.Librarian_Name;
-- Most Borrowed Books
USE LibraryManagementSystem;
SELECT
    B.Title,
    COUNT(L.Loan_ID) AS Times_Borrowed
FROM Book B
LEFT JOIN Loan L
    ON B.Book_ID = L.Book_ID
GROUP BY B.Book_ID, B.Title
ORDER BY Times_Borrowed DESC;