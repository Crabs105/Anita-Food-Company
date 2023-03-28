/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM Shippers;

Select CategoryName,Description from Categories;

Select * from Employees;

select FirstName,LastName, HireDate
from Employees
where Title= 'Sales Representative' and Country='USA';

-- Answer question 5

Select orderID,OrderDate
from Orders
where EmployeeID='5';

-- Answer question 6

Select SupplierID, ContactName, ContactTitle from
Suppliers
where ContactTitle <> 'Marketing Manager';

-- Answer question 7

Select ProductID,ProductName
from Products
where ProductName like '%queso%';

--Answer question 8

Select OrderID,CustomerID,ShipCountry
from Orders
Where ShipCountry='France' or ShipCountry= 'Belgium';


--Answer question 9

Select OrderID,CustomerID,ShipCountry
from Orders
Where ShipCountry in ('Argentina','Brazil','Mexico','Venezuela');

--Answer question 10

Select FirstName,LastName,Title,BirthDate
from Employees
Order By BirthDate ASC;


--Answer question 11

SELECT FirstName,LastName,Title, Cast(BirthDate as Date) AS DateOnlyBirthDate
from Employees
order By DateOnlyBirthDate asc;

--Answer Question 12

SELECT FirstName,LastName, FirstName+''+LastName as FullName
from Employees

--Answer Question 13

Select OrderID,ProductID,UnitPrice,Quantity, UnitPrice*Quantity as TotalPrice
from OrderDetails

--Answer Question 14

SELECT COUNT(CustomerID) as TotalCustomers
FROM Customers;

--Answer Question 15

Select MIN(OrderDate) as FirstOrder
from Orders;

--Answer Question 16

Select distinct Country 
from Customers
order by country;

--Answer Question 17

Select ContactTitle, COUNT(ContactTitle) AS TotalContactTitle
from Customers
GROUP BY ContactTitle
ORDER BY TotalContactTitle desc;

--Answer Question 18

Select Products.ProductID, Products.ProductName, Suppliers.CompanyName as Supplier
from Products join Suppliers ON Products.SupplierID =Suppliers.SupplierID;

--Answer Question 19

Select Orders.OrderID,Cast( Orders.OrderDate as date) AS OrderDate, Shippers.CompanyName as Shipper
from Orders join Shippers on Orders.ShipVia =Shippers.ShipperID 
where OrderID <'10270';

--Answer Question 20
--For this problem, we'd like to see the total number of in each category.
--Sort the result by the total number of products in descending order

Select  * from Products;


Select CategoryName,Count(CategoryName) As TotalProducts 
from Categories
join  Products on (Categories.CategoryID = Products.CategoryID)
GROUP BY CategoryName
order by TotalProducts desc;

--Answer Question 21
--In the Customer table, show the total number of customers per Country and City

Select  * from Customers;

Select  Country, City ,COUNT(ContactName) as TotalCustomers
from Customers
Group by Country,City
Order by TotalCustomers DESC;



--Answer Question 22
--What products do we have in our inventory that should be reordered?

Select  ProductID,ProductName,UnitsInStock,ReorderLevel
from Products
where UnitsInStock <= ReorderLevel;

--Answer Question 23
-- We still want to reordered some products, but this time we going to incorporate new field

Select  ProductID,ProductName,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued
from Products
where UnitsInStock+UnitsOnOrder <= ReorderLevel and Discontinued=0;

--Answer Question 24
--A salesperson for Northwind is going on a business trip to visit customers and
--would like to see a list of all customers sort by region, in alphabetical order



SELECT CustomerID, CompanyName, Region
FROM Customers 
ORDER BY CASE when Region is not null   THEN  region  END  Desc 
        ,CASE WHEN Region is null THEN 'Null' END;  

--Answer Question 25
-- Some of the countries we ship to have very high freight charges.
-- we'd like to investigate some more shipping options for our customers

Select  shipCountry, avg(Freight) as AverageFreight 
from Orders
group by ShipCountry
order by AverageFreight desc

-- Answer Question 26
--we are continuing on the question above on high freight charges. Now ,instead of
--using all orders we have . we only want to see orders  from 2015

Select  Top 3 shipCountry, avg(Freight) as AverageFreight 
from Orders
where OrderDate between '2015-01-01' and '2016-01-01' 
group by ShipCountry
order by AverageFreight desc

--Answer Question 27
-- we are looking for the missing OrderID from '2015-12-31'

Select *from orders 
order by OrderDate;

-- missing OrderID is 10806

-- Answer Question 28
--Now we want to get the three ship countries with the highest average freight charges. But we
 -- are going to filter for the last 12 months of order date 

 Select  Top 3 shipCountry, avg(Freight) as AverageFreight 
from Orders
where OrderDate between '2015-05-06' and '2016-05-07' 
group by ShipCountry
order by AverageFreight desc

-- Alternative Answer

 Select  Top 3 shipCountry, avg(Freight) as AverageFreight 
from Orders
where OrderDate >=DATEADD(yy,-1, (Select Max(OrderDate) from Orders))
group by ShipCountry
order by AverageFreight desc

--Select Max(OrderDate) from Orders;

-- Answer Question 29
--we are doing inventory, and need to show Employee and Order Detail information like
-- all orders .Sort by OrderID and ProductID 


SELECT Employees.EmployeeID,Employees.LastName,Orders.OrderID,Products.ProductName, OrderDetails.Quantity
FROM Orders
INNER JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
order by OrderID asc

--Answer Question 30
--There are some customers who have never actually placed an order
-- Show these customers

Select Customers.CustomerID as Customers_CustomerID,Orders.CustomerID as Orders_CustomerID
from Customers
left join Orders on Customers.CustomerID =Orders.CustomerID
where OrderID is Null
Order  by Customers_CustomerID Asc;

-- Answer Question 31

Select Customers.CustomerID as Customers_CustomerID,Orders.CustomerID as Orders_CustomerID
from Customers
left join Orders on Customers.CustomerID =Orders.CustomerID
and  Orders.EmployeeID =4
where OrderID is Null
Order  by Customers_CustomerID Asc;

--OR


Select CustomerID
FROM Customers
where CustomerID not in (select CustomerID from Orders where EmployeeID=4);

--select CustomerID from Orders where EmployeeID=4;

-- ADVANCED  PROBLEMS

--Answer Question 32

--Determine a list of High values customer with more than $ 10000 purchases

Select Customers.CustomerID, Customers.CompanyName,Orders.OrderID, TotalOrderAmount=SUM(Quantity*UnitPrice)
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' AND  '20170101'
Group by 
Customers.CustomerID,
Customers.CompanyName,
Orders.OrderID
having Sum (unitPrice*Quantity)> 10000
Order by TotalOrderAmount DESC;

--Answer Question 33
--Determine a list of High values customer with more than $ 15000 purchases


Select Customers.CustomerID,Customers.CompanyName, TotalOrderAmount=SUM(Quantity*UnitPrice)
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' AND  '20170101'
Group by 
Customers.CompanyName,
 Customers.CustomerID
having Sum (unitPrice*Quantity)> 15000
Order by TotalOrderAmount DESC;


--Answer Question 34

Select Customers.CustomerID,Customers.CompanyName, TotalOrderAmount=SUM(Quantity*UnitPrice),Sum(Quantity *UnitPrice*(1-Discount)) As TotalAmountwithDiscount
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' AND  '20170101'
Group by 
Customers.CompanyName,
 Customers.CustomerID
having Sum (unitPrice*Quantity*(1-Discount))> 15000
Order by TotalAmountwithDiscount DESC;

--Answer Question 35

Select EmployeeID,OrderID ,OrderDate 
from Orders
Where OrderDate=EOMONTH(OrderDate)
order by EmployeeID ASC;

--Answer Question 36

Select  TOP 10  OrderID,COUNT(OrderID) As TotalOrderDetails
from OrderDetails
Group By OrderID
ORDER BY TotalOrderDetails DESC;

-- Answer Question 37

SELECT TOP 27 OrderID 
FROM Orders
ORDER BY NEWID();

--Answer Question 38

Select OrderID
from OrderDetails
where Quantity >=60 
group by OrderID,
Quantity
Having Count(*)>1
order by OrderID;

-- Answer Question 39

With moredetails  as
(Select OrderID AS OrderID1
from OrderDetails
where Quantity >=60 
group by OrderID,
Quantity
Having Count(*)>1) 
Select Distinct OrderID,ProductID,UnitPrice,Quantity,Discount FROM  moredetails
JOIN OrderDetails
on OrderDetails.OrderID=moredetails.OrderID1
ORDER BY OrderID, Quantity

--Answer Question 40
Select distinct OrderDetails.OrderID,
ProductID,
UnitPrice,
Quantity,
Discount from OrderDetails
JOIN
(Select OrderID
from OrderDetails
where Quantity>=60
Group By OrderID,
Quantity Having Count(*)>1)
PotentialProblemOrders
on PotentialProblemOrders.OrderID=OrderDetails.OrderID
order by OrderID,ProductID

--Answer Question 41

Select OrderID,
Cast(OrderDate as Date) as OrderDate,
Cast(RequiredDate as Date) as RequiredDate,
Cast(ShippedDate as date) as ShippedDate
from Orders
Where RequiredDate <= ShippedDate
Order by OrderID;

--Answer Question 42

Select distinct Employees.EmployeeID,
LastName,
COUNT(Employees.EmployeeID) AS TotalOrderLate
from Employees
join Orders on Employees.EmployeeID=Orders.EmployeeID
Where RequiredDate <= ShippedDate
Group By Employees.EmployeeID , LastName
Order by TotalOrderLate desc;

--Answer Question 43

WITH Late_Orders as
(Select EmployeeID,
Count(*) as LateOrders
FROM Orders
where RequiredDate<=ShippedDate
GROUP BY EmployeeID),
Total_Orders as
(Select EmployeeID,TotalOrders=COUNT(*)
FROM Orders 
group by EmployeeID),
Last_Name as
(Select EmployeeID,LastName from Employees)

Select Late_Orders.EmployeeID,LastName,TotalOrders,LateOrders from Late_Orders
JOIN Total_Orders ON Late_Orders.EmployeeID=Total_Orders.EmployeeID
JOIN Last_Name on Late_Orders.EmployeeID=Last_Name.EmployeeID
order by Late_Orders.EmployeeID ;

--Answer Question 44

WITH Late_Orders as
(Select EmployeeID,
Count(*) as LateOrders
FROM Orders
where RequiredDate<=ShippedDate
GROUP BY EmployeeID),
Total_Orders as
(Select EmployeeID,TotalOrders=COUNT(*)
FROM Orders 
group by EmployeeID),
Last_Name as
(Select EmployeeID,LastName from Employees)

Select Last_Name.EmployeeID,LastName,TotalOrders,LateOrders from Total_Orders
left JOIN Late_Orders ON Late_Orders.EmployeeID=Total_Orders.EmployeeID
 left JOIN Last_Name on Total_Orders.EmployeeID=Last_Name.EmployeeID
order by Last_Name.EmployeeID ;

-- Answer Question 45

WITH Late_Orders as
(Select EmployeeID,
Count(*) as LateOrders
FROM Orders
where RequiredDate<=ShippedDate
GROUP BY EmployeeID),
Total_Orders as
(Select EmployeeID,TotalOrders=COUNT(*)
FROM Orders 
group by EmployeeID),
Last_Name as
(Select EmployeeID,LastName from Employees)

Select Last_Name.EmployeeID,LastName,TotalOrders,LateOrders=ISNULL(LateOrders,0) from Total_Orders
left JOIN Late_Orders ON Late_Orders.EmployeeID=Total_Orders.EmployeeID
 left JOIN Last_Name on Total_Orders.EmployeeID=Last_Name.EmployeeID
order by Last_Name.EmployeeID ;

--Answer Question 46

WITH Late_Orders as
(Select EmployeeID,
Count(*) as LateOrders
FROM Orders
where RequiredDate<=ShippedDate
GROUP BY EmployeeID),
Total_Orders as
(Select EmployeeID,TotalOrders=COUNT(*)
FROM Orders 
group by EmployeeID),
Last_Name as
(Select EmployeeID,LastName from Employees)

Select Last_Name.EmployeeID,LastName,TotalOrders,LateOrders=ISNULL(LateOrders,0),(ISNULL (LateOrders,0)*1.00)/TotalOrders as Percentage_late_ORDERS from Total_Orders
left JOIN Late_Orders ON Late_Orders.EmployeeID=Total_Orders.EmployeeID
 left JOIN Last_Name on Total_Orders.EmployeeID=Last_Name.EmployeeID
order by Last_Name.EmployeeID ;

--Answer Question 47

WITH Late_Orders as
(Select EmployeeID,
Count(*) as LateOrders
FROM Orders
where RequiredDate<=ShippedDate
GROUP BY EmployeeID),
Total_Orders as
(Select EmployeeID,TotalOrders=COUNT(*)
FROM Orders 
group by EmployeeID),
Last_Name as
(Select EmployeeID,LastName from Employees)

Select Last_Name.EmployeeID,LastName,TotalOrders,LateOrders=ISNULL(LateOrders,0),Convert(Decimal(2,2),((ISNULL (LateOrders,0)*1.00)/TotalOrders)) as Percentage_late_ORDERS from Total_Orders
left JOIN Late_Orders ON Late_Orders.EmployeeID=Total_Orders.EmployeeID
 left JOIN Last_Name on Total_Orders.EmployeeID=Last_Name.EmployeeID
order by Last_Name.EmployeeID ;

-- Answer  Question 48 and Question 49

Select Customers.CustomerID ,CompanyName, Sum(Quantity*UnitPrice) as TotalAmount, "Customer_Group" =
CASE 
  WHEN Sum(Quantity*UnitPrice) > 0 and  Sum(Quantity*UnitPrice) < 1000  THEN 'LOW'
  WHEN  Sum(Quantity*UnitPrice) > 1000 and  Sum(Quantity*UnitPrice) < 5000 THEN 'Medium'
  WHEN  Sum(Quantity*UnitPrice) > 5000 and  Sum(Quantity*UnitPrice) < 10000 THEN 'High'
  ELSE 'VERY HIGH'
  END
from Customers
join Orders on Customers.CustomerID=Orders.CustomerID
join OrderDetails ON  Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' and '20161231'

group by Customers.CustomerID,
Customers.CompanyName

Order by TotalAmount desc 

--Alternative 


WIth OrderCTE as(
Select Customers.CustomerID ,Customers.CompanyName, Sum(Quantity*UnitPrice) as TotalAmount, "Customer_Group" =
CASE 
  WHEN Sum(Quantity*UnitPrice) > 0 and  Sum(Quantity*UnitPrice) < 1000  THEN 'LOW'
  WHEN  Sum(Quantity*UnitPrice) > 1000 and  Sum(Quantity*UnitPrice) < 5000 THEN 'Medium'
  WHEN  Sum(Quantity*UnitPrice) > 5000 and  Sum(Quantity*UnitPrice) < 10000 THEN 'High'
  ELSE 'VERY HIGH'
  END
from Customers
join Orders on Customers.CustomerID=Orders.CustomerID
join OrderDetails ON  Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' and '20161231'

group by Customers.CustomerID,
Customers.CompanyName)

select customerID,CompanyName,TotalAmount,Customer_Group
from OrderCTE
Order by CustomerID desc

--
--Answer Question 50 

WIth CustomerGroupPercentageCTE as(
Select Customers.CustomerID , Sum(Quantity*UnitPrice) as TotalAmount, COUNT(Customers.CustomerID) as total,"Customer_Group" =
CASE 
  WHEN Sum(Quantity*UnitPrice) > 0 and  Sum(Quantity*UnitPrice) < 1000  THEN 'LOW'
  WHEN  Sum(Quantity*UnitPrice) > 1000 and  Sum(Quantity*UnitPrice) < 5000 THEN 'Medium'
  WHEN  Sum(Quantity*UnitPrice) > 5000 and  Sum(Quantity*UnitPrice) < 10000 THEN 'High'
  ELSE 'VERY HIGH'
  END
from Customers
join Orders on Customers.CustomerID=Orders.CustomerID
join OrderDetails ON  Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' and '20161231'

group by Customers.CustomerID,
Customers.CompanyName)

select Customer_Group,Count(Customer_Group) as TotalInGroup
from CustomerGroupPercentageCTE
group by Customer_Group
Order by TotalInGroup desc


--WIth CustomerGroupPercentageCTE as(
--Select Customers.CustomerID , Sum(Quantity*UnitPrice) as TotalAmount, COUNT(Customers.CustomerID) as total,"Customer_Group" =
--CASE 
--  WHEN Sum(Quantity*UnitPrice) > 0 and  Sum(Quantity*UnitPrice) < 1000  THEN 'LOW'
--  WHEN  Sum(Quantity*UnitPrice) > 1000 and  Sum(Quantity*UnitPrice) < 5000 THEN 'Medium'
--  WHEN  Sum(Quantity*UnitPrice) > 5000 and  Sum(Quantity*UnitPrice) < 10000 THEN 'High'
--  ELSE 'VERY HIGH'
--  END
--from Customers
--join Orders on Customers.CustomerID=Orders.CustomerID
--join OrderDetails ON  Orders.OrderID=OrderDetails.OrderID
--where OrderDate Between '20160101' and '20161231'

--group by Customers.CustomerID,
--Customers.CompanyName),

--  (Select Count('OrderID')
--from OrderDetails
--join Orders on Orders.OrderID=OrderDetails.OrderID
--where OrderDate Between '20160101' and '20161231'
--group by OrderDetails.OrderID)


-- Answer Question 51
Select Customers.CustomerID , Customers.CompanyName, Sum(Quantity*UnitPrice) as TotalAmount,"Customer_Group" =
CASE 
  WHEN Sum(Quantity*UnitPrice) > 0 and  Sum(Quantity*UnitPrice) < 1000  THEN 'LOW'
  WHEN  Sum(Quantity*UnitPrice) > 1000 and  Sum(Quantity*UnitPrice) < 5000 THEN 'Medium'
  WHEN  Sum(Quantity*UnitPrice) > 5000 and  Sum(Quantity*UnitPrice) < 10000 THEN 'High'
  ELSE 'VERY HIGH'
  END
from Customers
join Orders on Customers.CustomerID=Orders.CustomerID
join OrderDetails ON  Orders.OrderID=OrderDetails.OrderID
where OrderDate Between '20160101' and '20161231'

group by Customers.CustomerID,
Customers.CompanyName

--Answer Question 52

Select Country 
from Suppliers
Union
Select Country 
from Customers

--Answer Question 53

; With SupplierCountries_CTE as (Select Distinct Country from Suppliers)
,
CustomerCountries_CTE as (select Distinct Country from Customers)

select SupplierCountries_CTE.Country as SupplierCountry,CustomerCountries_CTE.Country as CustomerCountry
     
	 from SupplierCountries_CTE
	 full outer join CustomerCountries_CTE on CustomerCountries_CTE.Country=SupplierCountries_CTE.Country

-- Answer Question 54

; With SupplierCountries_CTE as (Select Distinct Country,count(SupplierID) as TotalS   from Suppliers group by Country)
,
CustomerCountries_CTE as (select Distinct Country,count(*) as TotalC from Customers group by Country)

select Country=isnull(SupplierCountries_CTE.Country,CustomerCountries_CTE.Country),
     TotalSupplier=ISNULL(TotalS,0),TotalCustomer =ISNULL(TotalC,0)
	 from SupplierCountries_CTE
	 full outer join CustomerCountries_CTE on CustomerCountries_CTE.Country=SupplierCountries_CTE.Country

	 Select ShipCountry,CustomerID,OrderID, Cast(OrderDate as Date) as OrderDate,
	 ROW_NUMBER() over( order by ShipCountry) rowNumber 
	 from Orders
	 order by ShipCountry,
	 OrderID

	  Select ShipCountry,CustomerID,OrderID, Cast(OrderDate as Date) as OrderDate, 
	  Row_Number() over( Partition by ShipCountry order by OrderID ) rowNumber
	 from Orders
	 order by ShipCountry,
	 OrderID

--Answer Question 55

	 ; With Firstorder_CET1 AS  (Select ShipCountry,CustomerID,OrderID, Cast(OrderDate as Date) as OrderDate,
	 ROW_NUMBER() over(  Partition by ShipCountry order by OrderID) rowNumber 
	 from Orders
	 )

	 Select Firstorder_CET1.ShipCountry,  Firstorder_CET1.CustomerID, Firstorder_CET1.OrderID,Firstorder_CET1.OrderDate
	 from Firstorder_CET1
	 where Firstorder_CET1.rowNumber=1
	 order by ShipCountry


--Select CustomerID,OrderID, Cast(OrderDate as Date) as OrderDate
	-- from Orders
	 --where ;
	 
	 
Select CustomerID, Min(Cast(OrderDate as Date))as InitialDate
	 from Orders
	 group by CustomerID



Select CustomerID, Min(Cast(OrderDate as Date))as InitialDate
	 from Orders
	 group by CustomerID	 