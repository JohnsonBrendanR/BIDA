 --Replacing Null Values--

--ISNULL--
    --Test for Null appearance in Temp Columms--
SELECT
FirstName, MiddleName, LastName,
FirstName + MiddleName + LastName AS FullName

FROM DimCustomer

;

SELECT
FirstName, MiddleName, LastName,
FirstName + MiddleName + LastName AS FullNameTest,
FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName 

FROM DimCustomer;

--COALESCE--
    --Conditionally create a Temp Column--

SELECT
Title,
FirstName, MiddleName, LastName,
FirstName + MiddleName + LastName AS FullNameTest,
FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName, 
Coalesce(Title + ' ' + LastName, FirstName + ' ' + ISNULL(MiddleName + ' ', '') ) + LastName AS COAL

FROM DimCustomer;


SELECT

Coalesce(Title + ' ' + LastName, FirstName + ' ' + ISNULL(MiddleName + ' ', '') ) AS COAL

FROM DimCustomer

WHERE Title IS NOT NULL;

    --Coalesce NULLIF, w/ Percentage--
        --Produces a vlaue in Percent Column without breaking query from 'divide by zero'--
SELECT 
Coalesce(Title + ' ' + LastName, FirstName + ' ' + ISNULL(MiddleName + ' ', '') ) AS COAL,
TotalChildren,
NumberChildrenAtHome,
NumberChildrenAtHome / NULLIF(TotalChildren, 0)  AS PercentOfChildrenAtHome

FROM DimCustomer

--Text Functions--
    --CONCAT, LEN, UPPER, LOWER, REPLACE, 
SELECT 

ProductKey, 
EnglishProductName
ProductAlternateKey,
CONCAT(EnglishProductName , ' ',ProductAlternateKey) AS ProductKeyNameFull

FROM 

DimProduct;


SELECT 
ProductKey, 

CONCAT(EnglishProductName , ' ',ProductAlternateKey) AS ProductKeyNameFull,
LEN(EnglishProductName) AS Length,
UPPER(EnglishProductName) AS UPPER,
LOWER(EnglishProductName) AS LOWER,
REPLACE(EnglishProductName, 'Front', 'Good') AS REPLACED, 
LEFT(EnglishDescription, 20) AS ProductDescriptionShort,
RIGHT(ProductAlternateKey, 7) AS ShortenedAltProdKey 

FROM

DimProduct

WHERE 

ProductKey IN (555, 444, 333)


--Number Functions--
    --FLOOR, CEILING, ABS--

SELECT 

TaxAmt,
FLOOR(TaxAmt) FLOORTaxAmt,
CEILING(TaxAmt)CEILINGTaxAmt,
ABS(SalesAmount) - 1500 AS AbsoluteDifference
FROM 

FactInternetSales

--DateFunctions--
    --DATEPART, DATENAME, YEAR, MONTH, DATEDIFF

SELECT 
OrderDate,
DATEPART(week, OrderDate) AS Week#,
DATENAME(weekday, OrderDate) AS DayofWeek,
YEAR(OrderDate) AS YEAR,
MONTH(OrderDate)AS MONTH,
DATEDIFF(day, ShipDate, DueDate) AS DaysBetween

FROM 

FactInternetSales

ORDER BY OrderDate DESC
;

--Challenges--

SELECT 

CustomerKey,
CONCAT(UPPER(Lastname), ', ',  UPPER(LEFT(FirstName, 1))) AS DisplayName,
REPLACE(EmailAddress, '@', ' [at] ') AS MaskedEmail,
ABS(YearlyIncome - 75000) AS MagOfIncome,
DATENAME(weekday, BirthDate) AS DayofWeek,
DATEPART(week, BirthDate) AS WEEK,
DATEDIFF(Week, DateFirstPurchase, CURRENT_DATE) AS WeeksSincePurchase


FROM 

DimCustomer

WHERE BirthDate IS NOT NULL

ORDER BY CommuteDistance DESC
;

SELECT 

ProductKey,
ProductAlternateKey,
ROUND(ListPrice, 2) AS ListPrice,
CAST(StartDate AS date) AS Start_Date,
CAST(EndDate AS date) AS End_Date,
ROUND(ListPrice / Weight, 2) AS PricePerUnitWeight,
ISNULL(Size, 'No Size') AS Size


FROM DimProduct

WHERE ListPrice IS NOT NULL AND Color = 'Black'