Drop Table If Exists Books;
Create  Table Books(
	Book_id Serial Primary key,
	Title varchar(100),
	Author varchar(100), 
	Genre varchar(50),
	Published_Year Int,
	Price Numeric(10,2),
	Stock int
);

Drop Table If Exists Customers;
Create  Table Customers(
	Customer_ID	Serial Primary key,
     Name Varchar(100),	
     Email Varchar(100),	
     Phone Int	,
     City Varchar(100),	
     Country Varchar(100)	
);

Drop Table If Exists Orders;
Create  Table Orders(
	Order_ID Serial Primary key,
	Customer_id int references Customers(Customer_id),
	Book_Id int References Books(Book_Id),
	Order_date Date,
	Quantity int,
	Total_Amount Numeric(10,2)
     	
);

select * from Books;
select * from Customers;
select * from Orders;

-- 1) Retrieve all books in the "Fiction" genre

select * from Books
where genre ='Fiction';

-- 2) Find books published after the year 1950

select * from Books
where Published_year >1950;

-- 3) List all customers from the Canada

select * from Customers
where Country ='Canada';

-- 4) Show orders placed in November 2023

select * from orders
where order_date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available

select Sum(stock) as Total_Stock 
from books;

--6) Find the details of the most expensive book

Select * from books
order by price desc
limit 1; 

-- 7) Show all customers who ordered more than 1 quantity of a book

select * from orders
where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20

select * from orders
where total_amount>20;

-- 9) List all genres available in the Books table
select distinct(genre) from Books;

-- 10) Find the book with the lowest stock

select  * from books
order by stock asc
limit 1;

--11) Calculate the total revenue generated from all orders

select sum(total_amount) as total_revenue
from orders;

--12)  Retrieve the total number of books sold for each genre
select  b.genre,sum(o.quantity) as total_books_sold
from orders as o
join books as b on o.book_id =b.book_id
group by b.genre;

--13) Find the average price of books in the "Fantasy" genre
select avg(price) as Average_Price
from books
where genre='Fantasy';

--14) List customers who have placed at least 2 orders

select c.customer_id,c.name,c.email,count(o.order_id) as order_count
from customers as c
join orders as o on c.customer_id=o.customer_id
group by c.customer_id,c.name,c.email
having count(o.order_id)>=2;

--15) Find the most frequently ordered book
select b.title,o.book_id,count(o.order_id) as order_count
from books as b
join orders as o
on b.book_id=o.book_id
group by o.book_id ,b.title
order by order_count desc
limit 1;


--16) Show the top 3 most expensive books of 'Fantasy' Genre 

select title,author,genre,price
from books
where  genre='Fantasy'
order by price desc
limit 3;

--17) Retrieve the total quantity of books sold by each author
select b.author,sum(o.quantity) as total_count
from books as b
join orders as o 
on b.book_id=o.book_id
group by b.author
order by total_count desc;

--18) List the cities where customers who spent over $30 are located

select Distinct c.city ,o.total_amount 
from customers as c
join orders as o 
on c.customer_id=o.customer_id
where o.total_amount >30  ;

--19) Find the customer who spent the most on orders
select c.customer_id,c.name,c.email,sum(o.total_amount) as total_spent
from customers as c
join orders as o 
on c.customer_id=o.customer_id
group by c.name,c.email,c.customer_id
order by total_spent desc
limit 1;

--20) Calculate the stock remaining after fulfilling all orders
select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as Order_quantity,
	b.stock- coalesce(sum(o.quantity),0) as remaining_stock
from books as b 
left join orders as o
on b.book_id = o.book_id
group by b.book_id,b.title
order by b.book_id;