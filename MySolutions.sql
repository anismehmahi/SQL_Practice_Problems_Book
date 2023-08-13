/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM dbo.Shippers;

select categoryname, Description from Categories;

select FirstName, LastName, HireDate 
from Employees 
where Title='Sales Representative' and Country='USA';

select Orders.OrderID, OrderDate from Orders where EmployeeID =5;


select SupplierID, ContactName, ContactTitle from Suppliers where ContactTitle != 'Marketing Manager';

select ProductID, ProductName from Products where ProductName like '%queso%';

select OrderID, CustomerID, ShipCountry from Orders where ShipCountry in ('france','belgium');

select OrderID, CustomerID, ShipCountry from Orders where ShipCountry in ('Brazil','argentina', 'mexico','Venezuela' );

select FirstName, LastName, Title,CAST(BirthDate as DATE) as Birthdate from Employees order by BirthDate ASC;

select FirstName, LastName, (FirstName+' ' +LastName) as complete_name from Employees;

select OrderId,ProductId, UnitPrice,Quantity, (UnitPrice*Quantity) as TotalPrice from OrderDetails
order by OrderId,ProductId;

select count(CustomerID)  from Customers;

select top 1 * from Orders order by OrderDate ASC ;
select min(orderdate)from Orders  ; 

select distinct Country from Customers;

select ContactTitle, count(ContactTitle) as TotalContactTitle from Customers
group by ContactTitle
order by TotalContactTitle DESC;

select ProductID, ProductName,CompanyName  from Products join Suppliers on Products.SupplierID=Suppliers.SupplierID
order by ProductID;

select OrderID, CAST(OrderDate as date) as OrderDate, CompanyName from Orders join Shippers on Shippers.ShipperID=Orders.ShipVia
where OrderID<10300
order by OrderID ;

select CategoryName, count(*) as Total from Products join Categories on Categories.CategoryID = Products.CategoryID 
group by CategoryName
order by Total DESC;

select Country, City, count(*) as Total from Customers
group by Country, City
order by Total DESC;

select ProductID, ProductName, UnitsInStock, ReorderLevel from Products
where UnitsInStock< ReorderLevel
order by ProductID;

select ProductID, ProductName, UnitsInStock, ReorderLevel, Discontinued from Products
where (UnitsInStock + UnitsOnOrder ) <= ReorderLevel and Discontinued=0
order by ProductID;

select  CustomerID,CompanyName, Region from Customers
order by (case when Region is null then 0 
								  else 1 end ) DESC,Region,CustomerID 

select top 3 ShipCountry, AVG(Freight) as average from Orders
group by ShipCountry
order by average DESC

select top 3 ShipCountry, AVG(Freight) as average from Orders
where year(OrderDate)=2015
group by ShipCountry 
order by average DESC


select top 3 ShipCountry, AVG(Freight) as average from Orders
where OrderDate >= DATEADD(yy,-1,(select max(OrderDate) from Orders))
group by ShipCountry 
order by average DESC


select Orders.EmployeeID,LastName,Orders.OrderID, ProductName, sum(Quantity) as quantite from Orders join Employees on Orders.EmployeeID = Employees.EmployeeID join OrderDetails on OrderDetails.OrderID=Orders.OrderID join Products on 
products.ProductID = OrderDetails.ProductID
group by Orders.EmployeeID,LastName,Orders.OrderID, ProductName
order by Orders.OrderID, Orders.EmployeeID desc, quantite desc;


select * from Customers  
where CustomerID not in (
select CustomerID from Orders)


select * from Customers 
where CustomerID not in (select customerID from Orders
where EmployeeID=4)


select paa.customerID,paa.OrderID,paa.totalPerOrder from (select orders.OrderID,customerID, totalPerOrder = SUM(Quantity*UnitPrice) from Orders join OrderDetails on OrderDetails.OrderID = Orders.OrderID
where year(OrderDate) = 2016
group by orders.OrderID,customerID
) as paa
where paa.totalPerOrder>=10000



select paa.customerID,paa.totalPerOrder as Total from (select customerID, totalPerOrder = SUM(Quantity*UnitPrice) from Orders join OrderDetails on OrderDetails.OrderID = Orders.OrderID
where year(OrderDate) = 2016
group by customerID
) as paa
where paa.totalPerOrder>=15000


select paa.customerID,paa.totalPerOrder as Total from (select customerID, totalPerOrder = SUM(Quantity*UnitPrice*(1-Discount)) from Orders join OrderDetails on OrderDetails.OrderID = Orders.OrderID
where year(OrderDate) = 2016
group by customerID
) as paa
where paa.totalPerOrder>=10000



select top 10 OrderID, count(*) as total from OrderDetails
group by OrderID
order by total DESC


Select TOP 2 percent
OrderID
,ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS [RandomNumber]
From Orders
order by RandomNumber


select paa.OrderID from (Select OrderID ,Quantity, count(*) as nbr
From OrderDetails
Where Quantity >= 60
group by OrderID ,Quantity
) as paa
where paa.nbr=2


select * from OrderDetails join (select paa.OrderID, paa.Quantity from (Select OrderID ,Quantity, count(*) as nbr
From OrderDetails
Where Quantity >= 60
group by OrderID ,Quantity
) as paa
where paa.nbr=2
)paa on paa.OrderID = OrderDetails.OrderID and paa.Quantity = OrderDetails.Quantity



Select
OrderDetails.OrderID
,ProductID
,UnitPrice
,Quantity
,Discount
From OrderDetails
Join (
Select
OrderID
From OrderDetails
Where Quantity >= 60
Group By OrderID, Quantity
Having Count(*) =2
) PotentialProblemOrders
on PotentialProblemOrders.OrderID = OrderDetails.OrderID
Order by OrderID, ProductID