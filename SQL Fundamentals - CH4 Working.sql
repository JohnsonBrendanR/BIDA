SELECT 
DimCustomer.Customerkey,
sum(salesamount) AS sales

FROM FactInternetsales

JOIN
DimCustomer ON FactInternetSales.CustomerKey = DimCustomer.CustomerKey

Group By DimCustomer.Customerkey
;

SELECT  C.Customerkey


FROM DimCustomer c
;

SELECT 
CONCAT(C.FirstName, ' ', C.LastName) AS Name,
Sum(FIS.SalesAmount) AS Sales

FROM FactInternetSales FIS

JOIN DimCustomer C  ON C.CustomerKey = FIS.CustomerKey

GROUP BY C.FirstName, C.LastName
;
--Added INNER JOIN; returns the same result (rows)--
SELECT 
CONCAT(C.FirstName, ' ', C.LastName) AS Name,
Sum(FIS.SalesAmount) AS Sales

FROM FactInternetSales FIS

INNER JOIN DimCustomer C  ON C.CustomerKey = FIS.CustomerKey

GROUP BY C.FirstName, C.LastName
;

--UNION--
    --Combines two queries--

SELECT 
ProductKey,
EnglishProductName,
Color,
ListPrice

FROM 
DimProduct P

WHERE
ProductKey BETWEEN 200 AND 299

UNION 

SELECT 
ProductKey,
EnglishProductName,
Color,
ListPrice

FROM 
DimProduct P

WHERE ProductKey BETWEEN 10 AND 45

;

--Challenges--

SELECT 
TOP 5
PS.EnglishProductSubcategoryName,

ROUND(sum(SalesAmount), 2) AS Sales

FROM 

DimProduct P

JOIN DimProductSubcategory PS ON PS.ProductSubcategoryKey = P.ProductSubcategoryKey 
JOIN FactInternetSales FIS ON FIS.ProductKey = P.ProductKey
JOIN DimCurrency DC ON DC.CurrencyKey = FIS.CurrencyKey 

WHERE
DC.CurrencyName = 'US Dollar'

GROUP BY PS.EnglishProductSubcategoryName

ORDER BY 2 DESC
;

SELECT 
FIS.SalesOrderNumber AS InvoiceNumber,
FIS.SalesOrderLineNumber AS InvoiceLineNumber,
FIS.OrderDate AS OrderDate,
ROUND(FIS.SalesAmount, 2) AS SalesAmount,
FIS.OrderQuantity AS Quantity,
P.EnglishProductName AS ProductName,
DST.SalesTerritoryCountry AS Country,
'Web' AS Source


FROM 
FactInternetSales FIS

JOIN DimProduct P ON P.ProductKey = FIS.ProductKey
JOIN DimSalesTerritory DST ON DST.SalesTerritoryKey = FIS.SalesTerritoryKey


WHERE YEAR(FIS.OrderDate) = 2012 AND DST.SalesTerritoryCountry = 'Canada'


UNION

SELECT 
FS.SalesOrderNumber AS InvoiceNumber,
FS.SalesOrderLineNumber AS InvoiceLineNumber,
FS.OrderDate AS OrderDate,
ROUND(FS.SalesAmount, 2) AS SalesAmount,
FS.OrderQuantity AS Quantity,
P.EnglishProductName AS ProductName,
DST.SalesTerritoryCountry AS Country,
R.ResellerName AS Source



FROM 
FactResellerSales FS

JOIN DimProduct P ON P.ProductKey = FS.ProductKey
JOIN DimSalesTerritory DST ON DST.SalesTerritoryKey = FS.SalesTerritoryKey
JOIN DimReseller R ON R.ResellerKey =  FS.ResellerKey


WHERE YEAR(FS.OrderDate) = 2012 AND DST.SalesTerritoryCountry = 'Canada'
