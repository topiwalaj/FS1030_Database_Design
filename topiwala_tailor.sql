-- Scripts for creating and populating the database:

-- creating my project topiwala_tailor database and using it
CREATE DATABASE topiwala_tailor;
USE topiwala_tailor;

-- creating tables

-- creating table for customers
CREATE TABLE customers (
	customer_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	postal_code VARCHAR(10) NOT NULL,
	city VARCHAR(50) NOT NULL,
	province VARCHAR(50) NOT NULL,
	country VARCHAR(60) NOT NULL,
	phone_no VARCHAR(16) NOT NULL,
	email_address VARCHAR(255) NOT NULL,
	gender VARCHAR(50) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (customer_id)
);

-- alter table to put not null for created_at and updated_at and on update
ALTER TABLE customers
MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE customers
MODIFY updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SHOW CREATE TABLE customers;

-- insert 1 row in customer table
INSERT INTO customers (first_name, last_name, postal_code, city, province, country, 
	phone_no, email_address, gender)
VALUES ('Maya','Patel','L9M9K0','Milton','Okville','Canada','920-845-8585',
	'mayap@gmail.com','Female'); 
SELECT * FROM customers;

-- updated province in customer table
UPDATE customers SET province='ON' WHERE customer_id=1;

-- insert more data into customers
INSERT INTO customers
	(first_name, last_name, postal_code, city, province, country, 
    phone_no, email_address, gender)
VALUES
    ('Hira', 'Manek', 'M3O3L9', 'Toronto', 'ON', 'Canada', '295-653-4511', 'manek@gmail.com', 'Female'),
	('Noor', 'Shah', 'L5K3O3', 'Toronto', 'ON', 'Canada', '905-295-6523', 'shahn@gmail.com', 'Female'),
	('Den', 'Smith', '56214', 'New York', 'CA', 'USA', '295-098-3247', 'densmith@gmail.com', 'Male'),
	('Faruk', 'Sheth', 'I6R9Y2', 'Montreal', 'QB', 'Canada', '654-098-5632', 'faruk@gmail.com', 'Male');
    
-- creating table for appoinments
CREATE TABLE appoinments(
	appoinment_id INT NOT NULL AUTO_INCREMENT,
	customer_id INT NOT NULL,
	appoinment_datetime DATETIME NOT NULL,
	created_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (appoinment_id),
	CONSTRAINT fk_appoinments_customer_id
		FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id)
);

-- insert data in appoinments table
INSERT INTO appoinments 
	(customer_id,appoinment_datetime)
VALUES
	(2,'2023-04-10'),
    (4,'2023-04-12'),
    (1,'2023-04-15');

-- deleted all the records from appoinments
DELETE FROM appoinments WHERE appoinment_id IN (1,2,3);

-- drop the column appoinment_datetime from appoinments
ALTER TABLE appoinments
	DROP appoinment_datetime;

-- added 2 new columns in appoinments
ALTER TABLE appoinments
	ADD COLUMN appoinment_date DATE NOT NULL,
    ADD COLUMN appoinment_time TIME NOT NULL;
DESCRIBE appoinments;

-- change the location for newly added columns    
ALTER TABLE appoinments
	MODIFY created_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER appoinment_time;
ALTER TABLE appoinments
	MODIFY updated_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_datetime;
DESCRIBE appoinments;

-- insert data into appoinments
INSERT INTO appoinments 
	(customer_id,appoinment_date,appoinment_time)
VALUES
	(2,'2023-04-10','09:15:00'),
    (4,'2023-04-12','10:30:00'),
    (1,'2023-04-15','11:00');
    
SELECT * FROM appoinments;

-- updated appoinment time for last entered record
UPDATE appoinments SET appoinment_time='11:30'
	ORDER BY appoinment_id DESC LIMIT 1;

-- selecting first name of the customers for specific appoinment date    
SELECT first_name,appoinments.appoinment_date 
FROM customers
JOIN appoinments 
ON customers.customer_id=appoinments.customer_id
WHERE appoinment_date = '2023-04-12';

SELECT * FROM customers;

-- updating phone no. for specific customer
UPDATE customers SET phone_no='905-908-9965' WHERE customer_id = 3;

-- adding referential actions on appoinments
ALTER TABLE appoinments
	DROP foreign key fk_appoinments_customer_id;
ALTER TABLE appoinments
	ADD CONSTRAINT fk_appoinments_customer_id
		FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
	
SHOW CREATE TABLE appoinments;

-- deleted the record from customers        
DELETE FROM customers WHERE customer_id=2;
SELECT * FROM customers;
SELECT * FROM appoinments;

-- inserting more data into customers
INSERT INTO customers
	(first_name, last_name, postal_code, city, province, country, 
    phone_no, email_address, gender)
VALUES
	('Deni','Acott','61172','Edmonton','AL','Canada','552-689-2224','acott@yahoo.com','Male'),
    ('Meena','Parekh','M5K3P3','Regina','SK','Canada','255-987-6560','meena@gmail.com','Female'),
    ('Denish','Paul','54523','New York','CA','USA','298-324-2514','paul@gmail.com','Male'),
    ('Farry','Shah','R0Y2M8','Montreal','QB','Canada','698-563-2532','farry@gmail.com','Female');

-- inserting more data into appoinments
INSERT INTO appoinments 
	(customer_id,appoinment_date,appoinment_time)
VALUES
	(9,'2023-05-20','09:00'),
    (4,'2023-05-12','05:30'),
    (3,'2023-05-20','02:00'),
    (7,'2023-05-12','11:30'),
    (6,'2023-04-29','04:15');

-- creating table for orders
CREATE TABLE orders(
	order_id INT NOT NULL AUTO_INCREMENT,
	customer_id INT NOT NULL,
	order_date DATETIME NOT NULL,
	expected_delivery_date DATETIME,
	order_total INT NOT NULL,
	order_status VARCHAR(16) NOT NULL DEFAULT 'Received',
	comments VARCHAR(255),
	created_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (order_id),
	CONSTRAINT fk_orders_customer_id
		FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id)
);

-- altering table to modify columns
ALTER TABLE orders
	MODIFY order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE orders
	MODIFY customer_id INT;
ALTER TABLE orders
	MODIFY order_total DECIMAL(10,2) NOT NULL;
    
-- adding referential actions on orders
ALTER TABLE orders 
	DROP FOREIGN KEY fk_orders_customer_id; 
ALTER TABLE orders
	ADD CONSTRAINT fk_orders_customer_id
		FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL;

DESCRIBE orders;
SHOW CREATE TABLE orders;

-- insert data into orders
INSERT INTO orders
	(customer_id, expected_delivery_date, order_total, comments)
VALUES
    (7, '2023-05-10', 500, 'If you can give me some discount, I need to order more suff'),
	(1, '2023-04-15', 200, ''),
    (8, '2023-04-09', 250, ''),
    (7, '2023-05-01', 255, ''),
    (5, '2023-04-20', 100, '');

SELECT * FROM orders;

-- updating order total for one record
UPDATE orders
	SET order_total=565.00 WHERE order_id=1;

-- inserting more data into orders
INSERT INTO orders
	(customer_id, expected_delivery_date, order_total, comments)
VALUES
    (3, '2023-05-12', 141.25, '');
SELECT * FROM orders; 

-- deleting specific row from the orders table
DELETE FROM orders WHERE order_id=6;
SELECT * FROM orders;
 
-- creating table for products
CREATE TABLE products(
	product_id INT NOT NULL AUTO_INCREMENT,
	product_name VARCHAR(50) NOT NULL,
	category VARCHAR(50) NOT NULL,
	image VARCHAR(255),
	price DECIMAL(10,2) NOT NULL,
	details VARCHAR(255) NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (product_id)
);

-- inserting data into products
INSERT INTO products
	(product_name, category, price, image, details)
VALUES
    ('Dagli','Specialty Products', 255.50,
	'https://drive.google.com/uc?export=view&id=1Gu-_EjMbjq5r7RlIO53kDjFNrQEjFDC0',
	'We have been making Traditional Parsi clothes for 30+ years. We are PARSI DAGLI Specialists. 
	 We also make Sadra, Shirts, Pants, and many more parsi clothings.');

-- inserting more products
INSERT INTO products
	(product_name, category, price, image, details)
VALUES
	('Dress Pant','Mens Pants',20,
    'https://drive.google.com/uc?export=view&id=1PaVN0kTLHI6o3CV8AaA3qntAipcQK8W6',
    'Sample pants made from customers selected material.'),
    ('Dress Shirt','Mens Shirts',10,
    'https://drive.google.com/uc?export=view&id=1pPQCYaWmYJDfzYn7Qm8-2-kumrCbtyhj',
    'Sample zippered polo shirt.'),
    ('3 Piece Suit','Womens Dresses',20,
    'https://drive.google.com/uc?export=view&id=1gb_MyoTjaNePbVx2s96pScxWqdW6dX4u',
    'Pant, Designer Top, Scarf made from dress material.'),
    ('Short Sleeve Shirt','Womens Shirts',10,
    'https://drive.google.com/uc?export=view&id=1RT1OfI5Oxet_eYyLtx4OJCBw7-wbNCHd',
    'Women zipperd half sleeve shirt.'),
     ('Collar Top','Womens Tops',10,
    'https://drive.google.com/uc?export=view&id=1rlPxgjCbnr-O0vqCIE-JIDvzlcHAYQs5',
    'Fancy collar top for fall.'),
    ('Silk Top','Womens Tops',15,
    'https://drive.google.com/uc?export=view&id=1QZg7LwUfDDZ4zwcJANrpVKmekf0ysDT8',
    'Double layered top.');

SELECT * FROM products;

-- creating linking table orderdetails
CREATE TABLE orderdetails(
	order_detail_id INT NOT NULL AUTO_INCREMENT,
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	no_of_items INT NOT NULL,
	PRIMARY KEY (order_detail_id),
	CONSTRAINT fk_orderdetails_order_id
		FOREIGN KEY (order_id)
		REFERENCES orders(order_id),
	CONSTRAINT fk_orderdetails_product_id
		FOREIGN KEY (product_id)
		REFERENCES products(product_id)
);

-- adding referential actions on orderdetails
ALTER TABLE orderdetails
	DROP FOREIGN KEY fk_orderdetails_order_id; 
ALTER TABLE orderdetails
	ADD CONSTRAINT fk_orderdetails_order_id
		FOREIGN KEY (order_id)
		REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE;

SHOW CREATE TABLE orderdetails;

-- inserting more data into orders
INSERT INTO orders
	(customer_id, expected_delivery_date, order_total, comments)
VALUES
    (9, '2023-05-20', 275.50, ''),
	(6, '2023-05-05', 150, ''),
    (7, '2023-04-28', 75, ''),
    (4, '2023-05-12', 200, ''),
    (3, '2023-05-10', 500.50, '');

START TRANSACTION;
INSERT INTO orders
	(customer_id, expected_delivery_date, order_total, comments)
VALUES
    (3, '2023-05-12', 141.25, '');
COMMIT;

SELECT * FROM orders;
    
-- working in transactions
START TRANSACTION;
-- inserting data into orderdetails
INSERT INTO orderdetails
	(order_id, product_id, no_of_items)
VALUES
    (1,1,1),
    (1,2,1),
    (2,1,1),
    (3,4,10),
    (4,3,2),
    (4,2,4),
    (5,3,5),
    (7,4,4),
    (8,5,1),
    (8,6,2),
    (8,7,2),
    (9,2,2),
    (10,4,3),
    (11,2,5),
    (11,3,6),
    (12,1,2);
SELECT * FROM orderdetails;

/* --------- I did not COMMIT the TRANSACTION before so there is no data into the orderdetails table,
			 I insert data again and my order_detail_id starts from 17         			--------- */
COMMIT;    

-- creating table for measurements
CREATE TABLE measurements(
	measurement_id INT NOT NULL AUTO_INCREMENT,
	order_detail_id INT,
	measurement_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	material_type VARCHAR(50),
	top_length DECIMAL(10,2),
    chest DECIMAL(10,2),
	top_waist DECIMAL(10,2),
	top_hips DECIMAL(10,2),
    shoulder DECIMAL(10,2),
	sleeve_length DECIMAL(10,2),
	collar DECIMAL(10,2),
	pant_length DECIMAL(10,2),
	pant_waist DECIMAL(10,2),
	pant_hips DECIMAL(10,2),
	seat DECIMAL(10,2),
    inseam DECIMAL(10,2),
    bottom DECIMAL(10,2),
    notes VARCHAR(255),
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (measurement_id),
	CONSTRAINT fk_measurements_order_detail_id
		FOREIGN KEY (order_detail_id)
		REFERENCES orderdetails(order_detail_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- inserting data into measurements
INSERT INTO measurements
	(order_detail_id, measurement_date, material_type, top_length, chest, top_waist, top_hips, shoulder, sleeve_length, collar, notes)
VALUES
    (17, '2023-04-03', 'gabardine', 29, 36, 32, 37.5, 18, 23, 15.5, ''),
    (19, '2023-04-03', 'cotton', 26, 34, 32, 36.5, 16.5, 22, 14, ''),
    (21, '2023-04-03', '', 27, 36, 32, 37, 17, 23.5, 15.5, ''),
    (23, '2023-04-03', 'cotton', 28, 35.5, 32, 36.5, 18, 24.5, 16, ''),
    (31, '2023-04-11', 'polyester', 26, 35, 31.5, 36.5, 16, 22, 14.5, '');
INSERT INTO measurements
	(order_detail_id, measurement_date, material_type, pant_length, pant_waist, pant_hips, seat, inseam, bottom, notes)
VALUES
    (22, '2023-04-03', 'wool', 38, 32, 37, 23, 27, 16, ''),
    (28, '2023-04-11', '', 40, 38, 32, 24.5, 28, 16.5, '');
SELECT * FROM measurements;

SHOW TABLES;

SELECT * FROM customers;
SELECT * FROM appoinments;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM orderdetails;
SELECT * FROM measurements;

-- Scripts with queries:

-- 1)show how many customers from each country
SELECT COUNT(customer_id) AS Total_Customers, country AS Country
FROM customers
GROUP BY country;  

-- 2)updating the time for a specific row using transaction and rollback to the orignal time    
START TRANSACTION;
UPDATE appoinments
	SET appoinment_time='04:30'
    WHERE appoinment_id=11;
SELECT * FROM appoinments;
ROLLBACK;

-- 3)select all the products ordered by specific customer
SELECT c.first_name, c.last_name, p.product_name, p.price, od.no_of_items
	FROM customers AS c
    JOIN orders AS o
    ON c.customer_id=o.customer_id
    JOIN orderdetails AS od
    ON o.order_id=od.order_id
    JOIN products AS p
    ON od.product_id=p.product_id
    WHERE c.customer_id=6;

-- 4)selecting product with the maximum price     
SELECT product_name, category, price
	FROM products
    WHERE price=(SELECT MAX(price)FROM products);

-- 5A)show how many total products each customer has ordered   
SELECT c.first_name, c.last_name, SUM(od.no_of_items) AS Number_of_Products_Ordered
	FROM orderdetails AS od
    JOIN orders AS o
    ON od.order_id=o.order_id
    JOIN customers AS c
    ON o.customer_id=c.customer_id
    GROUP BY c.first_name, c.last_name;

-- 5B)show how many of each product each customer has ordered   
SELECT c.first_name, c.last_name, p.product_name, SUM(od.no_of_items) AS Number_of_Products_Ordered
	FROM orderdetails AS od
    JOIN products AS p
    ON od.product_id=p.product_id
    JOIN orders AS o
    ON od.order_id=o.order_id
    JOIN customers AS c
    ON o.customer_id=c.customer_id
    GROUP BY c.first_name, c.last_name, p.product_name;

-- 6)show product name, category and details where category like 'wom%'    
SELECT product_name, category, details
	FROM products
    WHERE category LIKE 'wom%';

-- 7)show how many orders delivery after next 15 days (Using CAST() to get only date from datetime)
SELECT CAST(expected_delivery_date AS DATE) AS Delivery_After_15_Days, COUNT(order_id) AS orders 
	FROM orders
    WHERE expected_delivery_date > (SELECT DATE_ADD(NOW(),INTERVAL 15 DAY))
    GROUP BY CAST(expected_delivery_date AS DATE)
    ORDER BY CAST(expected_delivery_date AS DATE);

-- 8)show how many appoinments per day for days which have not passed
SELECT appoinment_date, IF (COUNT(appoinment_date)>1 , COUNT(appoinment_date), 'Only 1 Appoinment') AS 'Appoinments Per Day' 
	FROM appoinments
    WHERE appoinment_date >= NOW()
    GROUP BY appoinment_date
    ORDER BY appoinment_date;

-- 9)show product and measurements for specific customer
SELECT c.first_name, c.last_name, p.product_name, CAST(m.measurement_date AS DATE) AS measurement_date, m.material_type, 
	m.top_length, m.chest, m.top_waist, m.top_hips, m.shoulder, m.sleeve_length, m.collar, 
    m.pant_length, m.pant_waist, m.pant_hips, m.seat, m.inseam, m.bottom, m.notes
	FROM customers AS c
    JOIN orders AS o
    ON c.customer_id=o.customer_id
    JOIN orderdetails AS od
    ON o.order_id=od.order_id
    JOIN products AS p
    ON od.product_id=p.product_id
    JOIN measurements AS m
    ON od.order_detail_id=m.order_detail_id
    WHERE c.customer_id=7;

-- 10)show the virtual table with product image, category and price  
CREATE VIEW Popular_Products AS
	SELECT image, category, price
	FROM products
    WHERE category LIKE '%MEN%';
SELECT * FROM Popular_Products;
