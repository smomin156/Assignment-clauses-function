--1. Single table retrieval
--1) Find out the names of all the clients.
SELECT NAME FROM CLIENT_MASTER

--2) Print the entire client_master table.
SELECT * FROM CLIENT_MASTER

--3) Retrieve the list of names and the cities of all the clients
SELECT NAME,CITY FROM CLIENT_MASTER

--4) List the various products available from the product_master table.
SELECT DESCRIPTION FROM PRODUCT_MASTER

--5) Find the names of all clients having ‘a’ as the second letter in their
--table.
SELECT NAME FROM CLIENT_MASTER WHERE NAME LIKE '_A%'

--6) Find the names of all clients who stay in a city whose second letter is
--‘a’
SELECT CITY FROM CLIENT_MASTER WHERE CITY LIKE '_A%'

--7) Find out the clients who stay in a city ‘Bombay’ or city ‘Delhi’ or city
--‘Madras’.
SELECT * FROM CLIENT_MASTER WHERE CITY IN('BOMBAY','DELHI','MADRAS')

--8) List all the clients who are located in Bombay.
SELECT * FROM CLIENT_MASTER WHERE CITY='BOMBAY'

--9) Print the list of clients whose bal_due are greater than value 10000
SELECT * FROM CLIENT_MASTER WHERE BAL_DUE>10000

--10) Print the information from sales_order table of orders placed
--in the month of January.
SELECT * FROM SALES_ORDER WHERE DATEPART(MM,S_ORDER_DATE)=01

--11) Display the order information for client_no ‘C00001’ and
--‘C00002’
SELECT * FROM SALES_ORDER WHERE CLIENT_NO IN('C00001','C00002')

--12) Find the products with description as ‘1.44 Drive’ and ‘1.22
--Drive’
SELECT * FROM PRODUCT_MASTER WHERE DESCRIPTION IN('1.44 Drive','1.22 DRIVE')

--13) Find the products whose selling price is greater than 2000 and
--less than or equal to 5000
SELECT * FROM PRODUCT_MASTER WHERE SELL_PRICE BETWEEN 2000 AND 5000

--14) Find the products whose selling price is more than 1500 and
--also find the new selling price as original selling price * 15
SELECT *,(SELL_PRICE*15)AS NEWSELLPRICE FROM PRODUCT_MASTER WHERE SELL_PRICE>1500

--15) Rename the new column in the above query as new_price
SELECT *,(SELL_PRICE*15)AS NEW_PRICE FROM PRODUCT_MASTER WHERE SELL_PRICE>1500

--16) Find the products whose cost price is less than 1500
SELECT * FROM PRODUCT_MASTER WHERE COST_PRICE<1500

--17) List the products in sorted order of their description.
SELECT * FROM PRODUCT_MASTER ORDER BY DESCRIPTION

--18) Calculate the square root the price of each product.
SELECT SELL_PRICE,(SQRT(SELL_PRICE))AS SQRT FROM PRODUCT_MASTER

--19) Divide the cost of product ‘540 HDD’ by difference between its
--price and 100
SELECT (COST_PRICE/(SELL_PRICE-100)) FROM PRODUCT_MASTER WHERE DESCRIPTION='540 HDD'

--20) List the names, city and state of clients not in the state of
--Maharashtra
SELECT NAME,CITY,STATE FROM CLIENT_MASTER WHERE STATE !='MAHARASHTRA'

--21) List the product_no, description, sell_price of products whose
--description begin with letter ‘M’
SELECT PRODUCT_NO,DESCRIPTION,SELL_PRICE FROM PRODUCT_MASTER WHERE DESCRIPTION LIKE 'M%'

--22) List all the orders that were canceled in the month of May.
SELECT * FROM SALES_ORDER WHERE ORDER_STATUS='CANCELLED'
-------------------------------------------------------------------------------------------------------------

--2. Set Functions and Concatenation :
--23) Count the total numeric of orders.
SELECT COUNT(S_ORDER_NO)AS ORDER_COUNT FROM SALES_ORDER

--24) Calculate the average price of all the products.
SELECT AVG(SELL_PRICE)AS AVG_PRICE FROM PRODUCT_MASTER

--25) Calculate the minimum price of products.
SELECT MIN(SELL_PRICE)FROM PRODUCT_MASTER

--26) Determine the maximum and minimum product prices.
--Rename the title as max_price and min_price respectively.
SELECT MIN(SELL_PRICE)AS MIN_PRICE,MAX(SELL_PRICE)AS MAX_PRICE FROM PRODUCT_MASTER

--27) Count the numeric of products having price greater than or
--equal to 1500.
SELECT COUNT(PRODUCT_NO)AS COUNT FROM PRODUCT_MASTER WHERE SELL_PRICE >=1500

--28) Find all the products whose qty_on_hand is less than reorder
--level.
SELECT * FROM PRODUCT_MASTER WHERE QTY_ON_HAND<RECORDER_LVL

--29) Print the information of client_master, product_master,sales_order table in the following formate for all the records
--{cust_name} has placed order {order_no} on {s_order_date}.
SELECT C.NAME+' HAS PLACED ORDER '+CAST(S.S_ORDER_NO AS VARCHAR)+' ON '+CAST(S.S_ORDER_DATE AS VARCHAR) FROM CLIENT_MASTER C JOIN SALES_ORDER S ON C.CLIENT_NO=S.CLIENT_NO 

--------------------------------------------------------------------------------------------------------------------------------------------
--3. Having and Group by:
--30) Print the description and total qty sold for each product.
SELECT P.DESCRIPTION,SUM(S.QTY_ORDERED)AS[QUANTITY ORDERED] FROM PRODUCT_MASTER P JOIN SALES_ORDER_DETAILS S ON P.PRODUCT_NO=S.PRODUCT_NO GROUP BY S.PRODUCT_NO,P.DESCRIPTION

--31) Find the value of each product sold.
SELECT PRODUCT_NO,SUM(PRODUCT_RATE) FROM SALES_ORDER_DETAILS GROUP BY PRODUCT_NO

--32) Calculate the average qty sold for each client that has a
--maximum order value of 15000.00
SELECT PRODUCT_NO,AVG(QTY_ORDERED)FROM SALES_ORDER_DETAILS GROUP BY PRODUCT_NO HAVING SUM(PRODUCT_RATE) >15000

--33) Find out the total sales amount receivable for the month of jan. it will be the sum total of all the billed orders for the month.
SELECT COUNT(D.PRODUCT_RATE)AS [JAN SALES] FROM SALES_ORDER_DETAILS D JOIN SALES_ORDER S ON D.S_ORDER_NO=D.S_ORDER_NO GROUP BY YEAR(S.S_ORDER_DATE)

--34) Print the information of product_master, order_detail table in the following format for all the records {Description} worth Rs. {Total sales for the product} was sold.
SELECT P.DESCRIPTION+' WORTH RS '+CAST(SUM(O.PRODUCT_RATE) AS VARCHAR) +' WAS SOLD'
FROM SALES_ORDER_DETAILS O JOIN PRODUCT_MASTER P ON P.PRODUCT_NO=O.PRODUCT_NO GROUP BY P.DESCRIPTION

--35) Print the information of product_master, order_detail table in
--the following format for all the records
--{Description} worth Rs. {Total sales for the product} was produced in
--the month of {s_order_date} in month formate.
SELECT P.DESCRIPTION+' WORTH RS '+CAST(SUM(O.PRODUCT_RATE) AS VARCHAR) +' WAS PRODUCED IN THE MONTH OF '+DATENAME(MM,S.S_ORDER_DATE)
FROM SALES_ORDER_DETAILS O JOIN PRODUCT_MASTER P ON P.PRODUCT_NO=O.PRODUCT_NO 
JOIN SALES_ORDER S ON S.S_ORDER_NO=O.S_ORDER_NO
GROUP BY P.DESCRIPTION,S.S_ORDER_DATE

------------------------------------------------------------------------------------------------------------------------------------------------
--4. Joins and Correlation :
--36) Find out the products which has been sold to ‘Ivan Bayross’
SELECT P.DESCRIPTION AS PRODUCTS_SOLD FROM CLIENT_MASTER C 
JOIN SALES_ORDER S ON C.CLIENT_NO=S.CLIENT_NO
JOIN SALES_ORDER_DETAILS O ON O.S_ORDER_NO=S.S_ORDER_NO
JOIN PRODUCT_MASTER P ON O.PRODUCT_NO=P.PRODUCT_NO
WHERE C.NAME='IVAN BAYROSS'

--37) Find out the products and their quantities that will have to
--deliver in the current month.
SELECT P.DESCRIPTION,COUNT(O.QTY_ORDERED) FROM SALES_ORDER_DETAILS O 
JOIN SALES_ORDER S ON O.S_ORDER_NO=S.S_ORDER_NO
JOIN PRODUCT_MASTER P ON O.PRODUCT_NO=P.PRODUCT_NO
WHERE MONTH(S.DELY_DATE)=MONTH(GETDATE())
GROUP BY P.DESCRIPTION

--38) Find the product_no and description of moving products.
SELECT P.PRODUCT_NO,P.DESCRIPTION FROM SALES_ORDER_DETAILS O 
JOIN SALES_ORDER S ON O.S_ORDER_NO=S.S_ORDER_NO
JOIN PRODUCT_MASTER P ON O.PRODUCT_NO=P.PRODUCT_NO
WHERE S.ORDER_STATUS='IN PROCESS'

--39) Find the names of clients who have purchased ‘CD Drive’
SELECT C.NAME FROM CLIENT_MASTER C 
JOIN SALES_ORDER S ON C.CLIENT_NO=S.CLIENT_NO
JOIN SALES_ORDER_DETAILS O ON O.S_ORDER_NO=S.S_ORDER_NO
JOIN PRODUCT_MASTER P ON O.PRODUCT_NO=P.PRODUCT_NO
WHERE P.DESCRIPTION='CD DRIVE'

--40) List the product_no and s_order_no of customers having qty_ordered less than 5 from the order details table for the product
--‘1.44 floppies’
SELECT P.PRODUCT_NO,O.S_ORDER_NO,SUM(O.QTY_ORDERED) FROM PRODUCT_MASTER P 
JOIN SALES_ORDER_DETAILS O ON P.PRODUCT_NO=O.PRODUCT_NO
GROUP BY P.PRODUCT_NO,O.S_ORDER_NO
HAVING SUM(O.QTY_ORDERED)<5

--41) Find the products and their quantities for the orders placed by
--‘Vandana Saitwal’ and ‘Ivan Bayross’
SELECT P.DESCRIPTION,SUM(O.QTY_ORDERED) AS QUANTITY_SOLD FROM CLIENT_MASTER C 
JOIN SALES_ORDER S ON C.CLIENT_NO=S.CLIENT_NO
JOIN SALES_ORDER_DETAILS O ON O.S_ORDER_NO=S.S_ORDER_NO
JOIN PRODUCT_MASTER P ON O.PRODUCT_NO=P.PRODUCT_NO
WHERE C.NAME IN('IVAN BAYROSS','VANDANA SAITWAL')
GROUP BY P.DESCRIPTION

--42) Find the products and their quantities for the orders placed by
--client_no ‘C00001’ and ‘C00002’
SELECT P.DESCRIPTION,SUM(O.QTY_ORDERED) AS QUANTITY_SOLD FROM CLIENT_MASTER C 
JOIN SALES_ORDER S ON C.CLIENT_NO=S.CLIENT_NO
JOIN SALES_ORDER_DETAILS O ON O.S_ORDER_NO=S.S_ORDER_NO
JOIN PRODUCT_MASTER P ON O.PRODUCT_NO=P.PRODUCT_NO
WHERE C.CLIENT_NO IN('C00001','C00002')
GROUP BY P.DESCRIPTION

--------------------------------------------------------------------------------------------------------------------
--5. Nested Queries :
--43) Find the product_no and description of non-moving products.
SELECT PRODUCT_NO,DESCRIPTION FROM PRODUCT_MASTER WHERE PRODUCT_NO IN(
SELECT PRODUCT_NO FROM SALES_ORDER_DETAILS WHERE S_ORDER_NO IN(
SELECT S_ORDER_NO FROM SALES_ORDER WHERE ORDER_STATUS !='FILFILLED'))

--44) Find the customer name, address1, address2, city and pin code
--for the client who has placed order no ‘O19001’
SELECT NAME,CITY,PINCODE FROM CLIENT_MASTER WHERE CLIENT_NO IN(
SELECT CLIENT_NO FROM SALES_ORDER WHERE S_ORDER_NO='O19001')

--45) Find the client names who have placed orders before the
--month of May, 1996
SELECT NAME FROM CLIENT_MASTER WHERE CLIENT_NO IN(
SELECT CLIENT_NO FROM SALES_ORDER WHERE MONTH(S_ORDER_DATE)<5 AND YEAR(S_ORDER_DATE)<=1996)

--46) Find out if product ‘1.44 Drive’ is ordered by client and print
--the client_no, name to whom it is was sold.
SELECT CLIENT_NO,NAME FROM CLIENT_MASTER WHERE CLIENT_NO IN(
SELECT CLIENT_NO FROM SALES_ORDER WHERE S_ORDER_NO IN(
SELECT S_ORDER_NO FROM SALES_ORDER_DETAILS WHERE PRODUCT_NO IN(
SELECT PRODUCT_NO FROM PRODUCT_MASTER WHERE DESCRIPTION='1.44 DRIVE')))

--47) Find the names of clients who have placed orders worth Rs.
--10000 or more.
SELECT CLIENT_NO,NAME FROM CLIENT_MASTER WHERE CLIENT_NO IN(
SELECT CLIENT_NO FROM SALES_ORDER WHERE S_ORDER_NO IN(
SELECT S_ORDER_NO FROM SALES_ORDER_DETAILS WHERE (QTY_ORDERED*PRODUCT_RATE)>=10000 ))

------------------------------------------------------------------------------------
--6. Queries using Date:
--48) Display the order numeric and day on which clients placed
--their order.
SELECT DATEPART(DD,S_ORDER_DATE)AS DATE,DATENAME(WEEKDAY,S_ORDER_DATE)AS DAY FROM SALES_ORDER

--49) Display the month (in alphabets) and date when the order
--must deliver.
SELECT DATENAME(MM,DELY_DATE)AS MONTH,DATEPART(DD,DELY_DATE)AS DATE FROM SALES_ORDER

--50) Display the s_order_date in the format. E.g. 12-February-1996
SELECT CONVERT(VARCHAR,S_ORDER_DATE,106) FROM SALES_ORDER

--51) Find the date, 15 days after today’s date.
SELECT DATEADD(DD,15,GETDATE())

--52) Find the numeric of days elapsed between today’s date and
--the delivery date of the orders placed by the clients.
SELECT DATEDIFF(DD,DELY_DATE,GETDATE())AS DATE_DIFFERENCE FROM SALES_ORDER

-------------------------------------------------------------------------------------------
--7. Misc (Rank, Case)
--53. In sales ordered detail table as per the quantity ordered highest to
--lowest assign the rank. Don’t miss any numeric
SELECT DENSE_RANK() OVER(ORDER BY QTY_ORDERED DESC),QTY_ORDERED FROM SALES_ORDER_DETAILS

--54.Display product master record along with record no
SELECT ROW_NUMBER()OVER(ORDER BY PRODUCT_NO)AS ROW_NUMBER,* FROM PRODUCT_MASTER

--55.For sales ordered detail table assign row numeric for each s_order_no.
SELECT ROW_NUMBER()OVER (ORDER BY S_ORDER_NO)AS ROW_NUMBER,* FROM SALES_ORDER_DETAILS

--56.Print s_order_no, qty ordered, qty disp, and difference. Also display message if difference is 0 print all qty dispatched , if difference is <=5
--few qty left to dispatched, else display difference is high
SELECT S_ORDER_NO,QTY_ORDERED,QTY_DISP,(QTY_ORDERED-QTY_DISP)AS DIFFERENCE,
CASE WHEN (QTY_ORDERED-QTY_DISP)=0 THEN 'ALL QTY DISPATCHED'
	WHEN (QTY_ORDERED-QTY_DISP)<=5 THEN'FEW QTY TO BE DISPATCHED'
	ELSE 'DIFFERENCE IS HIGH'
	END AS MSG FROM SALES_ORDER_DETAILS
ORDER BY DIFFERENCE

--57. List salesman master detail along with rank as per the sal_amt
SELECT DENSE_RANK() OVER(ORDER BY SAL_AMT DESC)AS RANK,* FROM SALESMAN_MASTER

--------------------------------------------------------------------------------------------------
--8. Table Updations:
--58) Change the s_order_date of client_no ‘C00001’ to 24/07/96.
UPDATE SALES_ORDER SET S_ORDER_DATE='1996-07-24' WHERE CLIENT_NO='C00001'
SELECT * FROM SALES_ORDER

--59) Change the selling price of ‘1.44 Floppy Drive’ to Rs. 1150.00
UPDATE PRODUCT_MASTER SET SELL_PRICE=1150 WHERE DESCRIPTION='1.44 FLOPPIES'
SELECT * FROM PRODUCT_MASTER

--60) Delete the records with order numeric ‘O19001’ from the
--order table.
DELETE FROM SALES_ORDER WHERE S_ORDER_NO='019001'

--61) Delete all the records having delivery date before 10th July’96
DELETE FROM SALES_ORDER WHERE DELY_DATE<1996-07-10

--62) Change the city of client_no ‘C00005’ to ’Bombay’.
UPDATE CLIENT_MASTER SET CITY='BOMBAY' WHERE CLIENT_NO='C00005'

--63) Change the delivery date of order numeric ‘O10008” to
--16/08/96
UPDATE SALES_ORDER SET DELY_DATE='1996-08-16' WHERE S_ORDER_NO='O10008'

--64) Change the bal_due of client_no ‘C00001’ to 1000
UPDATE CLIENT_MASTER SET BAL_DUE=1000 WHERE CLIENT_NO='C00001'

--65) Change the cost price of ‘1.22 Floppy Drive’ to Rs. 950.00.
UPDATE PRODUCT_MASTER SET COST_PRICE=950 WHERE DESCRIPTION='1.22 FLOPPIES'

-----------------------------------------------------------------
--9. Views
--66.Create a read only view which will display Client name, city and
--balance due
CREATE VIEW CLIENT_VIEW	AS
SELECT NAME,CITY,BAL_DUE FROM CLIENT_MASTER


--67.Create a read only view which will display salesman name, city, sales
--amount, target to get
CREATE VIEW SALEMAN_VIEW AS
SELECT SALESMAN_NAME,CITY,SAL_AMT,TGT_TO_GET FROM SALESMAN_MASTER
WITH CHECK OPTION

--68.Create a view which display client name, salesman name
--s_oreder_no and order status
CREATE VIEW ORDER_VIEW AS
SELECT C.NAME,S.SALESMAN_NAME,O.S_ORDER_NO,O.ORDER_STATUS FROM SALESMAN_MASTER S 
JOIN SALES_ORDER O ON S.SALESMAN_NO=O.SALESMAN_NO
JOIN CLIENT_MASTER C ON O.CLIENT_NO=C.CLIENT_NO

SELECT * FROM ORDER_VIEW

--69.From the sales order details table display product wise quantity ordered
CREATE VIEW SALESDETAILS_VIEW AS
SELECT PRODUCT_NO,SUM(QTY_ORDERED)AS TOTAL_QTY FROM SALES_ORDER_DETAILS GROUP BY PRODUCT_NO

SELECT * FROM SALESDETAILS_VIEW

--70.Create view which display all billed challan detail
CREATE VIEW CHALLAN_VIEW AS
SELECT * FROM CHALLAN_HEADER WHERE BILLED_YN='Y'

SELECT * FROM CHALLAN_VIEW

-----------------------------------------------------------------------------
--10.Stored Procedure (for all the procedure handle required error)
--71.Write a procedure which takes client name and display a client record
--from client master table.
ALTER PROCEDURE CLIENT_PROCEDURE(@NAME VARCHAR(20))AS
BEGIN
	IF NOT EXISTS(SELECT CLIENT_NO FROM CLIENT_MASTER WHERE NAME=@NAME)
	BEGIN
			RAISERROR('CLIENT NOT EXISTS',16,1)
	END
	ELSE
	BEGIN
		SELECT * FROM CLIENT_MASTER WHERE NAME=@NAME
	END
END

EXEC CLIENT_PROCEDURE 'IVAN BAYROSS'
SELECT *FROM CLIENT_MASTER

--72.Take city name as parameter and display all client name and the balance
--due and at the end total balance due from the city (total of
--balance_due)
ALTER PROCEDURE PROCEDURE2(@CNAME VARCHAR(20))AS
BEGIN
	IF NOT EXISTS(SELECT NAME,BAL_DUE FROM CLIENT_MASTER WHERE CITY=@CNAME)
	BEGIN
		RAISERROR('CITY DOES NOTEXIST',16,1)
	END
	ELSE
	BEGIN
		SELECT NAME,BAL_DUE FROM CLIENT_MASTER WHERE CITY=@CNAME
	END
END

EXEC PROCEDURE2 'BOMBAY'

--73.Write a procedure which takes product description as a parameter and
--display the details
SELECT * FROM PRODUCT_MASTER
CREATE PROCEDURE PROC3(@DES VARCHAR(20))AS
BEGIN
	IF NOT EXISTS(SELECT PRODUCT_NO FROM PRODUCT_MASTER WHERE DESCRIPTION=@DES)
	BEGIN
		RAISERROR('DESCRIPTION DOES NOTEXIST',16,1)
	END
	ELSE
	BEGIN
		SELECT * FROM PRODUCT_MASTER WHERE DESCRIPTION=@DES
	END
END

EXEC PROC3 'MOUSE'

--74.Write a procedure which will take quantify on hand as parameter and display all products greater then the value
ALTER PROCEDURE PROC4(@QTY INT)AS
BEGIN
	SELECT * FROM PRODUCT_MASTER WHERE QTY_ON_HAND>=@QTY
END

EXEC PROC4 20

--75.Write a procedure which will display details for all “Floppies” product
CREATE PROCEDURE PRODUCT_PROC AS
BEGIN
	SELECT * FROM PRODUCT_MASTER WHERE DESCRIPTION LIKE '%FLOPPIES%'
END

EXEC PRODUCT_PROC

--76.Write a procedure which takes client name and display S_order_date,
--Order Status.
CREATE PROCEDURE ORDERDATE_PRO(@NAME VARCHAR(20))AS
BEGIN
	IF NOT EXISTS(SELECT CLIENT_NO FROM CLIENT_MASTER WHERE NAME=@NAME)
	BEGIN
		RAISERROR('NAME DOES NOT EXIST',16,1)
	END
	ELSE
	BEGIN
		SELECT S.S_ORDER_DATE FROM SALES_ORDER S JOIN CLIENT_MASTER C ON C.CLIENT_NO=S.CLIENT_NO WHERE C.NAME=@NAME
	END
END

EXEC ORDERDATE_PRO 'PRAMADA JAGUSTE'

--77. Write a procedure which print salesman name, whose Ytd sales > 100
CREATE PROCEDURE SALESMAN_PROC AS
BEGIN
	SELECT SALESMAN_NAME FROM SALESMAN_MASTER WHERE YTD_SALES>100
END

EXEC SALESMAN_PROC

--78. Take a two S_order_date parameters and display all sales detail
--between two dates.
CREATE PROCEDURE ORDERDATE_PROC(@DATE1 VARCHAR(10),@DATE2 VARCHAR(10))AS
BEGIN
	SELECT * FROM SALES_ORDER WHERE S_ORDER_DATE BETWEEN @DATE1 AND @DATE2
END

EXEC ORDERDATE_PROC '1996-01-1','1996-16-16'

--79. Take bill_y/n as a parameter and list all order details like S_order_no,
--S_order_date, salesman name, order status
ALTER PROCEDURE BILLYN(@BILL VARCHAR(2))AS
BEGIN
	SELECT O.*,S.SALESMAN_NAME FROM SALES_ORDER O JOIN SALESMAN_MASTER S ON O.SALESMAN_NO=S.SALESMAN_NO WHERE O.BILLYN=@BILL
END

EXEC BILLYN 'N'


--80. Takes S_order_no as a parameter and display product description and
--salesman name

CREATE PROCEDURE DETAIL_PROC(@ORDERNO VARCHAR(10))AS
BEGIN
	SELECT P.DESCRIPTION,M.SALESMAN_NAME,S.S_ORDER_NO FROM PRODUCT_MASTER P 
	JOIN SALES_ORDER_DETAILS O ON P.PRODUCT_NO=O.PRODUCT_NO
	JOIN SALES_ORDER S ON S.S_ORDER_NO=O.S_ORDER_NO
	JOIN SALESMAN_MASTER M ON M.SALESMAN_NO=S.SALESMAN_NO
	WHERE S.S_ORDER_NO=@ORDERNO
END

EXEC DETAIL_PROC 'O19002'

--81. Take client name as parameter and display S_order_no, S_order_date,
--salesman name, order status, product description, qty ordered, product
--rate and total (qty ordered * product rate)
	
ALTER PROCEDURE TOTALQTY(@NAME VARCHAR(30)) AS
BEGIN
	IF NOT EXISTS(SELECT CLIENT_NO FROM CLIENT_MASTER WHERE NAME=@NAME)
	BEGIN
		RAISERROR('CLIENT NOT FOUND',16,1)
	END
	ELSE
	BEGIN
		SELECT M.SALESMAN_NAME,S.S_ORDER_NO,S.S_ORDER_DATE,S.ORDER_STATUS,P.DESCRIPTION,O.QTY_ORDERED,O.PRODUCT_RATE,(O.QTY_ORDERED*O.PRODUCT_RATE)AS TOTAL FROM PRODUCT_MASTER P 
		JOIN SALES_ORDER_DETAILS O ON P.PRODUCT_NO=O.PRODUCT_NO
		JOIN SALES_ORDER S ON S.S_ORDER_NO=O.S_ORDER_NO
		JOIN SALESMAN_MASTER M ON M.SALESMAN_NO=S.SALESMAN_NO
		JOIN CLIENT_MASTER C ON C.CLIENT_NO=S.CLIENT_NO
		WHERE C.NAME=@NAME
	END
END

EXEC TOTALQTY 'PRAMADA JAGUSTE'

--82. List order details (order no, client name, salesman name, product
--description) where qty ordered is >= 10
ALTER PROCEDURE QTY AS
BEGIN
		SELECT O.S_ORDER_NO,C.NAME,M.SALESMAN_NAME,P.DESCRIPTION FROM PRODUCT_MASTER P 
		JOIN SALES_ORDER_DETAILS O ON P.PRODUCT_NO=O.PRODUCT_NO
		JOIN SALES_ORDER S ON S.S_ORDER_NO=O.S_ORDER_NO
		JOIN SALESMAN_MASTER M ON M.SALESMAN_NO=S.SALESMAN_NO
		JOIN CLIENT_MASTER C ON C.CLIENT_NO=S.CLIENT_NO
		WHERE O.QTY_ORDERED>=10
END

EXEC QTY

--83.Take challan no and print details (order no, challan date, client name,
--salesman name, order date, order status)
CREATE PROCEDURE CHALLANPROC(@CNO VARCHAR(20))AS
BEGIN
	IF NOT EXISTS(SELECT CHALLAN_NO FROM CHALLAN_HEADER WHERE CHALLAN_NO=@CNO)
		RAISERROR('INVALID CHALLAN NUMBER',16,1)
	ELSE
	BEGIN
		SELECT S.S_ORDER_NO,CH.CHALLAN_DATE,C.NAME,SM.SALESMAN_NAME,S.S_ORDER_DATE,S.ORDER_STATUS FROM CHALLAN_HEADER CH 
		JOIN SALES_ORDER S ON S.S_ORDER_NO=CH.S_ORDER_NO
		JOIN CLIENT_MASTER C ON S.CLIENT_NO=C.CLIENT_NO
		JOIN SALESMAN_MASTER SM ON S.SALESMAN_NO=SM.SALESMAN_NO
		WHERE CH.CHALLAN_NO=@CNO
	END
END

SELECT *FROM CHALLAN_HEADER
EXEC CHALLANPROC 'CH3965'

--84.Take challan date month as a parameter and display challan detail like
--s_order_no, s_order_date, bill y/n, delay_date, order status
CREATE PROCEDURE CHALLAN_PROC(@DATE INT,@MONTH INT)AS
BEGIN
	IF NOT EXISTS(SELECT CHALLAN_NO FROM CHALLAN_HEADER WHERE MONTH(CHALLAN_DATE)=@MONTH)
		RAISERROR('NO ORDERS FOR THIS MONTH',16,1)
	ELSE
	BEGIN
		SELECT S.S_ORDER_NO,CH.CHALLAN_DATE,S.S_ORDER_DATE,S.ORDER_STATUS,S.BILLYN,S.DELY_DATE FROM CHALLAN_HEADER CH 
		JOIN SALES_ORDER S ON S.S_ORDER_NO=CH.S_ORDER_NO
		WHERE MONTH(CH.CHALLAN_DATE)=@MONTH AND DATEPART(DD,CH.CHALLAN_DATE)=@DATE
	END
END

EXEC CHALLAN_PROC 12,10

--85.Take product no as parameter and print all the orders for the products
--like s_order_no, client name, salesman name
CREATE PROCEDURE PRODDET(@PNO VARCHAR(20)) AS
BEGIN
	IF NOT EXISTS(SELECT PRODUCT_NO FROM PRODUCT_MASTER WHERE PRODUCT_NO=@PNO)
	BEGIN
		RAISERROR('PRODUCT NOT FOUND',16,1)
	END
	ELSE
	BEGIN
		SELECT M.SALESMAN_NAME,S.S_ORDER_NO,C.NAME FROM PRODUCT_MASTER P 
		JOIN SALES_ORDER_DETAILS O ON P.PRODUCT_NO=O.PRODUCT_NO
		JOIN SALES_ORDER S ON S.S_ORDER_NO=O.S_ORDER_NO
		JOIN SALESMAN_MASTER M ON M.SALESMAN_NO=S.SALESMAN_NO
		JOIN CLIENT_MASTER C ON C.CLIENT_NO=S.CLIENT_NO
		WHERE P.PRODUCT_NO=@PNO
	END
END

SELECT * FROM PRODUCT_MASTER
EXEC PRODDET 'P00001'


--86.Write a procedure which print order no and order date for the salesman
--kiran
CREATE PROCEDURE KIRANDET AS
BEGIN
	SELECT CLIENT_NO,S_ORDER_DATE FROM SALES_ORDER WHERE SALESMAN_NO IN(
	SELECT SALESMAN_NO FROM SALESMAN_MASTER WHERE SALESMAN_NAME='KIRAN')
END

EXEC KIRANDET

--87. Write a procedure which takes order no as parameter and return in out
--parameter total qty ordered and total qty dispatched for the order (table sales_order)
ALTER PROCEDURE OUTTOTAL(@ONO VARCHAR(10),@QTYORDER NUMERIC(7,2) OUT,@QTYDISPACH NUMERIC(7,2) OUT)AS
BEGIN
	SELECT @QTYORDER=SUM(QTY_ORDERED), @QTYDISPACH=SUM(QTY_DISP) FROM SALES_ORDER_DETAILS WHERE S_ORDER_NO=@ONO
END

DECLARE @ORDERED NUMERIC(7,2),@DISPACHED NUMERIC(7,2)
EXEC OUTTOTAL 'O10008',@ORDERED OUT,@DISPACHED OUT
PRINT 'ORDERED TOTAL :'+CAST(@ORDERED AS VARCHAR)+'DISPACHED TOTAL :'+CAST(@DISPACHED AS VARCHAR)


--88. Write a procedure which display product description cost price, sales
--price and profit amount (cost price – sales price). At the end display
--total profit amount
ALTER PROCEDURE PROD_DET(@TAMOUNT NUMERIC(7,2)OUT) AS
BEGIN
	SELECT DESCRIPTION,COST_PRICE,SELL_PRICE,(COST_PRICE-SELL_PRICE)AS[PROFIT AMOUNT] FROM PRODUCT_MASTER
	SELECT @TAMOUNT=SUM(COST_PRICE-SELL_PRICE) FROM PRODUCT_MASTER
END

DECLARE @TAMOUNT NUMERIC(7,2)
EXEC PROD_DET @TAMOUNT OUT
PRINT CAST(@TAMOUNT AS VARCHAR)+'TOTAL PROFITAMOUNT'

--89.Display all the product detail where reorder level is below 5
CREATE PROCEDURE DETAILSPROD AS
BEGIN
	SELECT * FROM PRODUCT_MASTER WHERE RECORDER_LVL<5
END

EXEC DETAILSPROD

--90. Take sales order no check if qty dispatched is less than qty ordered than display product description , 
--qty ordered, qty dispatched and the difference else print the message all qty dispatched.
ALTER PROCEDURE QTY_DET(@ONO VARCHAR(20))AS
BEGIN
	DECLARE ORDERCURSOR CURSOR FOR SELECT QTY_ORDERED,QTY_DISP,(QTY_ORDERED-QTY_DISP),PRODUCT_NO FROM SALES_ORDER_DETAILS WHERE S_ORDER_NO=@ONO
	DECLARE @QTYO INT,@QTYD INT,@DIFF INT,@PRODNO VARCHAR(20)

	OPEN ORDERCURSOR
	FETCH NEXT FROM ORDERCURSOR INTO @QTYO,@QTYD,@DIFF,@PRODNO
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF(@DIFF>0)
		BEGIN
			SELECT P.DESCRIPTION,O.QTY_ORDERED,O.QTY_DISP,(QTY_ORDERED-QTY_DISP)AS DIFFERENCE FROM PRODUCT_MASTER P JOIN SALES_ORDER_DETAILS O ON P.PRODUCT_NO=O.PRODUCT_NO 
			WHERE O.PRODUCT_NO=@PRODNO AND O.S_ORDER_NO=@ONO
		END
		ELSE
		BEGIN
			PRINT 'ALL ORDERS DISPATCHED'
		END
		FETCH NEXT FROM ORDERCURSOR INTO @QTYO,@QTYD,@DIFF,@PRODNO
	END
	CLOSE ORDERCURSOR
	DEALLOCATE ORDERCURSOR
END

SELECT * FROM SALES_ORDER_DETAILS
EXEC QTY_DET 'O46865'



--------------------------------------------------------------------------------------------------------------
--11. Functions
--91. Take the city name and return total no of customer count in the city
ALTER FUNCTION CUSTCOUNT(@CITY VARCHAR(20))
RETURNS INT 
AS
BEGIN
RETURN (SELECT COUNT(CLIENT_NO) FROM CLIENT_MASTER WHERE CITY=@CITY)
END

SELECT DBO.CUSTCOUNT('BOMBAY')AS CUSTCOUNY

--92. Take salesman name and return total order count
CREATE FUNCTION SALESCOUNT(@NAME VARCHAR(20))
RETURNS INT AS
BEGIN
	DECLARE @COUNT INT
	SELECT @COUNT=COUNT(O.S_ORDER_NO) FROM SALESMAN_MASTER M 
	JOIN SALES_ORDER S ON M.SALESMAN_NO=S.SALESMAN_NO 
	JOIN SALES_ORDER_DETAILS O ON O.S_ORDER_NO=S.S_ORDER_NO
	WHERE M.SALESMAN_NAME=@NAME
	RETURN @COUNT
END

SELECT * FROM SALESMAN_MASTER
SELECT DBO.SALESCOUNT('KIRAN')

--93. Write a function which takes salesman name and return target to
--get.
CREATE FUNCTION SALESTARGET(@NAME VARCHAR(20))
RETURNS INT 
AS
BEGIN
RETURN (SELECT TGT_TO_GET FROM SALESMAN_MASTER WHERE SALESMAN_NAME=@NAME)
END

SELECT DBO.SALESTARGET('KIRAN')

--94.Write a function which will return total target to get by all the
--salesman
CREATE FUNCTION SALESTARGETSUM()
RETURNS INT 
AS
BEGIN
RETURN (SELECT SUM(TGT_TO_GET) FROM SALESMAN_MASTER)
END

SELECT DBO.SALESTARGETSUM()

--95. Take order status as a parameter and return total order count for
--the order status
CREATE FUNCTION ORDERSTATUS(@STATUS VARCHAR(20))
RETURNS INT 
AS
BEGIN
RETURN (SELECT COUNT(S_ORDER_NO) FROM SALES_ORDER WHERE ORDER_STATUS=@STATUS)
END

SELECT DBO.ORDERSTATUS('IN PROCESS')

--96. Take year and month as a parameter to a function and return order
--count
CREATE FUNCTION ORDERCNT(@MONTH INT,@YEAR INT)
RETURNS INT 
AS
BEGIN
RETURN (SELECT COUNT(S_ORDER_NO) FROM SALES_ORDER WHERE YEAR(S_ORDER_DATE)=@YEAR AND DATEPART(MM,S_ORDER_DATE)=@MONTH)
END

SELECT * FROM SALES_ORDER
SELECT DBO.ORDERCNT(7,1996)

--97.Take s_order_no as a parameter to a function and return total bill
--amount
CREATE FUNCTION TOTALBILL(@ONO VARCHAR(20))
RETURNS NUMERIC(7,2)
AS
BEGIN
	RETURN (SELECT SUM(QTY_ORDERED*PRODUCT_RATE) FROM SALES_ORDER_DETAILS WHERE S_ORDER_NO=@ONO)
END

SELECT * FROM SALES_ORDER_DETAILS
SELECT DBO.TOTALBILL('O19001')

--98. Return total salesman count in the city Mumbai
CREATE FUNCTION SALESMANCNT()
RETURNS NUMERIC(7)
AS
BEGIN
	RETURN (SELECT COUNT(SALESMAN_NO) FROM SALESMAN_MASTER WHERE CITY='BOMBAY')
END

SELECT DBO.SALESMANCNT()


--99.Take state name and return total client in the state
CREATE FUNCTION CLIENTSTATE(@NAME VARCHAR(20))
RETURNS NUMERIC(7)
AS
BEGIN
	RETURN (SELECT COUNT(CLIENT_NO) FROM CLIENT_MASTER WHERE STATE=@NAME)
END

SELECT DBO.CLIENTSTATE('MAHARASHTRA')

--100. Take city name as parameter and return total amount of balance
--due for the city
CREATE FUNCTION CLIENTBALANCE(@NAME VARCHAR(20))
RETURNS NUMERIC(7,2)
AS
BEGIN
	RETURN (SELECT SUM(BAL_DUE) FROM CLIENT_MASTER WHERE CITY=@NAME)
END

SELECT DBO.CLIENTBALANCE('BOMBAY')


----------------------------------------------------------------------------------------
--Observation
--Before deleting any table create the copy of the table
--How to create copy of an existing table is your assignment.
SELECT * INTO NEW_CLIENT_MASTER FROM CLIENT_MASTER 
SELECT * INTO NEW_PRODUCT_MASTER FROM PRODUCT_MASTER 
SELECT * INTO NEW_SALESMAN_MASTER FROM SALESMAN_MASTER
SELECT * INTO NEW_SALES_ORDER FROM SALES_ORDER
SELECT * INTO NEW_SALES_ORDER_DETAILS FROM SALES_ORDER_DETAILS
SELECT * INTO NEW_CHALLAN_HEADER FROM CHALLAN_HEADER
SELECT * INTO NEW_CHALLAN_DETAILS FROM CHALLAN_DETAILS


--1) Add the following record into the challan_details table and check if the
--records get added or not. Note the observation for each of them
--CH9001 P00001 5
--P785341 P06734 9
--P00001 CH9001 1
INSERT INTO CHALLAN_DETAILS VALUES('CH9001','P00001',5);--Violation of PRIMARY KEY constraint 
INSERT INTO CHALLAN_DETAILS VALUES('P785341','P06734',9);--1ST COL REFERENCES CHALLAN NO
INSERT INTO CHALLAN_DETAILS VALUES('P00001','CH9001',4);--FOREIGN KEY CONSTRAIJNT

--2) Drop the table product_master. Can the product_master be dropped. If
--not, Note the error message.

DROP TABLE PRODUCT_MASTER--because it is referenced by a FOREIGN KEY constraint.

--3) Drop the table challan_details, challan_header and product_master in
--specified sequence.

DROP TABLE CHALLAN_DETAILS
DROP TABLE CHALLAN_HEADER
DROP TABLE PRODUCT_MASTER--CANNOT DROP
--4) What conclusions can you draw, performing the above tasks?
/*
UNLESS THERE IS A CHILD TABLE REFERENCING PARENT ,PARENT TABLE CANNOTBE DELTED
*/