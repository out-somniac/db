-- AddIndividualReservation
CREATE PROCEDURE AddReservation
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