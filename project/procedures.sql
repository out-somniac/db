
--- PRODUCTS AREA
-- AddCategory 
CREATE PROCEDURE AddCategory
    @CategoryName varchar(255)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY 
    IF EXISTS(SELECT *
    FROM Category
    WHERE @CategoryName = CategoryName)
    BEGIN;
        THROW 52000, N'Category already in database', 1
    END
    
    DECLARE @CategoryID INT
    SELECT @CategoryID = ISNULL(MAX(CategoryID), 0) + 1
    FROM Category
    
    INSERT INTO Category
        (CategoryID, CategoryName)
    VALUES
        (@CategoryID, @CategoryName);
END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occured while adding a category: ' + ERROR_MESSAGE();
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
    FROM Category
    WHERE CategoryName = @CategoryName
    )
    BEGIN;
        THROW 52000, N'Could not find category in database', 1
    END

    DECLARE @CategoryID INT
    SELECT @CategoryID = CategoryID
    FROM Category
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
    DECLARE @msg nvarchar(1024) = N'An error occured while adding a product: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1;
END CATCH
END
GO

-- AddToMenu
CREATE PROCEDURE AddToMenu
    @ProductName nvarchar(255),
    @StartDate datetime,
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

    INSERT INTO Menu
        (MenuID, ProductID, StartDate, EndDate)
    VALUES
        (@MenuID, @ProductID, @StartDate, @EndDate)
    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024) = N'An error occured while adding a product to the menu: ' + ERROR_MESSAGE();
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
        =N'An error occured while adding an individual client: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO

-- AddCompany
CREATE PROCEDURE AddIndividual
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
    FROM Compnanies

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
        =N'An error occured while adding a company: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1;
    END CATCH
END
GO



-- AddIndividualReservation
-- CREATE PROCEDURE AddIndividualReservation
--     @IndividualID int,
--     @ReservationDate datetime,
--     @StartDate datetime,
--     @EndDate datetime,
--     @Accepted bit,
--     @Prepaid bit,
--     @EmployeeID int,
--     @OrderDate datetime,
--     @ServingDate datetime = NULL
-- AS
-- BEGIN
--     SET NOCOUNT ON
--     BEGIN TRY 
--     
--     IF NOT EXISTS(SELECT *
--     FROM Individuals
--     WHERE IndividualID = @IndividualID)
--     BEGIN;
--         THROW 52000,'Individual is not registered in database', 1
--     END
-- 
--     DECLARE @ClientID INT
--     SELECT @ClientID = ClientID
--     FROM Individuals
--     WHERE IndividualID = @IndividualID 
-- 
--     DECLARE @OrderID INT
--     SELECT @OrderID = ISNULL(MAX(OrderID), 0) + 1
--     FROM Orders
-- 
--     -- Warning! This could result in errors - There might be more reservations than orders
--     INSERT INTO Reservations
--         (ReservationID, ClientID, ReservationDate, StartDate, EndDate, Accepted)
--     VALUES
--         (@OrderID, @ClientID, @ReservationDate, @StartDate, @EndDate, @Accepted)
-- 
--     INSERT INTO IndividualReservations
--         (ReservationID, Prepaid)
--     VALUES
--         (@OrderID, @Prepaid)
-- 
-- 
-- 
--     INSERT INTO Orders
--         (OrderID, EmployeeID, OrderDate, ServingDate, ClientID)
--     VALUES
--         (@OrderID, @EmployeeID, @OrderDate, @ServingDate, @ClientID)
-- 
--     END TRY
--     BEGIN CATCH
--         DECLARE @errorMsg nvarchar(1024) = N'An error occured when adding an individual reservation: ' + ERROR_MESSAGE();
--         THROW 52000, @errorMsg, 1
--     END CATCH
-- END
-- GO

-- AddCompanyReservation
CREATE PROCEDURE AddIndividualReservation
    @CompanyID int,
    @ReservationDate datetime,
    @StartDate datetime,
    @EndDate datetime,
    @Accepted bit,
    @NumberOfGuests int = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY 
    
    IF @NumberOfGuests IS NULL BEGIN;
        SET @NumberOfGuests = 0
    END

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
        (ReservationID, ClientID, ReservationDate, StartDate, EndDate, Accepted)
    VALUES
        (@ReservationID, @ClientID, @ReservationDate, @StartDate, @EndDate, @Accepted)

    INSERT INTO CompanyReservations
        (ReservationID, NumberOfGuests)
    VALUES
        (@ReservationID, @NumberOfGuests)
    END TRY
    BEGIN CATCH
        DECLARE @errorMsg nvarchar(1024) = N'An error occured when adding an anonymous company reservation: ' + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1
    END CATCH
END
GO

-- AddPersonToCompanyReservation
CREATE PROCEDURE AddPersonToCompanyReservation
    @IndividualID int,
    @ReservationID int
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

    IF NOT EXISTS(SELECT *
    FROM Reservations
    WHERE ReservationID = @ReservationID)
    BEGIN;
        THROW 52000,'Reservation is not registered in database', 1
    END

    IF EXISTS(SELECT *
    FROM CompanyReservationDetails
    WHERE ReservationID = @ReservationID AND IndividualID = @IndividualID) BEGIN;
        THROW 52000, N'This person was already added to this reservation', 1
    END

    INSERT INTO CompanyReservationDetails
        (IndividualID, ReservationID)
    VALUES
        (@IndividualID, @ReservationID)


    UPDATE CompanyReservations
        SET NumberOfGuests = NumberOfGuests + 1
        WHERE ReservationID = @ReservationID
    -- Should this throw an error when the number of guestr exceeds currently planed number of tables?
    END TRY
    BEGIN CATCH
        DECLARE @errorMsg nvarchar(1024) = N'An error occured when adding a client to a company reservation: ' + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1
    END CATCH
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
        =N'An error occured while adding an employee: ' + ERROR_MESSAGE();
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
        THROW 52000, N'Employe with given EmployeeID number is not registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Administrators
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employe with given EmployeeID is already an administrator', 1
    END

    IF EXISTS (SELECT *
    FROM Managers
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employe with given EmployeeID is already a manager', 1
    END

    INSERT INTO Managers
        (EmployeeID)
    VALUES
        (@EmployeeID)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occured while making employee a manager: ' + ERROR_MESSAGE();
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
        THROW 52000, N'Employe with given EmployeeID number is not registered in the database', 1
    END

    IF EXISTS (SELECT *
    FROM Manager
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employe with given EmployeeID is already a manager', 1
    END

    IF EXISTS (SELECT *
    FROM Administrators
    WHERE EmployeeID = @EmployeeID)
    BEGIN;
        THROW 52000, N'Employe with given EmployeeID is already an administrator', 1
    END

    INSERT INTO Administrators
        (EmployeeID)
    VALUES
        (@EmployeeID)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024)
        =N'An error occured while making employee an administrator: ' + ERROR_MESSAGE();
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
        DECLARE @errorMsg nvarchar(1024) = N'An error occured when adding a table: ' + ERROR_MESSAGE();
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

    IF NOT EXISTS(
    SELECT *
    FROM Reservations
    WHERE ReservationID = @ReservationID
    )
    BEGIN;
        THROW 52000, 'No reservation with this ID was made', 1
    END

    -- Does not check if table is already used by another reservations    
    INSERT INTO TableDetails
        (TableID, NumberOfGuests, ReservationID)
    VALUES
        (@TableID, @NumberOfGuests, @ReservationID)
END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occured while adding a table to a reservation: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1
END CATCH
END
GO

-- AddOrder
CREATE PROCEDURE AddOrder
    @EmployeeID int,
    @OrderDate datetime,
    @ServingDate datetime = NULL,
    @ClientID int = NULL
AS
BEGIN
    BEGIN TRY 
    IF NOT EXISTS (SELECT *
    FROM Employees
    WHERE EmployeeID = @EmployeeID) BEGIN;
        THROW 52000, 'Employee with given ID was not registered in the database', 1
    END

    DECLARE @OrderID INT
    SELECT @OrderID = ISNULL(MAX(OrderID), 0) + 1
    FROM Orders

    INSERT INTO Orders
        (OrderID, EmployeeID, OrderDate, ServingDate, ClientID)
    VALUES
        (@OrderID, @EmployeeID, @OrderDate, @ServingDate, @ClientID)
END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occured while adding an order: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1
END CATCH
END
GO

-- AddProductToOrder
CREATE PROCEDURE AddProductToOrder
    @OrderID int,
    @ProductName nvarchar(255)
AS
BEGIN

    BEGIN TRY
    IF NOT EXISTS (SELECT *
    FROM Orders
    WHERE OrderID = @OrderID) BEGIN;
        THROW
        52000, N'An order with specified ID is not registered in the database', 1
    END

    IF NOT EXISTS (SELECT *
    FROM Products
    WHERE @ProductName = Name) BEGIN;
        THROW
        52000, N'A product with specified name is not registered in the database', 1
    END

    DECLARE @OrderDetailsID INT
    SELECT @OrderDetailsID = ISNULL(MAX(OrderDetailsID), 0) + 1
    FROM OrderDetails


    DECLARE @ProductID INT
    DECLARE @UnitPrice money
    SELECT @ProductID = ProductID, @UnitPrice = UnitPrice
    FROM Products
    WHERE Name = @ProductName

    INSERT INTO OrderDetails
        (OrderDetailsID, OrderID, ProductID, UnitPrice)
    VALUES
        (@OrderDetailsID, @OrderID, @ProductID, @UnitPrice)

    
END TRY
BEGIN CATCH
    DECLARE @msg nvarchar(1024) = N'An error occured while adding a table to a reservation: ' + ERROR_MESSAGE();
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
        (@OrderID, @ProferredDate)

    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(1024) = N'An error occured while making an order a takeaway order: ' + ERROR_MESSAGE();
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
    DECLARE @msg nvarchar(1024) = N'An error occured while changing a value of a parameter: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1
END CATCH
END
GO

-- ChangeDiscoundParameters
CREATE PROCEDURE ChangeDiscoundParameters
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

    UPDATE Parameters SET EndDate = GETDATE() WHERE ParameterName = @ParameterName AND EndDate IS NULL

    DECLARE @ParameterID INT
    SELECT @ParameterID = ISNULL(MAX(ParameterID), 0) + 1
    FROM DiscountParameters

    INSERT INTO DiscountParameters
        (ParameterID, ParameterName, StartDate, EndDate, Value)
    VALUES
        (@ParameterID, @ParameterName, @StartDate, @EndDate, Value)

    END TRY

    BEGIN CATCH
        DECLARE @msg nvarchar(1024) = N'An error occured while changing a value of a  discount parameter: ' + ERROR_MESSAGE();
        THROW 52000, @msg, 1
    END CATCH
END
GO