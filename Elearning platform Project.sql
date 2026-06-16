-- Database Creation
create database E_Learning_Platform;

use E_Learning_Platform;


-- Table Creation
create table Learners (
learner_id int primary key,
full_name varchar(100),
country varchar(50)
);

create table Courses (
course_id int primary key,
course_name varchar(100),
category varchar(50),
unit_price decimal(10,2)
);

create table Purchases (
purchase_id int primary key,
learner_id int,
course_id int,
quantity int,
purchase_date date,
foreign key (learner_id) references learners(learner_id),
foreign key (course_id) references courses(course_id)
);


-- Insert Datas
insert into Learners (learner_id, full_name, country) Values
(1001, 'Renu Ram', 'India'),
(1002, 'Dhivya', 'UAE'),
(1003, 'Sudhakar', 'Singapore'),
(1004, 'Rudhra Dev', 'UK'),
(1005, 'Jackson White', 'USA');

insert into Courses (course_id, course_name, category, unit_price) values
(501, 'Data Visualization with Power BI', 'Business Intelligence' , 25000),
(502, 'Python for Data Analysis', 'Programming' , 60000),
(503, 'Introduction of Data Science', 'Data Science', 8999.10),
(504, 'Digital Marketing Strategy', 'Marketing' , 12000),
(505, 'Cybersecurity Basics', 'Information Security' , 22000.99);

insert into Purchases (purchase_id, learner_id, course_id, Quantity, purchase_date) values
(101 , 1001 , 503 , 1 , '2026-01-08'),
(102 , 1003 , 501 , 2 , '2026-01-30'),
(103 , 1002 , 505 , 1 , '2026-02-05'),
(104 , 1004 , 501 , 1 , '2026-02-16'),
(105 , 1005 , 503 , 1 , '2026-03-10'),
(106 , 1001 , 504 , 2 , '2026-03-29'),
(107 , 1003 , 502 , 3 , '2026-04-12'),
(108 , 1002 , 504 , 1 , '2026-04-20');


-- Data Exploration using Join
select p.learner_id,
round(sum(p.quantity * c.unit_price),2) AS total_spent
from purchases p
join courses c 
on p.course_id = c.course_id
group by p.learner_id
order by total_spent desc;

select l.full_name as learner_name,
c.course_name, c.category, p.quantity, 
round(p.quantity * c.unit_price, 2) as total_amount,
p.purchase_date from purchases p
inner join learners l on p.learner_id = l.learner_id 
inner join courses C on p.course_id = c.course_id 
order by total_amount asc;

select l.full_name as learner_name, c.course_name, c.category, p.quantity,
round(p.quantity * c.unit_price, 2) as total_amount,
p.purchase_date from Learners l
left join Purchases p on l.learner_id = p.learner_id
left join Courses c on p.course_id = c.course_id
order by learner_name;

select l.full_name as learner_name, c.course_name, c.category, p.quantity,
round(p.quantity * c.unit_price, 2) as total_amount, 
p.purchase_date from Purchases p
right join Courses c on p.course_id = c.course_id
left join Learners l on p.learner_id = l.learner_id
order by course_name;


-- Analytical Queries
-- Display each learner’s total spending (quantity × unit_price) along with their country
select l.learner_id, l.full_name, l.country,
round(sum(p.quantity * c.unit_price), 2) as total_spent
from learners l
inner join purchases p
on l.learner_id = p.learner_id
inner join courses c 
on p.course_id = c.course_id
group by l.learner_id, l.full_name, l.country
order by total_spent;

select c.course_id, c.course_name, c.category,
sum(p.quantity) as total_quantity_sold
from courses c
inner join purchases p
on p.course_id = c.course_id
group by c.course_id, c.course_name, c.category
order by total_quantity_sold desc
limit 3;

select c.category,
round(sum(p.quantity * c.unit_price), 2) as total_revenue,
count(distinct p.learner_id) as unique_learners
from courses c
inner join purchases p
on p.course_id = c.course_id
group by c.category
order by total_revenue;

select l.learner_id, l.full_name as learner_name,
count(distinct c.category) as category_count
from learners l
inner join purchases p
on p.learner_id = l.learner_id
inner join courses c
on p.course_id = c.course_id
group by l.learner_id, l.full_name
having count(DISTINCT c.category) > 1;

select c.course_id, c.course_name, c.category
from courses c
left join purchases p
on c.course_id = p.course_id
where p.course_id = null;