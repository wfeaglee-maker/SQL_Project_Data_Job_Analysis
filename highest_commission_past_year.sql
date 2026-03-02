-- Employees (salespersons) with highest commission in the past year
-- AdventureWorks 2025
-- Commission = Sum of (Order SubTotal * CommissionPct) for orders in the last 12 months

-- Use your AdventureWorks database (e.g. AdventureWorks2022, AdventureWorks2024, AdventureWorks2025)
-- USE AdventureWorks2025;
-- GO

SELECT TOP 10
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    sp.CommissionPct,
    COUNT(h.SalesOrderID) AS OrderCount,
    SUM(h.SubTotal) AS TotalSales,
    SUM(h.SubTotal * sp.CommissionPct) AS TotalCommission
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.SalesPerson AS sp
    ON h.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person.Person AS p
    ON sp.BusinessEntityID = p.BusinessEntityID
WHERE h.OrderDate >= DATEADD(YEAR, -1, GETDATE())
  AND h.SalesPersonID IS NOT NULL
GROUP BY
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    sp.CommissionPct
ORDER BY TotalCommission DESC;
