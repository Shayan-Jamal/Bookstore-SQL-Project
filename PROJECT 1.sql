drop table if exists Books;
create table Books(
    Book_ID serial primary key,
	Title varchar(100),
	Author varchar(100),
	Genre varchar(50),
	Published_year int,
	Price numeric(10,2),
	Stock int
);
drop table if exists Customer;
create table Customer(
    Customer_ID serial primary key,
	Name varchar(100),
	Email varchar(100),
	Phone varchar(15),
	City varchar(50),
	Country varchar(150)	
);
drop table if exists orders;
create table Orders (
    Order_ID serial primary key,
	Customer_ID int references Customer(Customer_ID),
	Book_ID int references Books(Book_ID),
	Order_date date,
	Quantity int,
	Total_Amount numeric(10,2)
);
Select * from Books;
Select * from Customer;
Select * from Orders;

--Retrieve all books in the "fiction" genre--
select * from Books
where Genre='Fiction';

--Find books punlished after 1950--
select * from Books
where published_year>1950;

--List all customers from 'Canada'--
select * from Customer
where country='Canada';

--show orders placed in November 2023--
select * from orders
where order_date>='2023-11-01' and order_date<='2023-11-30'

--retrieve the total stock of books available--
select sum(stock) as total_stock
from books;

--find the details of the most expensive books--
select * from Books order by price desc limit 1;

--show all customers who ordered more than 1 quantity of a book--
select * from orders
where quantity>1;

--retrieve all orders where the total_amount exceeds $20--
select * from orders
where total_amount>20;

--list all genre available in the books table--
select distinct genre from books;

--find the books with the lowst stock--
select * from books order by stock limit 1;

--calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue
from orders;

--ADVANCED QUESTIONS--

--Retrieve the total number of books sold for each genre--
select b.genre,sum(o.quantity) as total_book_sold
from orders o
join books b on o.book_id=b.book_id
group by b.genre;

--find the average price of books in the "fantasy" genre--
select avg(price) as average_price
from books
where genre='Fantasy';

--list customers who have placed at least 2 orders--
select c.*, count(o.order_id) as orders_placed
from customer c
join orders o on o.customer_id=c.customer_id
group by c.customer_id
having count(o.order_id)>=2;

--find the most frequently ordered book--
select b.book_id, count(o.order_id) as orders_placed, b.*
from orders o join books b on b.book_id=o.book_id
group by b.book_id
order by  count(order_id) desc limit 1;

--Show the top 3 most expensive book of "Fantasy" genre--
select * from books 
where genre='Fantasy'
order by price desc limit 3;

--retieve the total quantity of books sold by each author--
select b.author, sum(o.quantity) as total_quantity_sold
from books b join orders o on o.book_id=b.book_id
group by b.author;

--list the cities where customers who spent over $30 are located
select distinct c.city,o.total_amount
from customer c join orders o on o.customer_id=c.customer_id
where o.total_amount>30;

--find the customer who spent the most on orders--
select c.customer_id,c.name, sum(o.total_amount) as total_spent
from customer c join orders o on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by sum(o.total_amount) desc limit 1;

--calculate the stock remaining after fulfiling all orders--
select b.book_id, b.stock,coalesce(sum(quantity),0) as quantity, 
b.stock-coalesce(sum(quantity),0) as stock_remaining
from books b
left join orders o 
on o.book_id=b.book_id
group by b.book_id;