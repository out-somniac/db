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
go

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
        THROW 52000, 'Could not find category in database', 1
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
    DECLARE @msg nvarchar(1024)
    =N'An error occured while adding a product: ' + ERROR_MESSAGE();
    THROW 52000, @msg, 1;
END CATCH
END
go

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
go

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
go

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
go

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
go

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
go

-- AddIndividualReservation
CREATE PROCEDURE AddIndividualReservation
    @IndividualID int,
    @ReservationDate datetime,
    @StartDate datetime,
    @EndDate datetime,
    @Accepted bit,
    @Prepaid bit
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

    DECLARE @ClientID INT
    SELECT @ClientID = ClientID
    FROM Individuals
    WHERE IndividualID = @IndividualID 

    DECLARE @ReservationID INT
    SELECT @ReservationID = ISNULL(MAX(ReservationID), 0) + 1
    FROM Reservations

    
    INSERT INTO Reservations
        (ReservationID, ClientID, ReservationDate, StartDate, EndDate, Accepted)
    VALUES
        (@ReservationID, @ClientID, @ReservationDate, @StartDate, @EndDate, @Accepted)

    INSERT INTO IndividualReservations
        (ReservationID, Prepaid)
    VALUES
        (@ReservationID, @Prepaid)
    END TRY
    BEGIN CATCH
        DECLARE @errorMsg nvarchar(1024) = N'An error occured when adding an individual reservation: ' + ERROR_MESSAGE();
        THROW 52000, @errorMsg, 1
    END CATCH
END
go

-- AddAnonymousCompanyReservation
CREATE PROCEDURE AddIndividualReservation
    @CompanyID int,
    @ReservationDate datetime,
    @StartDate datetime,
    @EndDate datetime,
    @Accepted bit,
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
go

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
    SELECT @TableID = ISNULL(MAX(TableID), 0) + 1
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