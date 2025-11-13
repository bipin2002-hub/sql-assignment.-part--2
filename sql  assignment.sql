# Prectical  Implimantation of Question no. 6 to 10 ,

#Question :6 Create a database named ECommerceDB and perform the following tasks:alter:

#Answer:-  
create  database ECommerceDB;
use ECommerceDB;

# Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
select *from  Categories;

# Product Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID));
    select * from  Products;
    
    # Customers Table
    CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);
select * from  Customers;

# Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
select * from  orders;

 # 2. Insert the records into each table:
 #1
 INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');

#2 
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel : The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

#3
INSERT INTO Customers (CustomerID, CustomerName, Email, JoinDate) VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');
select * from  customers;
#4
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1001, 3, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 4, '2023-09-24', 120.00),
(1006, 2, '2023-06-19', 20.00);

#Question 7 : Generate a report showing CustomerName, Email, and the TotalNumberofOrders for each customer. Include customers who have not placed any orders, in which case their TotalNumberofOrders should be 0. Order the results by CustomerName. 

# Answer:-
SELECT 
    c.CustomerName,
    c.Email,
    COUNT(o.OrderID) AS TotalNumberofOrders
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerName, c.Email
ORDER BY 
    c.CustomerName;

    
# Question 8 :  Retrieve Product Information with Category: Write a SQL query to display the ProductName, Price, StockQuantity, and CategoryName for all products. Order the results by CategoryName and then ProductName alphabetically. 

#Answer:-
SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    c.CategoryName
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
ORDER BY 
    c.CategoryName,
    p.ProductName;

    
#Question 9 : Write a SQL query that uses a Common Table Expression (CTE) and a Window Function (specifically ROW_NUMBER() or RANK()) to display the CategoryName, ProductName, and Price for the top 2 most expensive products in each CategoryName. 

#Answer:-
WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        p.Price,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.Price DESC) AS rn
    FROM 
        Products p
    JOIN 
        Categories c ON p.CategoryID = c.CategoryID
)
SELECT 
    CategoryName,
    ProductName,
    Price
FROM 
    RankedProducts
WHERE 
    rn <= 2
ORDER BY 
    CategoryName,
    rn;
    
    
#Question 10 : You are hired as a data analyst by Sakila Video Rentals, a global movie rental company. The management team is looking to improve decision-making by analyzing existing customer, rental, and inventory data. Using the Sakila database, answer the following business questions to support key strategic initiatives. Tasks & Questions: 

#Answer:-
#1. Identify the top 5 customers based on the total amount they’ve spent. Include customer name, email, and total amount spent. 

use sakila;
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    c.email,
    SUM(p.amount) AS TotalAmountSpent
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, CustomerName, c.email
ORDER BY 
    TotalAmountSpent DESC
LIMIT 5;

#2. Which 3 movie categories have the highest rental counts? Display the category name and number of times movies from that category were rented.

SELECT 
    cat.name AS CategoryName,
    COUNT(r.rental_id) AS RentalCount
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film_category fc ON i.film_id = fc.film_id
JOIN 
    category cat ON fc.category_id = cat.category_id
GROUP BY 
    cat.category_id, CategoryName
ORDER BY 
    RentalCount DESC
LIMIT 3;
 
#3. Calculate how many films are available at each store and how many of those have never been rented. 

SELECT 
    s.store_id,
    COUNT(i.inventory_id) AS TotalFilms,
    SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS NeverRentedFilms
FROM 
    store s
JOIN 
    inventory i ON s.store_id = i.store_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    s.store_id;

#4. Show the total revenue per month for the year 2023 to analyze business seasonality. 

SELECT 
    DATE_FORMAT(p.payment_date, '%Y-%m') AS YearMonth,
    SUM(p.amount) AS TotalRevenue
FROM 
    payment p
WHERE 
    p.payment_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    YearMonth
ORDER BY 
    YearMonth;

#5. Identify customers who have rented more than 10 times in the last 6 months.

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    COUNT(r.rental_id) AS RentalCount
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
WHERE 
    r.rental_date >= CURDATE() - INTERVAL 6 MONTH
GROUP BY 
    c.customer_id, CustomerName
HAVING 
    RentalCount > 10;
