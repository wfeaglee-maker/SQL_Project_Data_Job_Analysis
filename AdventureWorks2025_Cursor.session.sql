SELECT
    d.Name AS DepartmentName,
    v.BusinessEntityID AS VendorID,
    v.Name AS VendorName,
    SUM(pod.LineTotal) AS TotalPurchaseAmount2025,
    RANK() OVER (
        PARTITION BY d.Name
        ORDER BY SUM(pod.LineTotal) DESC
    ) AS VendorRankInDepartment
FROM Purchasing.PurchaseOrderHeader AS poh
JOIN Purchasing.PurchaseOrderDetail AS pod
    ON poh.PurchaseOrderID = pod.PurchaseOrderID
JOIN Purchasing.Vendor AS v
    ON poh.VendorID = v.BusinessEntityID
JOIN HumanResources.Employee AS e
    ON poh.EmployeeID = e.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory AS edh
    ON e.BusinessEntityID = edh.BusinessEntityID
   AND poh.OrderDate BETWEEN edh.StartDate
                         AND ISNULL(edh.EndDate, '9999-12-31')
JOIN HumanResources.Department AS d
    ON edh.DepartmentID = d.DepartmentID
WHERE YEAR(poh.OrderDate) = 2025
GROUP BY
    d.Name,
    v.BusinessEntityID,
    v.Name
ORDER BY
    d.Name,
    VendorRankInDepartment;