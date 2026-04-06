CREATE DATABASE VlT2;
USE VlT2;

-- 1. Table Category
CREATE TABLE Category
(
    idCategory INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(100) NOT NULL
);

INSERT INTO Category (CategoryName) VALUES
	('Elektroonika'),
	('Kantselei'),
	('Riie'),
	('Sport'),
	('Toiduained');

SELECT * FROM Category;

-- 2. Table Product
CREATE TABLE Product
(
    idProduct INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    idCategory INT NOT NULL,
    Price FLOAT NOT NULL CHECK (Price > 0),
    FOREIGN KEY (idCategory) REFERENCES Category(idCategory)
);

INSERT INTO Product (Name, idCategory, Price) VALUES
('Sülearvuti', 1, 999.99),
('Kõrvaklapid', 1, 49.99),
('Samsungi telefon', 1, 599.99),
('Pastapliiats', 2, 0.99),
('Märkmik 48 lehte', 2, 1.50),
('Klammerdaja', 2, 5.99),
('Talvejakk', 3, 89.99),
('tossud', 4, 79.99),
('hantlid', 4, 25.99),
('sokolaad', 5, 2.49);

SELECT * FROM Product;

-- 3. Table Customer
CREATE TABLE Customer
(
	idCustomer INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(100) NOT NULL,
    contact VARCHAR(100) UNIQUE
);

INSERT INTO Customer (Name, contact) VALUES
('Vlas Taratõnov', '+37251234567'),
('Mati Tamm', '+37259876543'),
('Peeter Magi', '+37254321678'),
('Toomas Kask', '+37256789012'),
('Mati Puu', '+37253456789');

SELECT * FROM Customer;

-- 4. Table Sale
CREATE TABLE Sale
(
    idSale INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idProduct INT NOT NULL,
    idCustomer INT NOT NULL,
    Count_pr INT NOT NULL DEFAULT 1,
    Date_of_sale DATE NOT NULL,
    FOREIGN KEY (idProduct) REFERENCES Product(idProduct),
    FOREIGN KEY (idCustomer) REFERENCES Customer(idCustomer)
);

INSERT INTO Sale (idProduct, idCustomer, Count_pr, Date_of_sale) VALUES
(1, 1, 1, '2024-01-15'),
(2, 2, 2, '2024-01-16'),
(4, 3, 10, '2024-01-17'),
(7, 4, 1, '2024-01-18'),
(8, 5, 1, '2024-01-19'),
(9, 1, 2, '2024-01-20'),
(3, 2, 1, '2024-02-01'),
(5, 3, 5, '2024-02-03'),
(6, 4, 3, '2024-02-05'),
(10, 5, 4, '2024-02-07');

SELECT * FROM Sale;


-- Muutke Name tüüp VARCHAR(100) tüübilt VARCHAR(50) tüübile
ALTER TABLE Customer
ALTER COLUMN Name VARCHAR(50);

-- Lisame tabelisse Sale välja Units.
ALTER TABLE Sale
ADD Units VARCHAR(50) DEFAULT 'tk';

SELECT * FROM Sale;

-- Leiame piirangu nime
SELECT name FROM sys.objects 
WHERE type = 'UQ' AND parent_object_id = OBJECT_ID('Customer');

ALTER TABLE Customer
DROP CONSTRAINT UQ__Customer__870C3C8B8B75B820;