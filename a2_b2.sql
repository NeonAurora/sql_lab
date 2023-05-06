-- Table Creation 

-- Customers Table

CREATE TABLE Customers (
  ID INT PRIMARY KEY NOT NULL,
  Name VARCHAR(50) NOT NULL,
  Contact VARCHAR(50) NOT NULL
);

-- Goods Table 

CREATE TABLE Goods (
  Goods_ID INT PRIMARY KEY NOT NULL,
  Goods_Name VARCHAR(50) NOT NULL,
  Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0)
);

-- Orders Table

CREATE TABLE Orders (
  Order_Date DATE NOT NULL,
  Customer_ID INT NOT NULL,
  Goods_ID INT NOT NULL,
  PRIMARY KEY (Customer_ID, Goods_ID),
  FOREIGN KEY (Customer_ID) REFERENCES Customers(ID) ON DELETE CASCADE,
  FOREIGN KEY (Goods_ID) REFERENCES Goods(Goods_ID) ON DELETE CASCADE
);


-- extras

ALTER TABLE Customers
ADD Address VARCHAR(50) NOT NULL;


-- Data Insertion

-- Insert data into the Customers table
INSERT INTO Customers (ID, Name, Contact, Address)
VALUES (1, 'John Doe', '555-1234', '123 Main St');

INSERT INTO Customers (ID, Name, Contact, Address)
VALUES (2, 'Jane Smith', '555-5678', '456 Oak Ave');

INSERT INTO Customers (ID, Name, Contact, Address)
VALUES (3, 'Bob Johnson', '555-9012', '789 Elm St');

INSERT INTO Customers (ID, Name, Contact, Address)
VALUES (4, 'Alice Brown', '555-3456', '321 Pine St');


-- Insert data into the Goods table

INSERT INTO Goods (Goods_ID, Goods_Name, Price)
VALUES (1, 'Widget', 10.99);

INSERT INTO Goods (Goods_ID, Goods_Name, Price)
VALUES (2, 'Gadget', 19.99);

INSERT INTO Goods (Goods_ID, Goods_Name, Price)
VALUES (3, 'Thingamajig', 8.99);

INSERT INTO Goods (Goods_ID, Goods_Name, Price)
VALUES (4, 'Doohickey', 14.99);


-- Insert data into the Orders table

INSERT INTO Orders (Order_Date, Customer_ID, Goods_ID)
VALUES ('2023-03-19', 1, 1);

INSERT INTO Orders (Order_Date, Customer_ID, Goods_ID)
VALUES ('2023-03-20', 1, 2);

INSERT INTO Orders (Order_Date, Customer_ID, Goods_ID)
VALUES ('2023-03-21', 2, 3);

INSERT INTO Orders (Order_Date, Customer_ID, Goods_ID)
VALUES ('2023-03-22', 3, 4);


-- Queries

-- To retrieve the names of all goods that have the letter "i" in their name and the customer's name contains the letter "j".

SELECT Goods.Goods_Name, Customers.Name 
FROM Goods 
JOIN Orders ON Goods.Goods_ID = Orders.Goods_ID 
JOIN Customers ON Orders.Customer_ID = Customers.ID 
WHERE Goods.Goods_Name LIKE '%i%' AND Customers.Name LIKE '%j%';

-- Total number of customers that has the ID 102 and as well their details

SELECT COUNT(*) AS Total_Customers, *
FROM Customers
WHERE ID = 102;

-- Name and contact information of all customers who have purchased the goods with the lowest price in the Goods table.

SELECT Customers.Name, Customers.Contact
FROM Customers
JOIN Orders ON Customers.ID = Orders.Customer_ID
JOIN (
  SELECT MIN(Price) AS Min_Price
  FROM Goods
) AS Lowest_Price ON Orders.Goods_ID = (
  SELECT Goods_ID
  FROM Goods
  WHERE Price = Lowest_Price.Min_Price
);

-- Customers who have not placed any orders yet.

SELECT Customers.Name, Customers.Contact
FROM Customers
LEFT JOIN Orders ON Customers.ID = Orders.Customer_ID
WHERE Orders.Customer_ID IS NULL;

-- Name of the customer who placed the most expensive order.

SELECT Customers.Name
FROM Customers
JOIN Orders ON Customers.ID = Orders.Customer_ID
JOIN Goods ON Orders.Goods_ID = Goods.Goods_ID
WHERE Goods.Price = (
  SELECT MAX(Price)
  FROM Goods
);


-- List of all customers who have made more than 2 orders.

SELECT Customers.Name, COUNT(*) AS Num_Orders
FROM Customers
JOIN Orders ON Customers.ID = Orders.Customer_ID
GROUP BY Customers.ID
HAVING COUNT(*) > 2;

-- Drop tables

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Goods;
DROP TABLE IF EXISTS Customers;

