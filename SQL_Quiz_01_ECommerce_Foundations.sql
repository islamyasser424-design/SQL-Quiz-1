-- =============================================================================
-- SQL QUIZ 01: E-COMMERCE DATABASE FOUNDATIONS & PATTERN ANALYSIS
-- Database Architecture, Data Ingestion, Pattern Matching & Aggregate Metrics
-- Author: Islam Yasser (Data Analyst & BI Specialist)
-- Target RDBMS: MySQL 8.0+
-- Database: online_store
-- =============================================================================

-- Step 1: Initialize Database Environment
DROP DATABASE IF EXISTS online_store;
CREATE DATABASE online_store
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE online_store;

-- =============================================================================
-- Step 2: DDL Schema Definitions
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Table 1: customers
-- -----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    joined_at DATE
);

-- -----------------------------------------------------------------------------
-- Table 2: catgories
-- -----------------------------------------------------------------------------
CREATE TABLE catgories (
    catgory_id INT PRIMARY KEY AUTO_INCREMENT,
    catgory_name VARCHAR(80) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table 3: products
-- -----------------------------------------------------------------------------
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(120) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    catgory_id INT,
    CONSTRAINT fk_products_category FOREIGN KEY (catgory_id) 
        REFERENCES catgories(catgory_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- Table 4: orders
-- -----------------------------------------------------------------------------
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE,
    status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- Schema Evolution (ALTER TABLE)
-- Adding unique customer email contact for account verification
-- -----------------------------------------------------------------------------
ALTER TABLE customers 
    ADD email VARCHAR(150) UNIQUE NOT NULL AFTER full_name;

-- =============================================================================
-- Step 3: DML Seed Data Population
-- =============================================================================

INSERT INTO catgories (catgory_name) VALUES
    ('Electronics'), 
    ('Clothing'), 
    ('Books'), 
    ('Home & Garden');

INSERT INTO customers (full_name, email, city, joined_at) VALUES
    ('Ahmed Ali',   'ahmed@mail.com',  'Cairo',       '2023-01-15'),
    ('Sara Hassan', 'sara@mail.com',   'Alexandria',  '2023-03-20'),
    ('Mona Khalil', 'mona@mail.com',   'Giza',        '2023-06-05'),
    ('Omar Saad',   'omar@mail.com',   'Cairo',       '2024-01-10'),
    ('Nour Fathy',  'nour@mail.com',   'Luxor',       '2024-02-28');

INSERT INTO products (product_name, price, stock, catgory_id) VALUES
    ('Laptop Pro',      15000.00, 10, 1),
    ('Wireless Mouse',  350.00,   50, 1),
    ('T-Shirt XL',      200.00,   100, 2),
    ('Jeans Classic',   650.00,   40, 2),
    ('MySQL Mastery',   180.00,   25, 3),
    ('Garden Hose',     120.00,   30, 4);

INSERT INTO orders (customer_id, product_id, quantity, order_date, status) VALUES
    (1, 1, 1, '2024-03-01', 'delivered'),
    (1, 2, 2, '2024-03-05', 'shipped'),
    (2, 3, 3, '2024-03-10', 'delivered'),
    (3, 5, 1, '2024-04-01', 'pending'),
    (4, 1, 2, '2024-04-15', 'delivered'),
    (2, 6, 1, '2024-05-01', 'shipped'),
    (5, 4, 2, '2024-05-10', 'pending'),
    (1, 5, 1, '2024-06-01', 'delivered');

-- =============================================================================
-- Step 4: Assessment Queries & Analytical Solutions
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q1: Display all customers whose second letter in their name is 'A' (or 'a').
-- Technique: Single character wildcard '_' combined with multi-character '%'
-- -----------------------------------------------------------------------------
SELECT 
    customer_id,
    full_name,
    email,
    city
FROM customers
WHERE full_name LIKE '_a%' OR full_name LIKE '_A%';

-- -----------------------------------------------------------------------------
-- Q2: Display all products with a unit price strictly greater than 500 EGP.
-- Technique: Numeric inequality comparison with price sorting
-- -----------------------------------------------------------------------------
SELECT 
    product_id,
    product_name,
    price,
    stock
FROM products
WHERE price > 500.00
ORDER BY price DESC;

-- -----------------------------------------------------------------------------
-- Q3: Display the total number of distinct orders, maximum quantity,
--     and minimum quantity ordered across the system.
-- Technique: Aggregate functions (COUNT DISTINCT, MIN, MAX)
-- -----------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    MIN(quantity) AS min_quantity_ordered,
    MAX(quantity) AS max_quantity_ordered
FROM orders;
