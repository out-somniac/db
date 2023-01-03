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
go