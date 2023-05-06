
-- Table Creation


-- Customers Table Creation

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_email VARCHAR(255)
);


-- Orders Table Creation

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


-- Order_Items Table Creation

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(255),
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


-- Data Insertion

-- Customers Data

INSERT INTO Customers (customer_id, customer_name, customer_email)
VALUES (1, 'John Smith', 'john.smith@example.com');

INSERT INTO Customers (customer_id, customer_name, customer_email)
VALUES (2, 'Jane Doe', 'jane.doe@example.com');

INSERT INTO Customers (customer_id, customer_name, customer_email)
VALUES (3, 'Bob Johnson', 'bob.johnson@example.com');

INSERT INTO Customers (customer_id, customer_name, customer_email)
VALUES (4, 'Alice Williams', 'alice.williams@example.com');


-- Orders Data

INSERT INTO Orders (order_id, order_date, customer_id)
VALUES (1001, '2023-03-28', 1);

INSERT INTO Orders (order_id, order_date, customer_id)
VALUES (1002, '2023-03-29', 2);

INSERT INTO Orders (order_id, order_date, customer_id)
VALUES (1003, '2023-03-30', 1);

INSERT INTO Orders (order_id, order_date, customer_id)
VALUES (1004, '2023-03-31', 3);


--Order_Items data

INSERT INTO Order_Items (order_item_id, order_id, product_name, quantity, price)
VALUES (1, 1001, 'iPhone', 2, 999.99);

INSERT INTO Order_Items (order_item_id, order_id, product_name, quantity, price)
VALUES (2, 1001, 'Google Pixel', 1, 699.99);

INSERT INTO Order_Items (order_item_id, order_id, product_name, quantity, price)
VALUES (3, 1002, 'Samsung Galaxy', 1, 799.99);

INSERT INTO Order_Items (order_item_id, order_id, product_name, quantity, price)
VALUES (4, 1003, 'OnePlus', 3, 899.99);


-- Queries:

-- Second Most Expensive Product

SELECT product_name, price
FROM Order_Items
WHERE price = (
    SELECT DISTINCT price
    FROM Order_Items
    ORDER BY price DESC
    LIMIT 1 OFFSET 1
);

-- Customer who buys the lowest cost product and uses example email service

SELECT c.customer_id, c.customer_name, c.customer_email
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
WHERE oi.price = (
    SELECT MIN(price)
    FROM Order_Items
) AND c.customer_email LIKE '%example.com';

-- Total number of orders list in the Orders table where the order date is on or after January 1, 2023.

SELECT COUNT(*)
FROM Orders
WHERE order_date >= '2023-01-01';

-- List of the product name, quantity, and price for all items in the Order_items table, ordered by the quantity in descending order.

SELECT product_name, quantity, price
FROM Order_Items
ORDER BY quantity DESC;

-- Total revenue generated from all orders in the Order_Items table 

SELECT SUM(quantity * price) as total_revenue
FROM Order_Items;

-- Order ID and total price lists for all orders in the Order_items table.

SELECT order_id, SUM(quantity * price) as total_price
FROM Order_Items
GROUP BY order_id;


-- Name and email address Lists of the customer who placed the order with the highest total price in the Order_items table.

SELECT c.customer_name, c.customer_email
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id = (
    SELECT order_id
    FROM (
        SELECT order_id, SUM(quantity * price) as total_price
        FROM Order_Items
        GROUP BY order_id
    ) AS order_totals
    ORDER BY total_price DESC
    LIMIT 1
);
