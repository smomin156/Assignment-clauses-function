--Table: Customers
SELECT * FROM CUSTOMERS
--1. Display the “Company Name” and “Contact Name” from Customers table
SELECT COMPANYNAME,CONTACTNAME FROM CUSTOMERS
--2. Find the Customers who are staying wither in USA, UK, Germany, France
SELECT * FROM CUSTOMERS WHERE COUNTRY IN('USA','GERMANY','FRANCE','UK')
--3. Find the Customers whose “Company Name” starts with G
SELECT * FROM CUSTOMERS WHERE COMPANYNAME LIKE 'G%'
--4. List all the Customers who are located in Paris
SELECT * FROM CUSTOMERS WHERE CITY='PARIS'
--5. List the Customer details whose postal code start with 4
SELECT * FROM CUSTOMERS WHERE POSTALCODE LIKE '4%'
--6. List all the Customers who neither stay in Canada nor in Brazil
SELECT * FROM CUSTOMERS WHERE COUNTRY NOT IN('CANADA','BRAZIL')
--7. Print total number of Customers for each country.
SELECT COUNTRY,COUNT(CUSTOMERID)AS CUSTOMERCOUNT FROM CUSTOMERS GROUP BY COUNTRY
--8. List Customers detail based on Country and City
SELECT * FROM CUSTOMERS ORDER BY COUNTRY,CITY
--9. List all the manager from the Customers table
SELECT * FROM CUSTOMERS WHERE CONTACTTITLE LIKE '%MANAGER%'
--10. List all Customers details where “company name” contains aphostophy (‘)
SELECT * FROM CUSTOMERS WHERE COMPANYNAME LIKE '%[\'']%'


--Table: Products
SELECT * FROM PRODUCTS
--11. List all the products for CategoryID 4 and UnitsInStock is more then 50
SELECT * FROM PRODUCTS WHERE CATEGORYID=4 AND UNITSINSTOCK>50
--12. List ProductName, UnitPrice, UnitsInStock, NetStock (i.e. UnitPrice * UnitsInStock)
SELECT PRODUCTNAME,UNITPRICE,UNITSINSTOCK,(UNITPRICE*UNITSINSTOCK) AS NETSTOCK FROM PRODUCTS
--13. List Maximum and Minimum UnitPrice
SELECT MIN(UNITPRICE)AS MINPRICE,MAX(UNITPRICE)AS MAXPRICE FROM PRODUCTS
--14. Count the number of products whose UnitPrice is more then 50
SELECT COUNT(PRODUCTID)FROM PRODUCTS WHERE UNITPRICE>50
--15. List product count base on CategoryID. List the data where count is more then 10
SELECT CATEGORYID,COUNT(PRODUCTID)AS PRODUCTCOUNT FROM PRODUCTS GROUP BY CATEGORYID HAVING COUNT(PRODUCTID)>10
--16. Find all the products where UnitsInStock in less than Reorder Level
SELECT * FROM PRODUCTS WHERE UNITSINSTOCK < REORDERLEVEL
--17. List Category wise, Supplier wise product count
SELECT CATEGORYID,SUPPLIERID,COUNT(PRODUCTID)AS CATEGORYCOUNT FROM PRODUCTS GROUP BY CATEGORYID,SUPPLIERID
--18. All Products whose UnitsInStock is less than 5 units are entitles for placing order by 50 units for
--others place the order by 30 units. Display ProductID, ProductName, UnitsInStock,
--OrderedUnits.
SELECT PRODUCTID,PRODUCTNAME,UNITSINSTOCK,CASE 
											WHEN UNITSINSTOCK<5 THEN 50
											ELSE 30
											END AS ORDEREDUNITS
FROM PRODUCTS
--19. List 3 costliest product
SELECT TOP 3 * FROM PRODUCTS ORDER BY UNITPRICE DESC
--20. List all the products whose CategoryID is 1 and SupplierID is either 10 or 12 or CategoryID is 4
--and SupplierID is either 14 or 15.SELECT * FROM PRODUCTS WHERE (CATEGORYID=1 AND SUPPLIERID IN (10,12)) OR (CATEGORYID=4 AND SUPPLIERID IN(14,15))--Table: Orders
SELECT * FROM ORDERS
--21. List all the orders placed in month of February
SELECT * FROM ORDERS WHERE DATENAME(MM,ORDERDATE)='FEBRUARY'
--22. List year wise order count
SELECT DATEPART(YYYY,ORDERDATE)AS ORDERYEAR,COUNT(ORDERID) FROM ORDERS GROUP BY DATEPART(YYYY,ORDERDATE)
--23. List the ShipCountry for which total order placed is more than 100
--Example
--ShipCountry OrderCount
--USA 122
SELECT SHIPCOUNTRY,COUNT(ORDERID) AS ORDERCOUNT FROM ORDERS 
GROUP BY(SHIPCOUNTRY)HAVING COUNT(ORDERID)>100
--24. List the data as per the order month (Jan – Dec)
SELECT DATENAME(MM,ORDERDATE)AS ORDERMONTH,* FROM ORDERS ORDER BY DATEPART(MM,ORDERDATE)
--25. List unique country name in ascending order where product is shipped
SELECT DISTINCT SHIPCOUNTRY ,COUNT(ORDERID)AS ORDERCOUNT FROM ORDERS GROUP BY SHIPCOUNTRY ORDER BY SHIPCOUNTRY
--26. List CustomerID, ShipCity, ShipCountry, ShipRegion from Ordrs table. If ShipRegion is null than
--display message as “No Region”
SELECT CUSTOMERID,SHIPCITY,SHIPCOUNTRY,ISNULL(SHIPREGION,'NO REGION')AS SHIPREGION FROM ORDERS
--27. List the detail of first order placed
SELECT * FROM ORDERS ORDER BY ORDERDATE OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY
--28. List Customer wise, Year wise (Order date) order placed
--Example
--CustomerID Year OrderCount
--ANATR 1996 1
--BONAP 1997 8
SELECT CUSTOMERID,DATEPART(YYYY,ORDERDATE)AS YEAR,COUNT(ORDERID) AS COUNT FROM ORDERS GROUP BY CUSTOMERID,ORDERDATE 
--29. List all the orders handled by employeeid 4 for the month of December
SELECT * FROM ORDERS WHERE EMPLOYEEID=4 AND DATENAME(MM,ORDERDATE)='DECEMBER'
--30. List employee wise , year wise, month wise ordercountSELECT EMPLOYEEID,DATEPART(YYYY,ORDERDATE)AS YEAR ,DATEPART(MM,ORDERDATE)AS MONTH,COUNT(ORDERID)AS COUNT FROM ORDERS GROUP BY EMPLOYEEID,DATEPART(YYYY,ORDERDATE),DATEPART(MM,ORDERDATE)--Table: [Order Details]
--31. List all the data of [Order Details] table
SELECT * FROM [ORDER DETAILS]
--32. List ProductID, UnitPrice, Qty and Total. Sort data on Total column with highest value on top
SELECT PRODUCTID,UNITPRICE,QUANTITY,(UNITPRICE*QUANTITY)AS TOTAL FROM [ORDER DETAILS] ORDER BY TOTAL DESC
--33. In above query,
--If Total is more than 10000 display 10% discount on Total cost
--If Total is more than 5000 display 5% discount on Total cost
--If Total is more than 3000 display 2% discount on Total cost
--else Rs. 300 as discount if total is more than 1000
--No discount for Total less than 1000
SELECT PRODUCTID,UNITPRICE,QUANTITY,(UNITPRICE*QUANTITY)AS TOTAL,CASE
																WHEN (UNITPRICE*QUANTITY)>10000 THEN (0.1*(UNITPRICE*QUANTITY))
																WHEN (UNITPRICE*QUANTITY)>5000 THEN (0.5*(UNITPRICE*QUANTITY))
																WHEN (UNITPRICE*QUANTITY)>3000 THEN (0.2*(UNITPRICE*QUANTITY))
																WHEN (UNITPRICE*QUANTITY)>1000 THEN ((UNITPRICE*QUANTITY)-300)
																ELSE (UNITPRICE*QUANTITY)
																END AS [DISCOUNTED PRICE]FROM [ORDER DETAILS]
																ORDER BY TOTAL DESC
																 
--34. List Total order placed for each OrderId
SELECT ORDERID ,COUNT(ORDERID)AS [NUMBER OF ORDER PLACED] FROM [ORDER DETAILS]GROUP BY ORDERID
--35. List minimum cost and maximum cost order value
SELECT MIN(UNITPRICE)AS MINPRICE,MAX(UNITPRICE)AS MAXPRICE FROM[ORDER DETAILS]