-- creating my project database and using it
create database topiwala_tailor;
use topiwala_tailor;

-- creating tables

-- creating table for customers
create table customers (
	customer_id int not null auto_increment,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	postal_code varchar(10) not null,
	city varchar(50) not null,
	province varchar(50) not null,
	country varchar(60) not null,
	phone_no varchar(16) not null,
	email_address varchar(255) not null,
	gender varchar(50) not null,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	primary key (customer_id)
);

-- alter table to put default time for created_at and updated_at and on update
alter table customers
modify created_at datetime not null default current_timestamp,
modify updated_at datetime not null default current_timestamp;
alter table customers
modify updated_at datetime not null default current_timestamp on update now();

-- insert 1 row in customer table
insert into customers (first_name, last_name, postal_code, city, province, country, 
	phone_no, email_address, gender)
	values ('Maya','Patel','L9M9K0','Milton','Okville','Canada','920-845-8585',
	'mayap@gmail.com','Female'); 
select * from customers;

-- updated province in customer table
update customers set province='ON' where customer_id=1;

-- insert more data into customers
insert into customers
	(first_name, last_name, postal_code, city, province, country, 
    phone_no, email_address, gender)
	values
    ('Hira', 'Manek', 'M3O3L9', 'Toronto', 'ON', 'Canada', '295-653-4511', 'manek@gmail.com', 'Female'),
	('Noor', 'Shah', 'L5K3O3', 'Toronto', 'ON', 'Canada', '905-295-6523', 'shahn@gmail.com', 'Female'),
	('Den', 'Smith', '56214', 'New York', 'CA', 'USA', '295-098-3247', 'densmith@gmail.com', 'Male'),
	('Faruk', 'Sheth', 'I6R9Y2', 'Montreal', 'QB', 'Canada', '654-098-5632', 'faruk@gmail.com', 'Male');
    
-- creating table for appoinments
create table appoinments(
	appoinment_id int not null auto_increment,
	customer_id int not null,
	appoinment_datetime datetime not null,
	created_datetime datetime not null default current_timestamp,
	updated_datetime datetime not null default current_timestamp on update now(),
	primary key (appoinment_id),
	constraint fk_appoinments_customer_id
		foreign key (customer_id)
		references customers(customer_id)
);

-- insert data in appoinments table
insert into appoinments 
	(customer_id,appoinment_datetime)
values
	(2,'2023-04-10'),
    (4,'2023-04-12'),
    (1,'2023-04-15');

-- deleted all the records from appoinments
delete from appoinments where appoinment_id in (1,2,3);

-- drop the column 
alter table appoinments
	drop appoinment_datetime;

-- added 2 new columns
alter table appoinments
	add column appoinment_date date not null,
    add column appoinment_time time not null;

-- change the location for newly added columns    
alter table appoinments
	modify  created_datetime datetime not null default current_timestamp after appoinment_time;
alter table appoinments
	modify  updated_datetime datetime not null default current_timestamp on update now() after created_datetime;
describe appoinments;

-- insert data into appoinments
insert into appoinments 
	(customer_id,appoinment_date,appoinment_time)
values
	(2,'2023-04-10','09:15:00'),
    (4,'2023-04-12','10:30:00'),
    (1,'2023-04-15','11:00');
    
select * from appoinments;

-- updated time for last entered record
update appoinments set appoinment_time='11:30'
	order by appoinment_id desc limit 1;

-- selecting first name of the customers for specific appoinment date    
select first_name,appoinments.appoinment_date 
from customers
join appoinments 
on customers.customer_id=appoinments.customer_id
where appoinment_date = '2023-04-12';

select * from customers;

-- updating phone no. for specific customer
update customers set phone_no='905-908-9965' where customer_id = 3;

-- adding referential actions on appoinments
alter table appoinments
	add 
		foreign key (customer_id)
		references customers(customer_id)
        on delete cascade
        on update cascade;
        
-- deleted the record from customers        
delete from customers where customer_id=2;

-- creating table for orders
create table orders(
	order_id int not null auto_increment,
	customer_id int not null,
	order_date datetime not null,
	expected_delivery_date datetime,
	order_total int not null,
	order_status varchar(16) not null default 'Received',
	comments varchar(255),
	created_datetime datetime not null default current_timestamp,
	updated_datetime datetime not null default current_timestamp on update now(),
	primary key (order_id),
	constraint fk_orders_customer_id
		foreign key (customer_id)
		references customers(customer_id)
);

-- altering table to modify column
alter table orders
	modify order_date datetime not null default now();
alter table orders
	modify customer_id int;
alter table orders
	modify order_total decimal(10,2) not null;
    
-- adding referential actions on orders
alter table orders
	add
		foreign key (customer_id)
		references customers(customer_id)
        on update cascade
        on delete set null;

describe orders;

-- insert data into orders
insert into orders
	(customer_id, expected_delivery_date, order_total, comments)
    values
    (7, '2023-05-10', 500, 'If you can give me some discount, I need to order more suff'),
	(1, '2023-04-15', 200, ''),
    (8, '2023-04-09', 250, ''),
    (7, '2023-05-01', 255, ''),
    (5, '2023-04-20', 100, '');

-- updating order total for one record
update orders
	set order_total=565.00 where order_id=1;

-- inserting more data into orders
insert into orders
	(customer_id, expected_delivery_date, order_total, comments)
    values
    (3, '2023-05-12', 141.25, '');

-- deleting specific row from the orders table
delete from orders where order_id=6;

select * from orders; 

-- creating table for products
create table products(
	product_id int not null auto_increment,
	product_name varchar(50) not null,
	category varchar(50) not null,
	image varchar(255),
	price decimal(10,2) not null,
	details varchar(255) not null,
	created_at datetime not null default current_timestamp, 
	updated_at datetime not null default current_timestamp on update now(),
	primary key (product_id)
);

-- inserting data into products
insert into products
	(product_name, category, price, image, details)
    values
    ('Dagli','Specialty Products', 255.50,
	'https://drive.google.com/uc?export=view&id=1Gu-_EjMbjq5r7RlIO53kDjFNrQEjFDC0',
	'We have been making Traditional Parsi clothes for 30+ years. We are PARSI DAGLI Specialists. 
	 We also make Sadra, Shirts, Pants, and many more parsi clothings.');

-- inserting more products
insert into products
	(product_name, category, price, image, details)
    values
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

select * from products;

-- creating linking table orderdetails
create table orderdetails(
	order_detail_id int not null auto_increment,
	order_id int not null,
	product_id int not null,
	no_of_items int not null,
	primary key (order_detail_id),
	constraint fk_orderdetails_order_id
		foreign key (order_id)
		references orders(order_id),
	constraint fk_orderdetails_product_id
		foreign key (product_id)
		references products(product_id)
);

-- adding referential actions on orderdetails
alter table orderdetails
	add
		foreign key (order_id)
		references orders(order_id)
        on update cascade
        on delete cascade;

-- creating table for measurements
create table measurements(
	measurement_id int not null auto_increment,
	order_detail_id int,
	measurement_date datetime not null default now(),
	material_type varchar(50),
	top_length decimal(10,2),
    chest decimal(10,2),
	top_waist decimal(10,2),
	top_hips decimal(10,2),
    shoulder decimal(10,2),
	sleeve_length decimal(10,2),
	collar decimal(10,2),
	pant_length decimal(10,2),
	pant_waist decimal(10,2),
	pant_hips decimal(10,2),
	seat decimal(10,2),
    inseam decimal(10,2),
    bottom decimal(10,2),
    notes varchar(255),
	created_at datetime not null default current_timestamp,
	updated_at datetime not null default current_timestamp on update now(),
	primary key (measurement_id),
	constraint fk_measurements_order_detail_id
		foreign key (order_detail_id)
		references orderdetails(order_detail_id)
        on update cascade
        on delete set null
);

-- inserting data into measurements
insert into measurements
	(order_detail_id, measurement_date, material_type, top_length, chest, top_waist, top_hips, shoulder, sleeve_length, collar, notes)
    values
    (17, '2023-04-03', 'gabardine', 29, 36, 32, 37.5, 18, 23, 15.5, ''),
    (19, '2023-04-03', 'cotton', 26, 34, 32, 36.5, 16.5, 22, 14, ''),
    (21, '2023-04-03', '', 27, 36, 32, 37, 17, 23.5, 15.5, ''),
    (23, '2023-04-03', 'cotton', 28, 35.5, 32, 36.5, 18, 24.5, 16, ''),
    (31, '2023-04-11', 'polyester', 26, 35, 31.5, 36.5, 16, 22, 14.5, '');
insert into measurements
	(order_detail_id, measurement_date, material_type, pant_length, pant_waist, pant_hips, seat, inseam, bottom, notes)
    values
    (22, '2023-04-03', 'wool', 38, 32, 37, 23, 27, 16, ''),
    (28, '2023-04-11', '', 40, 38, 32, 24.5, 28, 16.5, '');

-- inserting more data into customers
insert into customers
	(first_name, last_name, postal_code, city, province, country, 
    phone_no, email_address, gender)
values
	('Deni','Acott','61172','Edmonton','AL','Canada','552-689-2224','acott@yahoo.com','Male'),
    ('Meena','Parekh','M5K3P3','Regina','SK','Canada','255-987-6560','meena@gmail.com','Female'),
    ('Denish','Paul','54523','New York','CA','USA','298-324-2514','paul@gmail.com','Male'),
    ('Farry','Shah','R0Y2M8','Montreal','QB','Canada','698-563-2532','farry@gmail.com','Female');

-- inserting more data into appoinments
insert into appoinments 
	(customer_id,appoinment_date,appoinment_time)
values
	(9,'2023-05-20','09:00'),
    (4,'2023-05-12','05:30'),
    (3,'2023-05-20','02:00'),
    (7,'2023-05-12','11:30'),
    (6,'2023-04-29','04:15');

-- inserting more data into orders
insert into orders
	(customer_id, expected_delivery_date, order_total, comments)
    values
    (9, '2023-05-20', 275.50, ''),
	(6, '2023-05-05', 150, ''),
    (7, '2023-04-28', 75, ''),
    (4, '2023-05-12', 200, ''),
    (3, '2023-05-10', 500.50, '');
    
-- working in transactions
start transaction;
-- inserting data into orderdetails
insert into orderdetails
	(order_id, product_id, no_of_items)
    values
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
select * from orderdetails;
commit;    

-- Queries:
-- 1)show how many customers from each country
select count(customer_id) as Total_Cuatomers,country
from customers
group by country;  

-- 2)updating the time for a specific row using transaction    
start transaction;
update appoinments
	set appoinment_time='04:30'
    where appoinment_id=16;
select * from appoinments;
-- rollback;
commit;

-- 3)select all the products ordered by specific customer
select c.first_name, c.last_name, p.product_name, p.price, od.no_of_items
	from customers as c
    join orders as o
    on c.customer_id=o.customer_id
    join orderdetails as od
    on o.order_id=od.order_id
    join products as p
    on od.product_id=p.product_id
    where c.customer_id=9;

-- 4)selecting product with the maximum price     
select product_name, category, price
	from products
    where price=(select max(price)from products);

-- 5)show how many products each customer has ordered    
select c.first_name, c.last_name, p.product_name, sum(od.no_of_items) as Number_of_Products_Ordered
	from orderdetails as od
    join products as p
    on od.product_id=p.product_id
    join orders as o
    on od.order_id=o.order_id
    join customers as c
    on o.customer_id=c.customer_id
    group by c.first_name, c.last_name, p.product_name;

-- 6)show product name, category and details where category like 'wom%'    
select product_name, category, details
	from products
    where category like 'wom%';

-- 7)show all the delivery date after next 15 days
select cast(expected_delivery_date as date) as Delivery_After_15_Days, count(order_id) as orders 
	from orders
    where expected_delivery_date > (select date_add(now(),interval 15 day))
    group by cast(expected_delivery_date as date)
    order by cast(expected_delivery_date as date);

-- 8)show how many appoinments for a day
select appoinment_date, if (count(appoinment_date)>1 , count(appoinment_date), 'Only 1 Appoinment') as 'Appoinments Per Day' 
	from appoinments
    group by appoinment_date
    order by appoinment_date;

-- 9)show product and measurements for specific customer
select c.first_name, c.last_name, p.product_name, cast(m.measurement_date as date) as measurement_date, m.material_type, 
	m.top_length, m.chest, m.top_waist, m.top_hips, m.shoulder, m.sleeve_length, m.collar, 
    m.pant_length, m.pant_waist, m.pant_hips, m.seat, m.inseam, m.bottom, m.notes
	from customers as c
    join orders as o
    on c.customer_id=o.customer_id
    join orderdetails as od
    on o.order_id=od.order_id
    join products as p
    on od.product_id=p.product_id
    join measurements as m
    on od.order_detail_id=m.order_detail_id
    where c.customer_id=7;

select * from customers;
select * from orders;
select * from products;
select * from orderdetails;
select * from appoinments;
select * from measurements;