create database topiwala_tailor;
use topiwala_tailor;

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
describe customers;

alter table customers
modify created_at datetime not null default current_timestamp,
modify updated_at datetime not null default current_timestamp;
alter table customers
modify updated_at datetime not null default current_timestamp on update now();

insert into customers (first_name, last_name, postal_code, city, province, country, 
	phone_no, email_address, gender)
	values ('Maya','Patel','L9M9K0','Milton','Okville','Canada','920-845-8585',
	'mayap@gmail.com','Female'); 
select * from customers;

update customers set province='ON' where customer_id=1;

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

create table measurements(
	measurement_id int not null auto_increment,
	order_detail_id int not null,
	measurement_date datetime,
	material_type varchar(50),
	top_length int,
	shoulder int,
	sleeve_length int,
	chest int,
	top_waist int,
	top_hips int,
	collar int,
	pant_length int,
	pant_waist int,
	pant_hips int,
	inseam int,
	created_at datetime not null default current_timestamp,
	updated_at datetime not null default current_timestamp on update now(),
	primary key (measurement_id),
	constraint fk_measurements_order_detail_id
		foreign key (order_detail_id)
		references orderdetails(order_detail_id)
);

insert into customers
	(first_name, last_name, postal_code, city, province, country, 
    phone_no, email_address, gender)
values
	('Hira','Manek','K9G8J3','Brampton','ON','Canada','852-652-2154','manek@yahoo.com','Female'),
    ('Noor','Shah','L5K3O3','Toronto','ON','Canada','965-987-6544','shahn@gmail.com','Female'),
    ('Den','Smith','56214','New York','CA','USA','295-098-3247','densmith@gmail.com','Male'),
    ('Faruk','Sheth','I6R9Y2','Montreal','QB','Canada','654-098-5632','faruk@gmail.com','Male');
    
insert into appoinments 
	(customer_id,appoinment_datetime)
values
	(2,'2023-04-10'),
    (4,'2023-04-12'),
    (1,'2023-04-15');
select * from appoinments;

delete from appoinments where appoinment_id in (1,2,3);

alter table appoinments
	drop appoinment_datetime;

alter table appoinments
	add column appoinment_date date not null,
    add column appoinment_time time not null;
    
alter table appoinments
	modify  created_datetime datetime not null default current_timestamp after appoinment_time;
alter table appoinments
	modify  updated_datetime datetime not null default current_timestamp on update now() after created_datetime;
describe appoinments;

insert into appoinments 
	(customer_id,appoinment_date,appoinment_time)
values
	(2,'2023-04-10','09:15:00'),
    (4,'2023-04-12','10:30:00'),
    (1,'2023-04-15','11:00');
    
select * from appoinments;

update appoinments set appoinment_time='11:30'
	order by appoinment_id desc limit 1;
    
select first_name 
from customers
join appoinments on customers.customer_id=appoinments.customer_id
where appoinment_date = '2023-04-12';

select * from customers;

update customers set phone_no='905-908-9965' where customer_id = 3;

alter table appoinments
	add 
		foreign key (customer_id)
		references customers(customer_id)
        on delete cascade
        on update cascade;
        
delete from customers where customer_id=2;