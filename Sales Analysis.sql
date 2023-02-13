/*

Sales Data Cleaning in MySQL 

Skills Used: created aliases using 'AS' keyword, WHERE clause, ORDER BY keyword, LEFT JOIN keyword, CASE statement, IFNULL function  

*/


-- Clean DIM_Date Table --

SELECT 
    DateKey AS Date_Key,
    FullDateAlternateKey AS Date, 
    EnglishDayNameofWeek AS Day, 
    EnglishMonthName AS Month, 
    Left (EnglishMonthName, 3) AS Month_Short, 
    MonthNumberofYear AS Month_Number, 
    CalendarQuarter AS Quarter,
    CalendarYear AS Year 
FROM 
    DimDate
WHERE 
    CalendarYear >= 2019; 


-- Clean DIM_Customers Table --

SELECT 
    c.customerkey AS Customer_Key, 
    c.firstname AS First_Name, 
    c.lastname AS Last_Name, 
    c.firstname + ' ' + lastname AS Full_Name, -- Combined First and Last Name
CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
    c.datefirstpurchase AS Date_First_Purchase, 
    g.city AS Customer_City -- Join in Customer City from Geography Table
FROM 
    DimCustomer AS c
    LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey 
ORDER BY 
    CustomerKey ASC; -- Order List by CustomerKey 


-- Clean DIM_Products Table --

SELECT 
    p.ProductKey AS Product_Key,
    p.ProductAlternateKey AS Product_Item_Code,
    p.EnglishProductName AS Product_Name,
    ps.EnglishProductSubcategoryName AS Sub_Category, -- Joined in from Sub Category Table
    pc.EnglishProductCategoryName AS Product_Category, -- Joined in from Category Table
    p.Color AS Product_Color,
    p.Size AS Product_Size,
    p.ProductLine AS Product_Line,
    p.ModelName AS Product_Model_Name,
    p.EnglishDescription AS Product_Description,
    IFNULL (p.Status, 'Outdated') AS Product_Status 
FROM 
    DimProduct AS p
    LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
    LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey 
ORDER BY 
    p.ProductKey ASC; 


-- Clean FACT_InternetSales Table --

SELECT 
    ProductKey AS Product_Key,
    OrderDateKey AS Order_Date_Key,
    DueDateKey AS Due_Date_Key, 
    ShipDateKey AS Ship_Date_Key, 
    CustomerKey AS Customer_Key, 
    SalesOrderNumber AS Sales_Order_Number, 
    SalesAmount AS Sales_Amount 
FROM 
    FactInternetSales 
WHERE 
    LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) - 2 
ORDER BY 
    OrderDateKey ASC; 

 