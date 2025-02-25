-- Create database
CREATE DATABASE library;
USE library;

-- Drop existing tables if they exist (optional, to prevent conflicts)
DROP TABLE IF EXISTS IssueStatus;
DROP TABLE IF EXISTS ReturnStatus;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Branch;

-- Create Branch table
CREATE TABLE Branch (
    branch_no VARCHAR(10) PRIMARY KEY,
    manager_no VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);

-- Create Employee table
CREATE TABLE Employee (
    empl_id VARCHAR(10) PRIMARY KEY,
    empl_name VARCHAR(30),
    position VARCHAR(25),
    salary DECIMAL(10,2),
    branch_no VARCHAR(10),
    FOREIGN KEY (branch_no) REFERENCES Branch(branch_no)
);

-- Create Customer table (fixed column name)
CREATE TABLE Customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(30),
    customer_address VARCHAR(60),  
    reg_date DATE
);

-- Create Books table
CREATE TABLE Books (
    ISBN VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(100),
    book_genre VARCHAR(50),
    book_price DECIMAL(10,2),
    available VARCHAR(5),
    author VARCHAR(50),
    publisher VARCHAR(50)
);

-- Create IssueStatus table
CREATE TABLE IssueStatus (
    issue_id VARCHAR(10) PRIMARY KEY,
    issued_cust VARCHAR(10),
    issued_book_name VARCHAR(80),
    issue_date DATE,
    ISBN_book VARCHAR(20),
    FOREIGN KEY (issued_cust) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (ISBN_book) REFERENCES Books(ISBN) ON DELETE CASCADE
);

-- Create ReturnStatus table
CREATE TABLE ReturnStatus (
    return_id VARCHAR(10) PRIMARY KEY,
    return_cust VARCHAR(10),
    return_book_name VARCHAR(80),
    return_date DATE,
    ISBN_book2 VARCHAR(20),
    FOREIGN KEY (ISBN_book2) REFERENCES Books(ISBN) ON DELETE CASCADE
);

-- Insert values into Branch table
INSERT INTO Branch (branch_no, manager_no, branch_address, contact_no)  
VALUES 
    ('B001', 'M101', '1 MAIN STREET', '+911234567890'),
    ('B002', 'M102', '12 MAIN STREET', '+911234567890'),
    ('B003', 'M103', '123 MAIN STREET', '+911234567890'),
    ('B004', 'M104', '1234 MAIN STREET', '+911234567890'),
    ('B005', 'M105', '1235 MAIN STREET', '+911234567890');

-- Insert values into Employee table
INSERT INTO Employee (empl_id, empl_name, position, salary, branch_no)
VALUES
    ('E101', 'Ramratan', 'CEO', 100000.50, 'B001'),
    ('E102', 'Nishant', 'AEO', 90000.50, 'B002'),
    ('E103', 'Ramavatar', 'Manager', 80000.50, 'B001'),
    ('E104', 'Ashok', 'System Tester', 70000.50, 'B001'),
    ('E105', 'Yashashree', 'Software Developer', 60000.50, 'B003');

-- Insert values into Customer table (fixed column name)
INSERT INTO Customer (customer_id, customer_name, customer_address, reg_date)
VALUES 
    ('C101', 'Kashish', '123 Jay Nagar', '2003-03-30'),
    ('C102', 'Krish', '123 Shree Nagar', '2025-04-05'),
    ('C103', 'Kamal', '123 Dev Nagar', '2025-01-01'),
    ('C104', 'Rahul', '123 Gokul Nagar', '2025-09-25'),
    ('C105', 'Saham', '123 Ahemd Nagar', '2025-07-05');

-- Insert values into Books table
INSERT INTO Books (ISBN, book_title, book_genre, book_price, available, author, publisher)
VALUES 
    ('978-0-553-29698-2', 'The Catcher in the Rye', 'Classic', 7.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company'),
    ('978-0-7432-4722-4', 'The Da Vinci Code', 'Mystery', 8.00, 'yes', 'Dan Brown', 'Doubleday'),
    ('978-0-009-957807-9', 'A Game of Thrones', 'Fantasy', 7.50, 'yes', 'George R.R. Martin', 'Bantam'),
    ('978-0-375-41398-8', 'The Diary of a Young Girl', 'Biography', 9.00, 'yes', 'Anne Frank', 'Doubleday');

-- Insert values into IssueStatus table
INSERT INTO IssueStatus (issue_id, issued_cust, issued_book_name, issue_date, ISBN_book)
VALUES
    ('IS101', 'C101', 'The Catcher in the Rye', '2023-05-01', '978-0-553-29698-2'),
    ('IS102', 'C102', 'The Da Vinci Code', '2023-05-02', '978-0-7432-4722-4'),
    ('IS103', 'C103', 'A Game of Thrones', '2023-05-03', '978-0-009-957807-9'),
    ('IS104', 'C104', 'The Diary of a Young Girl', '2023-05-04', '978-0-375-41398-8');

-- Insert values into ReturnStatus table
INSERT INTO ReturnStatus (return_id, return_cust, return_book_name, return_date, ISBN_book2)
VALUES
    ('RS101', 'C101', 'The Catcher in the Rye', '2023-06-06', '978-0-553-29698-2'),
    ('RS102', 'C102', 'The Da Vinci Code', '2023-06-07', '978-0-7432-4722-4'),
    ('RS103', 'C104', 'The Diary of a Young Girl', '2023-06-08', '978-0-375-41398-8');

-- Queries

-- 1. Retrieve book title, genre, and price of all available books
SELECT book_title, book_genre, book_price FROM Books WHERE available = 'yes';

-- 2. List employee names and salaries in descending order
SELECT empl_name, salary FROM Employee ORDER BY salary DESC;

-- 3. Retrieve book titles and corresponding customers who have issued them
SELECT IssueStatus.issued_book_name, Customer.customer_name 
FROM IssueStatus
JOIN Customer ON IssueStatus.issued_cust = Customer.customer_id;

-- 4. Display total count of books in each genre
SELECT book_genre, COUNT(book_title) FROM Books GROUP BY book_genre;

-- 5. Retrieve employee names and positions for salaries above 50,000
SELECT empl_name, position FROM Employee WHERE salary > 50000;

-- 6. List customer names who registered before 2022-01-01 and have not issued any books
SELECT customer_name 
FROM Customer 
WHERE reg_date < '2022-01-01' 
AND customer_id NOT IN (SELECT issued_cust FROM IssueStatus);

-- 7. Display branch numbers and total employee count in each branch
SELECT branch_no, COUNT(empl_id) FROM Employee GROUP BY branch_no;

-- 8. Retrieve names of customers who issued books in June 2023
SELECT Customer.customer_name 
FROM Customer 
JOIN IssueStatus ON Customer.customer_id = IssueStatus.issued_cust
WHERE IssueStatus.issue_date BETWEEN '2023-06-01' AND '2023-06-30';

-- 9. Retrieve book titles that contain "History"
SELECT book_title FROM Books WHERE book_genre LIKE '%History%';

-- 10. Retrieve branch numbers with more than 5 employees
SELECT branch_no, COUNT(empl_id) 
FROM Employee 
GROUP BY branch_no 
HAVING COUNT(empl_id) > 5;
