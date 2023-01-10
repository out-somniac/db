
--- PRODUCTS AREA
-- AddCategory
CREATE PROCEDURE AddCategory
    @CategoryName nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    IF EXISTS(SELECT *
    FROM Categories
    WHERE @CategoryName = CategoryName)
    BEGIN;
        THROW 52000, N'Category already in database', 1
    END

    DECLARE @CategoryID INT
    SELECT @CategoryID = ISNULL(MAX(CategoryID), 0) + 1
    FROM Categories

    INSERT INTO Categories
        (CategoryID, CategoryName)
    VALUES
        (@CategoryID, @CategoryName);
END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occurred while adding a category: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1;
END CATCH
END
GO

-- AddProduct
CREATE PROCEDURE AddProduct
    @Name nvarchar(255),
    @CategoryName nvarchar(255),
    @UnitPrice money,
    @Description nvarchar(1024)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF EXISTS(
    SELECT *
    FROM Products
    WHERE Name = @Name
    )
    BEGIN;
        THROW 52000, N'Product already in database', 1
    END

    IF NOT EXISTS(
    SELECT *
    FROM Categories
    WHERE CategoryName = @CategoryName
    )
    BEGIN;
        THROW 52000, N'Could not find category in database', 1
    END

    DECLARE @CategoryID INT
    SELECT @CategoryID = CategoryID
    FROM Categories
    WHERE CategoryName = @CategoryName

    DECLARE @ProductID INT
    SELECT @ProductID = ISNULL(MAX(ProductID), 0) + 1
    FROM Products

    INSERT INTO Products
        (ProductID, CategoryID, UnitPrice, Description, Name)
    VALUES
        (@ProductID, @CategoryID, @UnitPrice, @Description, @Name);

END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occurred while adding a product: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1;
END CATCH
END
GO

-- AddToMenu
CREATE PROCEDURE AddToMenu
    @ProductName nvarchar(255),
    @StartDate datetime = NULL,
    @EndDate datetime = NULL
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT *
    FROM Products
    WHERE Name = @ProductName) BEGIN;
        THROW 52000, N'Could not a product with such a name', 1
    END

    DECLARE @ProductID INT
    SELECT @ProductID = ProductID
    FROM Products
    WHERE Name = @ProductName

    DECLARE @MenuID INT
    SELECT @MenuID = ISNULL(MAX(MenuID), 0) + 1
    FROM Menu

    IF @StartDate IS NULL BEGIN;
        -- Clever yet unreadable. Sets @StartDate as midnight of next day.
        SET @StartDate = (Select DATEADD(d, 0, DATEDIFF(d, 0, (SELECT DATEADD(day, 1, GETDATE())))))
    END

    INSERT INTO Menu
        (MenuID, ProductID, StartDate, EndDate)
    VALUES
        (@MenuID, @ProductID, @StartDate, @EndDate)
    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024) = N'An error occurred while adding a product to the menu: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO

--- RESERVATIONS AREA
-- AddIndividual
CREATE PROCEDURE AddIndividual
    @FirstName nvarchar(255),
    @LastName nvarchar(255),
    @Address nvarchar(255),
    @Phone nvarchar(15),
    @Email nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF EXISTS (SELECT *
    FROM Client
    WHERE Address = @Address)
    BEGIN;
        THROW 52000, N'Given address is already in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Client
    WHERE Phone = @Phone)
    BEGIN;
        THROW 52000, N'Given phone is already in database', 1
    END

    IF EXISTS (SELECT *
    FROM Client
    WHERE Email = @Email)
    BEGIN;
        THROW 52000, N'Given email is already in database', 1
    END

    DECLARE @ClientID INT
    SELECT @ClientID = ISNULL(MAX(ClientID), 0) + 1
    FROM Client

    DECLARE @IndividualID INT
    SELECT @IndividualID = ISNULL(MAX(IndividualID), 0) + 1
    FROM Individuals

    INSERT INTO Client
        (ClientID, Address, Phone, Email)
    VALUES
        (@ClientID, @Address, @Phone, @Email)

    INSERT INTO Individuals
        (IndividualID, ClientID, FirstName, LastName)
    VALUES
        (@IndividualID, @ClientID, @FirstName, @LastName)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occurred while adding an individual client: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO

-- AddCompany
CREATE PROCEDURE AddCompany
    @CompanyName nvarchar(255),
    @NIP nvarchar(255),
    @Address nvarchar(255),
    @Phone nvarchar(15),
    @Email nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF EXISTS (SELECT *
    FROM Companies
    WHERE CompanyName = @CompanyName)
    BEGIN;
        THROW 52000, N'Given company name is already registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Companies
    WHERE NIP = @NIP)
    BEGIN;
        THROW 52000, N'Given NIP is already registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Client
    WHERE Address = @Address)
    BEGIN;
        THROW 52000, N'Given address is already in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Client
    WHERE Phone = @Phone)
    BEGIN;
        THROW 52000, N'Given phone is already in database', 1
    END

    IF EXISTS (SELECT *
    FROM Client
    WHERE Email = @Email)
    BEGIN;
        THROW 52000, N'Given email is already in database', 1
    END

    DECLARE @ClientID INT
    SELECT @ClientID = ISNULL(MAX(ClientID), 0) + 1
    FROM Client

    DECLARE @CompanyID INT
    SELECT @CompanyID = ISNULL(MAX(CompanyID), 0) + 1
    FROM Companies

    INSERT INTO Client
        (ClientID, Address, Phone, Email)
    VALUES
        (@ClientID, @Address, @Phone, @Email)

    INSERT INTO Companies
        (CompanyID, ClientID, CompanyName, NIP)
    VALUES
        (@CompanyID, @ClientID, @CompanyName, @NIP)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occurred while adding a company: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO


-- AddIndividualReservation
CREATE PROCEDURE AddIndividualReservation
    @IndividualID int,
    @StartDate datetime,
    @EndDate datetime,
    @Prepaid bit,
    @EmployeeID int,
    @OrderDate datetime,
    @ServingDate datetime = NULL,
    @NumberOfGuests int,
    @ProductIDs ProductList READONLY
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF NOT EXISTS(SELECT *
    FROM Individuals
    WHERE IndividualID = @IndividualID)
    BEGIN;
        THROW 52000,'Individual is not registered in database', 1
    END

    IF dbo.CanMakeReservation(@IndividualID, @ProductIDs) = 1 BEGIN
        THROW 52000,'This individual has not yet made enough orders to make a reservation', 1
    END

        IF dbo.HasSeafood(@ProductIDs) = 1 BEGIN
        IF @ServingDate IS NULL BEGIN;
            THROW 52000, 'Cannot order seafood without specifying when it will be served', 1
        END
        IF (SELECT DATEPART(WEEKDAY, @ServingDate) - 1) BETWEEN 4 AND 6 BEGIN;
            THROW 52000, 'Trying to order seafood for days other than Thursday, Friday, Saturday', 1
        END
        IF dbo.CanOrderSeafood(@OrderDate, @ServingDate) = 1 BEGIN;
            THROW 52000, 'Must order seafood before tuesday preceding serving date', 1
        END
    END

        DECLARE @ClientID INT
        SELECT @ClientID = ClientID
    FROM Individuals
    WHERE IndividualID = @IndividualID

        DECLARE @OrderID INT
        SELECT @OrderID = ISNULL(MAX(OrderID), 0) + 1
    FROM Orders

        DECLARE @ReservationID INT
        SELECT @ReservationID = ISNULL(MAX(ReservationID), 0) + 1
    FROM Reservations

        INSERT INTO Reservations
        (ReservationID, ClientID, StartDate, EndDate, Accepted, NumberOfGuests)
    VALUES
        (@ReservationID, @ClientID, @StartDate, @EndDate, 0, @NumberOfGuests)

        INSERT INTO IndividualReservations
        (ReservationID, OrderID, Prepaid)
    VALUES
        (@ReservationID, @OrderID, @Prepaid)

        INSERT INTO Orders
        (OrderID, EmployeeID, OrderDate, ServingDate, ClientID)
    VALUES
        (@OrderID, @EmployeeID, @OrderDate, @ServingDate, @ClientID)

    DECLARE @Discount AS DECIMAL(10, 2) = (100 - dbo.GetCurrentDiscount(@IndividualID, @OrderDate)) / 100
        INSERT INTO OrderDetails
        (OrderID, ProductID, UnitPrice)

    SELECT @OrderID, list.ProductID, (SELECT UnitPrice * @Discount
        FROM Products AS P
        WHERE list.ProductID = P.ProductID)
    FROM @ProductIDs as list

        END
    TRY
    BEGIN CATCH
    DECLARE @errorMsg nvarchar(1024) = N'An error occurred when adding an individual reservation: ' + ERROR_MESSAGE();
    THROW 52000, @errorMsg, 1
    END CATCH
END
GO

-- AddNamedCompanyReservation
CREATE PROCEDURE AddNamedCompanyReservation
    @CompanyID int,
    @ReservationDate datetime,
    @StartDate datetime,
    @EndDate datetime,
    @IndividualsIDs IndividualsList READONLY
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF NOT EXISTS(SELECT *
    FROM Companies
    WHERE CompanyID = @CompanyID)
    BEGIN;
        THROW 52000,'Company is not registered in database', 1
    END

    IF EXISTS (SELECT COUNT(*)
    FROM @IndividualsIDs
    GROUP BY IndividualID
    HAVING COUNT(*) > 1) BEGIN;
        THROW 52000, 'Can not add the same individual to the reservation twice.', 1
    END

    DECLARE @NumberOfGuests INT
    SET @NumberOfGuests = (SELECT COUNT(*)
    FROM @IndividualsIDs)

    DECLARE @ClientID INT
    SELECT @ClientID = ClientID
    FROM Companies
    WHERE CompanyID = @CompanyID

    DECLARE @ReservationID INT
    SELECT @ReservationID = ISNULL(MAX(ReservationID), 0) + 1
    FROM Reservations


    INSERT INTO Reservations
        (ReservationID, ClientID, ReservationDate, StartDate, EndDate, Accepted, NumberOfGuests)
    VALUES
        (@ReservationID, @ClientID, @ReservationDate, @StartDate, @EndDate, 0, @NumberOfGuests)

    INSERT INTO CompanyReservations
        (ReservationID)
    VALUES
        (@ReservationID)

    INSERT INTO CompanyReservationsDetails
        (IndividualID, ReservationID)
    SELECT list.IndividualID, @ReservationID
    FROM @IndividualsIDs as list

    END TRY
    BEGIN CATCH
        DECLARE @errorMsg nvarchar(1024) = N'An error occurred when adding a named company reservation: ' + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1
    END CATCH
END
GO


-- AddAnonymousCompanyReservation
CREATE PROCEDURE AddAnonymousCompanyReservation
    @CompanyID int,
    @ReservationDate datetime,
    @StartDate datetime,
    @EndDate datetime,
    @NumberOfGuests int
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF NOT EXISTS(SELECT *
    FROM Companies
    WHERE CompanyID = @CompanyID)
    BEGIN;
        THROW 52000,'Company is not registered in database', 1
    END

    DECLARE @ClientID INT
    SELECT @ClientID = ClientID
    FROM Companies
    WHERE CompanyID = @CompanyID

    DECLARE @ReservationID INT
    SELECT @ReservationID = ISNULL(MAX(ReservationID), 0) + 1
    FROM Reservations


    INSERT INTO Reservations
        (ReservationID, ClientID, ReservationDate, StartDate, EndDate, Accepted, NumberOfGuests)
    VALUES
        (@ReservationID, @ClientID, @ReservationDate, @StartDate, @EndDate, 0, @NumberOfGuests)

    INSERT INTO CompanyReservations
        (ReservationID)
    VALUES
        (@ReservationID)

    END TRY
    BEGIN CATCH
        DECLARE @errorMsg nvarchar(1024) = N'An error occurred when adding an anonymous company reservation: ' + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1
    END CATCH
END
GO

-- AcceptReservation
CREATE PROCEDURE AcceptReservation
    @ReservationID INT,
    @TableIDs TablesList READONLY
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @TableID INT = 0
    DECLARE @NumberOfGuests INT = 0
    WHILE (1 = 1)
    BEGIN
        SELECT TOP 1
            @TableID = TableID,
            @NumberOfGuests = NumberOfGuests
        FROM @TableIDs
        WHERE TableID > @TableID
        ORDER BY TableID

        IF @@ROWCOUNT = 0 BREAK;

        EXEC dbo.AddTableToReservation @ReservationID, @NumberOfGuests, @TableID
    END

    UPDATE Reservations
    SET Accepted = 1
    WHERE ReservationID = @ReservationID
END
GO

-- EMPLOYEES AREA
-- AddEmployee
CREATE PROCEDURE AddEmployee
    @FirstName nvarchar(255),
    @SureName nvarchar(255),
    @BirthDate date
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    DECLARE @EmployeeID INT
    SELECT @EmployeeID = ISNULL(MAX(EmployeeID), 0) + 1
    FROM Employees

    INSERT INTO Employees
        (EmployeeID, FirstName, SureName, BirthDate)
    VALUES
        (@EmployeeID, @FirstName, @SureName, @BirthDate)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occurred while adding an employee: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO

-- MakeManager
CREATE PROCEDURE MakeManager
    @EmployeeID int
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF NOT EXISTS (SELECT *
    FROM Employees
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employee with given EmployeeID number is not registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Administrators
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employee with given EmployeeID is already an administrator', 1
    END

    IF EXISTS (SELECT *
    FROM Managers
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employee with given EmployeeID is already a manager', 1
    END

    INSERT INTO Managers
        (EmployeeID)
    VALUES
        (@EmployeeID)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occurred while making employee a manager: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO

-- MakeAdministrator
CREATE PROCEDURE MakeAdministrator
    @EmployeeID int
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF NOT EXISTS (SELECT *
    FROM Employees
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employee with given EmployeeID number is not registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Managers
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employee with given EmployeeID is already a manager', 1
    END

    IF EXISTS (SELECT *
    FROM Administrators
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employee with given EmployeeID is already an administrator', 1
    END

    INSERT INTO Administrators
        (EmployeeID)
    VALUES
        (@EmployeeID)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occurred while making employee an administrator: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO

--- ORDERS AREA
-- AddTable
CREATE PROCEDURE AddTable
    @Name nvarchar(255),
    @MaxNumberOfGuests INT

AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    IF EXISTS(SELECT *
    FROM Tables
    WHERE Name = @Name)
    BEGIN;
        THROW 52000,'Table with this name is already registered', 1
    END

    DECLARE @TableID INT
    SELECt @TableID = ISNULL(MAX(TableID), 0) + 1
    FROM Tables

    INSERT INTO Tables
        (TableID, Name, MaxNumberOfGuests)
    VALUES
        (@TableID, @Name, @MaxNumberOfGuests)

    END TRY
    BEGIN CATCH
        DECLARE @errorMsg nvarchar(1024) = N'An error occurred when adding a table: ' + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1
    END CATCH
END
GO

-- AddTableToReservation
CREATE PROCEDURE AddTableToReservation
    @ReservationID int,
    @NumberOfGuests int,
    @TableID int
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    IF NOT EXISTS(
    SELECT *
    FROM Tables
    WHERE TableID = @TableID
    )
    BEGIN;
        THROW 52000, 'Table was not registered in the database', 1
    END

    DECLARE @StartDate DATETIME
    SELECT @StartDate = StartDate
    FROM Reservations
    WHERE ReservationID = @ReservationID
    DECLARE @EndDate DATETIME
    SELECT @EndDate = EndDate
    FROM Reservations
    WHERE ReservationID = @ReservationID

    IF EXISTS (
    SELECT R.ReservationID, R.NumberOfGuests, TD.TableID, TD.NumberOfGuests
    FROM Reservations AS R
        INNER JOIN TableDetails TD on R.ReservationID = TD.ReservationID
    WHERE TD.TableID = @TableID AND
        (R.StartDate BETWEEN @StartDate AND @EndDate OR R.EndDate BETWEEN @StartDate AND @EndDate )) BEGIN;
        THROW 52000, 'Table is already in use at the time of this reservation', 1
    END

    IF NOT EXISTS(
    SELECT *
    FROM Reservations
    WHERE ReservationID = @ReservationID
    )
    BEGIN;
        THROW 52000, 'No reservation with this ID was made', 1
    END

    INSERT INTO TableDetails
        (TableID, NumberOfGuests, ReservationID)
    VALUES
        (@TableID, @NumberOfGuests, @ReservationID)
END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occurred while adding a table to a reservation: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1
END CATCH
END
GO

-- AddOrder
CREATE PROCEDURE AddOrder
    @EmployeeID int,
    @OrderDate datetime,
    @ServingDate datetime = NULL,
    @ClientID int = NULL,
    @ProductIDs ProductList READONLY
AS
BEGIN
    BEGIN TRY
    IF NOT EXISTS (SELECT *
    FROM Employees
    WHERE EmployeeID = @EmployeeID) BEGIN;
        THROW 52000, 'Employee with given ID was not registered in the database', 1
    END

    IF dbo.HasSeafood(@ProductIDs) = 1 BEGIN
        IF @ServingDate IS NULL BEGIN;
            THROW 52000, 'Cannot order seafood without specifying when it will be served', 1
        END
        IF (SELECT DATEPART(WEEKDAY, @ServingDate) - 1) BETWEEN 4 AND 6 BEGIN;
            THROW 52000, 'Trying to order seafood for days other than Thursday, Friday, Saturday', 1
        END
        IF dbo.CanOrderSeafood(@OrderDate, @ServingDate) = 1 BEGIN
        THROW 52000, 'Must order seafood before tuesday preceding serving date', 1
    END
    END

    DECLARE @OrderID INT
    SELECT @OrderID = ISNULL(MAX(OrderID), 0) + 1
    FROM Orders

    INSERT INTO Orders
        (OrderID, EmployeeID, OrderDate, ServingDate, ClientID)
    VALUES
        (@OrderID, @EmployeeID, @OrderDate, @ServingDate, @ClientID)

    -- TODO: Same as in IndividualReservations - does not account for discounts
    INSERT INTO OrderDetails
        (OrderID, ProductID, UnitPrice)
    SELECT @OrderID, list.ProductID, (SELECT UnitPrice
        FROM Products AS P
        WHERE list.ProductID = P.ProductID)
    FROM @ProductIDs as list

END
    TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occurred while adding an order: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1
    END CATCH
END
GO

-- MakeTakeaway
CREATE PROCEDURE MakeTakeaway
    @OrderID int,
    @PreferredDate datetime
AS
BEGIN
    BEGIN TRY

    IF NOT EXISTS (SELECT *
    FROM Orders
    WHERE OrderID = @OrderID) BEGIN;
        THROW 52000, N'An order with given ID is not registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Takeaway
    WHERE OrderID = @OrderID) BEGIN;
        THROW 52000, N'The order with given ID is already a takeaway', 1
    END

    INSERT INTO Takeaway
        (OrderID, PreferredDate)
    VALUES
        (@OrderID, @PreferredDate)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024) = N'An error occurred while making an order a takeaway order: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1
        END CATCH
END
GO


--- PARAMETERS AREA
-- ChangeParameter
CREATE PROCEDURE ChangeParameter
    @ParameterID varchar(2),
    @Value int
AS
BEGIN
    BEGIN TRY

    IF NOT EXISTS (SELECT *
    FROM Parameters
    WHERE ParameterID = @ParameterID) BEGIN;
        THROW 52000, N'An parameter with given name is not registered in the database', 1
    END
    UPDATE Parameters SET Value = @Value WHERE ParameterID = @ParameterID

END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occurred while changing a value of a parameter: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1
END CATCH
END
GO

-- ChangeDiscountParameters
CREATE PROCEDURE ChangeDiscountParameters
    @ParameterName varchar(2),
    @Value int,
    @StartDate datetime,
    @EndDate datetime = NULL
AS
BEGIN
    BEGIN TRY

    IF NOT EXISTS (SELECT *
    FROM DiscountParameters
    WHERE ParameterName = @ParameterName) BEGIN;
        THROW 52000, N'An parameter with given name is not registered in the database', 1
    END

    UPDATE DiscountParameters SET EndDate = GETDATE() WHERE ParameterName = @ParameterName AND EndDate IS NULL

    DECLARE @ParameterID INT
    SELECT @ParameterID = ISNULL(MAX(ParameterID), 0) + 1
    FROM DiscountParameters

    INSERT INTO DiscountParameters
        (ParameterID, ParameterName, StartDate, EndDate, Value)
    VALUES
        (@ParameterID, @ParameterName, @StartDate, @EndDate, @Value)

    END TRY

    BEGIN CATCH
        DECLARE @msg nvarchar(1024) = N'An error occurred while changing a value of a  discount parameter: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1
    END CATCH
END
GO