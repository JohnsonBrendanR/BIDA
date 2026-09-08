--Basic Queries--
    --Exploring the Database Q's--
        
            --Total Rows?--
SELECT *

FROM factSale

--228,265--

            --Data type of Quantity Column?--

SELECT Quantity

FROM factsale

--Integer--

            --How many columns contain null values?--
SELECT *

FROM dimEmployee

--Photo column; in ERD, documentation--

            --Does the staging_factsale table contain data--
SELECT 
*
FROM Staging_FactSale 

--No data, non-prod column--

    --Customer(dimCustomer) Table Q's--
            --Describe the Customers--
SELECT DISTINCT S.[Customer Key], C.[Customer]

FROM dimCustomer C

FULL JOIN factSale S ON S.[Customer Key] = C.[Customer Key]

WHERE C.[Customer Key] <> 0 AND S.[Customer Key] <> 0

;

SELECT COUNT(DISTINCT C.[Bill To Customer]) AS BillToCustomerDistinctCOUNT

FROM dimCustomer C

UNION

SELECT COUNT(DISTINCT C.[Customer]) AS CustomerDistinctCOUNT

FROM dimCustomer C

;

SELECT Customer AS Customer

FROM dimCustomer

WHERE Customer <> 'Unknown'

--Two corparations with subordiante stores--

        --How many rows in dimCustomer--

SELECT COUNT(*)

FROM dimCustomer
--403--
        --'Unknown' entries for Customer Column?--


SELECT Customer

FROM dimCustomer

WHERE Customer = 'Unknown'

--Yes--
        --How many known customers?

SELECT COUNT(DISTINCT Customer) AS KnownCustomers

FROM dimCustomer

WHERE Customer <> 'Unknown'

;

SELECT COUNT(DISTINCT C.[Bill To Customer]) AS BillToCustomerDistinctCOUNT

FROM dimCustomer C

WHERE C.[Bill To Customer] <> 'Unknown'

UNION

SELECT COUNT(DISTINCT C.[Customer]) AS CustomerDistinctCOUNT

FROM dimCustomer C

WHERE C.[Bill To Customer] <> 'Unknown'

;

SELECT Customer

FROM dimCustomer

WHERE Customer <> 'Unknown'

--402--

    --Product (dimStockItem) Table Q's--
        --How many FK's in dimStockItem table?--

SELECT *

FROM dimStockItem

--0; ERD, in documentation--

        --How many rows in dimStockItem table?--

SELECT *

FROM dimStockItem

--229--

        --How many known products are we dealing with?--

SELECT COUNT([Stock Item]) AS COUNTofStockItems

FROM dimStockItem

WHERE [Stock Item] <> 'Unknown'

--228--

        --What does 'IsChillerStock' mean?--

SELECT COUNT([IS Chiller Stock]) AS Count

FROM dimStockItem

WHERE [Is Chiller Stock] = 0

UNION

SELECT COUNT([IS Chiller Stock]) AS YES

FROM dimStockItem

WHERE [Is Chiller Stock] = 1

--Binary data type; 0 = Not a chiller item, 1 = chiller item--

        --Marketing--
            --What is the unit price of teh cheapest item that we currently sell?--

SELECT [Unit Price]

FROM dimStockItem

WHERE [Stock Item] <> 'Unknown'

ORDER BY [Unit Price] ASC

--.66--

            --What is the cheapest product we currently sell?--

SELECT [Stock Item], [Unit Price]

FROM dimStockItem

WHERE [Unit Price] = '.66'

--3 kg Courier post bag (White) 300x190x95mm--

            --Cheapest non-packaging-related product (Exclude box, bag, carton in names)--

SELECT [Stock Item], [Selling Package], [Unit Price]

FROM dimStockItem

WHERE [Stock Item] <> 'Unknown' AND [Stock Item] NOT LIKE '%box%' AND [Stock Item] NOT LIKE  '%bag%' AND [Stock Item] NOT LIKE  '%carton%'

ORDER BY [Unit Price] ASC

--Packing knife with metal insert blade (Yellow) 9mm--

                --Marketing Part 2--
        --Constraints: No knives; suggesting a Mug or shirt, black is preferred.

        --How many prodcuts contain mug or shirt--

SELECT COUNT([Stock Item])

FROM dimStockItem

WHERE  [Stock Item] LIKE '%mug%' OR [Stock Item] LIKE '%shirt%'

--68 items; shirts and mugs--

        --Same as before but also black--

SELECT COUNT([Stock Item])

FROM dimStockItem

WHERE  [Stock Item] LIKE '%mug%' OR [Stock Item] LIKE '%shirt%' AND [Color] = 'Black'

--55--

        --What is teh cheapest product meeting the above conditions? choose lowest ID by price if needed--'

SELECT [WWI Stock Item ID], [Stock Item], [Unit Price]

FROM dimStockItem

WHERE [Stock Item] LIKE '%mug%' OR [Stock Item] LIKE '%shirt%' AND [Color] = 'Black'

ORDER BY [Unit Price] ASC

--16; $13--

        --What is the markup for the stock item 29?--

SELECT [WWI Stock Item ID], ROUND(([Recommended Retail Price] - [Unit Price]) / [Unit Price], 3) AS Markup


FROM dimStockItem


WHERE [WWI Stock Item ID] = '29'

--0.495--

                  --Delivery Efficiency--
        --How many customers are in each buying group?--

SELECT *

FROM dimCustomer

WHERE [Buying Group] <> 'N/A'

GROUP BY [Buying Group]

--201, 201, and 1 'N/A' (Blank row)--

        --Any postal codes have more than 3 Wingtip Toys shops?--

SELECT COUNT([Postal Code]) AS CountofBuyerbyPostalCode, [Postal Code]

FROM dimCustomer

WHERE [Buying Group] = 'Wingtip Toys'

GROUP BY [Postal Code]

ORDER BY COUNT([Postal Code]) DESC

--90683--

        --What is the cheapest non-packaging related product?--

SELECT [Stock Item], [Selling Package], [Unit Price]

FROM dimStockItem

WHERE [Stock Item] <> 'Unknown' AND [Stock Item] NOT LIKE '%box%' AND [Stock Item] NOT LIKE  '%bag%' AND [Stock Item] NOT LIKE  '%carton%'

ORDER BY [Unit Price] ASC

                        --City Q's--
                --Which sales territory has the hihgest population?-- 
SELECT [Sales Territory], SUM([Latest Recorded Population]) AS SUM

FROM dimCity

GROUP BY [Sales Territory]

ORDER BY 2 DESC


--Southeast--
                --Count of cities in the above territory?--

SELECT Count(City) AS CountofCities

FROM dimCity

WHERE [Sales Territory] = 'Southeast' 

--9063--

                --Population of biggest city in that territory?--

SELECT City, [Latest Recorded Population]

FROM dimCity

WHERE [Sales Territory] = 'Southeast' 

ORDER BY [Latest Recorded Population] DESC

--821784--

                --Total population amongst all territories?--

SELECT sum([Latest Recorded Population]) AS Population

FROM dimCity

--227338926--

                        --Multiple Tables Q's--
                --What is the granularity of the factSale Table?--

SELECT *

FROM Factsale

--Product information, packaging, quantity, unit price, tax amounts, Sub-total, Tax Total, Total--

                --What type of relationship exists between factsale and dimDate--

--The dimDate table holds the primary key for all dates, FK's in factSale are Invoice date key and delivery date key; from ERD--

                --What is the maximum fiscal year in dimDate?--

SELECT [Fiscal Year]

FROM dimdate

ORDER BY [Fiscal Year] DESC

--2017 is latest, 2013 is oldest--

                --How many fiscal years do we have sales data for?--

SELECT *

FROM dimDate d

JOIN factSale fs ON d.date = fs.[Invoice Date Key]

ORDER BY [Invoice Date Key] ASC

--2013 - 2016 ; Jan 02, 2013 - May 31, 2016

                        --Sales Department help--
                --What were the Sales excluding tax in fy 2015?--

SELECT [Fiscal Year], sum([Total Excluding Tax]) AS FY

FROM factSale fs

JOIN dimdate d ON d.DATE = fs.[Invoice Date Key] 

GROUP BY [Fiscal Year]

ORDER BY [Fiscal Year] DESC

--$53,827,320.95--

                --Which FY has highest profit?--

SELECT [Fiscal Year], SUM(Profit) AS Profit

FROM factSale fs

JOIN dimdate d ON d.DATE = fs.[Invoice Date Key] 

GROUP BY [Fiscal Year]

ORDER BY Profit DESC

--2015, $26,815,310.85

                --What explanation have you for 2015 profit > 2016 profit?--


SELECT [Fiscal Year], sum(Profit) AS Profit, sum([Total Excluding Tax]) AS Sales, COUNT([Invoice Date Key]) AS CountofInvoices, 
sum(profit) - sum([Total Excluding Tax]) / sum(Profit) AS Margin

FROM factSale fs

JOIN dimdate d ON d.DATE = fs.[Invoice Date Key] 

GROUP BY [Fiscal Year]

ORDER BY 2 DESC

;

SELECT [Fiscal Year], AVG(profit) AS AVGProfitperOrder, COUNT([Customer Key]) AS CountofCustomers, sum(Profit) AS Profit, COUNT(Quantity) AS Quantity

FROM factSale fs

JOIN dimdate d ON d.DATE = fs.[Invoice Date Key] 

WHERE [Customer Key] IS NOT NULL

GROUP BY [Fiscal Year]

;

SELECT [Fiscal Year], [Fiscal Month Number], sum(Profit)

FROM dimDate d

JOIN factSale fs ON d.[Date] = fs.[Invoice Date Key] 

GROUP BY [Fiscal Year], [Fiscal Month Number]

Order by [Fiscal Year] DESC, [Fiscal Month Number] ASC

--Sum of sales, count of sales, margin sum, and quantity sold was all greater for 2015 than all other years. 
--For 2016 there were 30,000 less customers than in 2015 as well, and only 7 months of data available.--

                --Total sales excluding tax in FY2016--

SELECT d.[Fiscal Year], sum(fs.[Total Excluding Tax]) AS TotalSalesWOTax

FROM factSale fs

JOIN dimDate d ON d.date = fs.[Invoice Date Key]

WHERE d.[fiscal year] = 2016

GROUP BY d.[Fiscal Year]

--31,181,195.30--

                --What was the top-performing product in FY 2016--
SELECT sum(fs.[Total Excluding Tax]) AS TotalSalesWOTax, si.[stock item] AS Item

FROM factSale fs

JOIN dimDate d ON d.date = fs.[Invoice Date Key]
JOIN dimStockItem si ON si.[stock item key] = fs.[Stock Item Key]

WHERE d.[fiscal year] = 2016

GROUP BY si.[stock item]

ORDER BY 1 DESC

--Air cushion machine (Blue)--

                --What was the top-performing product/ salesperson combination in FY 2016--
                
SELECT sum(fs.[Total Excluding Tax]) AS TotalSalesWOTax, si.[stock item] AS Item, e.[employee]

FROM factSale fs

JOIN dimDate d ON d.date = fs.[Invoice Date Key]
JOIN dimStockItem si ON si.[stock item key] = fs.[Stock Item Key]
JOIN dimEmployee e ON e.[employee key] = fs.[Salesperson Key]

WHERE d.[fiscal year] = 2016 AND e.[Is Salesperson] = 1

GROUP BY si.[stock item], e.[Employee]

ORDER BY 1 DESC

                --Air cushion machine (Blue), Amy Trefl & Anthony Grosse--

-- YEAR(GETDATE())--

                --How many chiller products have 0 qty sold to date?--

SELECT si.[stock item], sum(fs.quantity)

FROM dimStockItem si

LEFT JOIN factSale fs ON fs.[Stock Item Key] = si.[stock item key]

WHERE si.[Is Chiller Stock] = 1

GROUP BY si.[stock item]

HAVING sum(fs.quantity) IS NULL

ORDER BY 2 DESC

--White chocolate moon rocks 2kg--