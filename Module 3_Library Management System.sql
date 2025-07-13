-- 1. Create the database and use it
CREATE DATABASE IF NOT EXISTS library;
USE library;

-- 2. Create tables

CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(255),
    Contact_no VARCHAR(20)
);

CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);

CREATE TABLE Books (
    ISBN VARCHAR(20) PRIMARY KEY,
    Book_title VARCHAR(255),
    Category VARCHAR(100),
    Rental_Price DECIMAL(10,2),
    Status ENUM('yes', 'no'),  -- yes = available, no = not available
    Author VARCHAR(100),
    Publisher VARCHAR(100)
);

CREATE TABLE Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    Customer_address VARCHAR(255),
    Reg_date DATE
);

CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust INT,
    Issued_book_name VARCHAR(255),
    Issue_date DATE,
    Isbn_book VARCHAR(20),
    FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);

CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(255),
    Return_date DATE,
    Isbn_book2 VARCHAR(20),
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);

-- 3. Inserting sample data

INSERT INTO Branch (Branch_no, Manager_Id, Branch_address, Contact_no) VALUES
(1, 101, '123 Main St', '123-456-7890'),
(2, 102, '456 Elm St', '987-654-3210');

INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no) VALUES
(101, 'Alice Johnson', 'Manager', 70000, 1),
(102, 'Bob Smith', 'Manager', 65000, 2),
(103, 'Charlie Brown', 'Assistant', 40000, 1),
(104, 'Diana Prince', 'Librarian', 48000, 2),
(105, 'Evan Lee', 'Clerk', 35000, 1),
(106, 'Fiona Green', 'Assistant', 37000, 2);

INSERT INTO Books (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher) VALUES
('ISBN001', 'History of Ancient Rome', 'History', 30, 'yes', 'John Doe', 'ABC Publishing'),
('ISBN002', 'Introduction to Physics', 'Science', 25, 'yes', 'Jane Roe', 'XYZ Publishing'),
('ISBN003', 'Modern Art Explained', 'Art', 20, 'no', 'Anne Smith', 'Creative Press'),
('ISBN004', 'World History', 'History', 28, 'yes', 'Mary Major', 'History House'),
('ISBN005', 'Basics of Chemistry', 'Science', 22, 'yes', 'James Dean', 'Science Pub'),
('ISBN006', 'English Literature', 'Literature', 18, 'yes', 'Emily Bronte', 'Classic Books');

INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date) VALUES
(201, 'John Miller', '789 Oak St', '2021-05-20'),
(202, 'Sara Connor', '321 Pine St', '2022-06-15'),
(203, 'Tim Cook', '654 Maple St', '2020-12-10'),
(204, 'Linda Scott', '987 Cedar St', '2023-01-05'),
(205, 'Paul Adams', '111 Birch St', '2019-11-25');

INSERT INTO IssueStatus (Issue_Id, Issued_cust, Issued_book_name, Issue_date, Isbn_book) VALUES
(301, 201, 'History of Ancient Rome', '2023-06-05', 'ISBN001'),
(302, 202, 'Introduction to Physics', '2023-06-15', 'ISBN002'),
(303, 203, 'English Literature', '2022-11-20', 'ISBN006'),
(304, 205, 'World History', '2021-04-10', 'ISBN004');

INSERT INTO ReturnStatus (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2) VALUES
(401, 201, 'History of Ancient Rome', '2023-06-20', 'ISBN001'),
(402, 203, 'English Literature', '2023-01-15', 'ISBN006');

-- 4. Queries

-- 1. Retrieve the book title, category, and rental price of all available books.
SELECT Book_title, Category, Rental_Price
FROM Books
WHERE Status = 'yes';

-- 2. List the employee names and their respective salaries in descending order of salary.
SELECT Emp_name, Salary
FROM Employee
ORDER BY Salary DESC;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books.
SELECT b.Book_title, c.Customer_name
FROM IssueStatus i
JOIN Books b ON i.Isbn_book = b.ISBN
JOIN Customer c ON i.Issued_cust = c.Customer_Id;

-- 4. Display the total count of books in each category.
SELECT Category, COUNT(*) AS Total_Books
FROM Books
GROUP BY Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
SELECT Emp_name, Position
FROM Employee
WHERE Salary > 50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT Customer_name
FROM Customer c
WHERE Reg_date < '2022-01-01'
AND NOT EXISTS (
    SELECT 1 FROM IssueStatus i WHERE i.Issued_cust = c.Customer_Id
);

-- 7. Display the branch numbers and the total count of employees in each branch.
SELECT Branch_no, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
SELECT DISTINCT c.Customer_name
FROM IssueStatus i
JOIN Customer c ON i.Issued_cust = c.Customer_Id
WHERE i.Issue_date BETWEEN '2023-06-01' AND '2023-06-30';

-- 9. Retrieve book_title from book table containing 'history' (case-insensitive).
SELECT Book_title
FROM Books
WHERE LOWER(Book_title) LIKE '%history%';

-- 10. Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
SELECT Branch_no, COUNT(*) AS Employee_Count
FROM Employee
GROUP BY Branch_no
HAVING COUNT(*) > 5;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses.
SELECT e.Emp_name, b.Branch_address
FROM Branch b
JOIN Employee e ON b.Manager_Id = e.Emp_Id;

-- 12. Display the names of customers who have issued books with a rental price higher than Rs. 25.
SELECT DISTINCT c.Customer_name
FROM IssueStatus i
JOIN Customer c ON i.Issued_cust = c.Customer_Id
JOIN Books b ON i.Isbn_book = b.ISBN
WHERE b.Rental_Price > 25;
