-- ClientStats
SELECT dbo.Client.ClientID, COUNT(dbo.Orders.OrderID) AS NumberOfOrders, SUM(dbo.OrderDetails.UnitPrice) AS ValueOfOrders
FROM dbo.Orders INNER JOIN
    dbo.Client ON dbo.Orders.ClientID = dbo.Client.ClientID INNER JOIN
    dbo.OrderDetails ON dbo.Orders.OrderID = dbo.OrderDetails.OrderID
GROUP BY dbo.Client.ClientID

-- CompanyOrders
SELECT dbo.Companies.CompanyName, dbo.Orders.OrderID, dbo.Orders.OrderDate, dbo.Orders.ServingDate, SUM(dbo.OrderDetails.UnitPrice) AS OrderValue
FROM dbo.Orders INNER JOIN
    dbo.OrderDetails ON dbo.Orders.OrderID = dbo.OrderDetails.OrderID CROSS JOIN
                 dbo.Companies
GROUP BY dbo.Companies.CompanyName, dbo.Orders.OrderID, dbo.Orders.OrderDate, dbo.Orders.ServingDate

-- IndividualOrders
SELECT dbo.Individuals.FirstName, dbo.Individuals.LastName, dbo.Orders.OrderID, dbo.Orders.OrderDate, dbo.Orders.ServingDate, SUM(dbo.OrderDetails.UnitPrice) AS OrderValue
FROM dbo.Orders INNER JOIN
    dbo.OrderDetails ON dbo.Orders.OrderID = dbo.OrderDetails.OrderID INNER JOIN
    dbo.Client ON dbo.Orders.ClientID = dbo.Client.ClientID INNER JOIN
    dbo.Individuals ON dbo.Client.ClientID = dbo.Individuals.ClientID
GROUP BY dbo.Individuals.FirstName, dbo.Individuals.LastName, dbo.Orders.OrderID, dbo.Orders.OrderDate, dbo.Orders.ServingDate

-- CurrentDiscounts
SELECT dbo.Individuals.ClientID, dbo.Individuals.FirstName, dbo.Individuals.LastName, dbo.Discounts.EndDate, dbo.Discounts.Value
FROM dbo.Discounts INNER JOIN
    dbo.Individuals ON dbo.Discounts.IndividualID = dbo.Individuals.IndividualID
WHERE  (GETDATE() BETWEEN dbo.Discounts.StartDate AND dbo.Discounts.EndDate)

-- CurrentlyFreeTables
SELECT dbo.Tables.Name, dbo.Tables.MaxNumberOfGuests
FROM dbo.Reservations CROSS JOIN
                  dbo.Tables
WHERE  (NOT (GETDATE() BETWEEN dbo.Reservations.StartDate AND dbo.Reservations.EndDate))

-- CurrentMenu
SELECT dbo.Products.Name, dbo.Products.UnitPrice
FROM dbo.Menu INNER JOIN
    dbo.Products ON dbo.Menu.ProductID = dbo.Products.ProductID
WHERE  (GETDATE() BETWEEN dbo.Menu.StartDate AND dbo.Menu.EndDate) OR (dbo.Menu.EndDate IS NULL AND GETDATE() > dbo.Menu.StartDate)

-- EmployeeStats
SELECT dbo.Employees.EmployeeID, dbo.Employees.FirstName, dbo.Employees.Surename, COUNT(dbo.Orders.OrderID) AS OrdersNumber, SUM(dbo.OrderDetails.UnitPrice) AS OrdersValue
FROM dbo.Employees INNER JOIN
    dbo.Orders ON dbo.Employees.EmployeeID = dbo.Orders.EmployeeID INNER JOIN
    dbo.OrderDetails ON dbo.Orders.OrderID = dbo.OrderDetails.OrderID
GROUP BY dbo.Employees.EmployeeID, dbo.Employees.FirstName, dbo.Employees.Surename

-- GeneralProductStats
SELECT dbo.Products.ProductID, dbo.Products.Name AS ProductName, dbo.Menu.StartDate, dbo.Menu.EndDate, dbo.Menu.MenuID, COUNT(dbo.OrderDetails.OrderDetailsID) AS NumberOfOrders
FROM dbo.Products INNER JOIN
    dbo.OrderDetails ON dbo.Products.ProductID = dbo.OrderDetails.ProductID INNER JOIN
    dbo.Menu ON dbo.Products.ProductID = dbo.Menu.ProductID
GROUP BY dbo.Products.ProductID, dbo.Products.Name, dbo.Menu.StartDate, dbo.Menu.EndDate, dbo.Menu.MenuID

-- MonthlyOrderStats
SELECT YEAR(dbo.Orders.ServingDate) AS Year, MONTH(dbo.Orders.ServingDate) AS Month, COUNT(dbo.Orders.OrderID) AS OrdersNumber, SUM(dbo.OrderDetails.UnitPrice) AS OrdersValue
FROM dbo.Orders INNER JOIN
    dbo.OrderDetails ON dbo.Orders.OrderID = dbo.OrderDetails.OrderID
GROUP BY YEAR
(dbo.Orders.ServingDate), MONTH
(dbo.Orders.ServingDate)

-- WeeklyOrderStats
SELECT YEAR(dbo.Orders.ServingDate) AS Year, { fn WEEK(dbo.Orders.ServingDate) } AS Week, COUNT(dbo.Orders.OrderID) AS OrdersNumber, SUM(dbo.OrderDetails.UnitPrice) AS OrdersValue
FROM dbo.Orders INNER JOIN
    dbo.OrderDetails ON dbo.Orders.OrderID = dbo.OrderDetails.OrderID
GROUP BY YEAR(dbo.Orders.ServingDate), { fn WEEK(dbo.Orders.ServingDate) } WITH ROLLUP

-- MonthlyProductStats
SELECT dbo.Products.Name, YEAR(dbo.Orders.OrderDate) AS year, MONTH(dbo.Orders.OrderDate) AS month, COUNT(dbo.OrderDetails.OrderID) AS SoldProducts
FROM dbo.OrderDetails INNER JOIN
    dbo.Products ON dbo.OrderDetails.ProductID = dbo.Products.ProductID INNER JOIN
    dbo.Orders ON dbo.OrderDetails.OrderID = dbo.Orders.OrderID
GROUP BY dbo.Products.Name, YEAR(dbo.Orders.OrderDate), MONTH(dbo.Orders.OrderDate) WITH ROLLUP

-- ProductDetails
SELECT dbo.Products.Name, dbo.Categories.CategoryName, dbo.Products.Description
FROM dbo.Categories INNER JOIN
    dbo.Products ON dbo.Categories.CategoryID = dbo.Products.CategoryID

-- ReservationsToCheck
SELECT ReservationID, ClientID
FROM dbo.Reservations
WHERE  (Accepted = 0) AND (GETDATE() < StartDate)

-- TableReservationDetails
SELECT dbo.TableDetails.TableID, dbo.Tables.Name, COUNT(dbo.TableDetails.ReservationID) AS NumberOfReservations
FROM dbo.TableDetails INNER JOIN
    dbo.Tables ON dbo.TableDetails.TableID = dbo.Tables.TableID
GROUP BY dbo.TableDetails.TableID, dbo.Tables.Name

-- UpcommingTakeawayOrders
SELECT dbo.Client.ClientID, dbo.Client.Phone, dbo.Takeaway.PreferredDate
FROM dbo.Takeaway CROSS JOIN
                  dbo.Client
WHERE  (dbo.Takeaway.PreferredDate > GETDATE())

-- UpcommingReservations
SELECT dbo.TableDetails.ReservationID, dbo.Tables.Name AS TableName, dbo.Client.ClientID, dbo.Client.Phone, dbo.Client.Email, dbo.Reservations.StartDate, dbo.Reservations.EndDate, dbo.Reservations.Accepted
FROM dbo.Reservations INNER JOIN
    dbo.TableDetails ON dbo.Reservations.ReservationID = dbo.TableDetails.ReservationID INNER JOIN
    dbo.Tables ON dbo.TableDetails.TableID = dbo.Tables.TableID INNER JOIN
    dbo.Client ON dbo.Reservations.ClientID = dbo.Client.ClientID
WHERE  (GETDATE() < dbo.Reservations.StartDate)

-- CompanyReservationsHistory
SELECT dbo.Companies.CompanyName, dbo.Reservations.StartDate, dbo.Reservations.EndDate
FROM dbo.Client INNER JOIN
    dbo.Companies ON dbo.Client.ClientID = dbo.Companies.ClientID INNER JOIN
    dbo.Reservations ON dbo.Client.ClientID = dbo.Reservations.ClientID