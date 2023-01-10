CREATE FUNCTION CanOrderSeafood(@OrderDate DATETIME, @ServingDate DATETIME)
RETURNS BIT
AS
BEGIN
    IF @OrderDate <= dbo.GetPreviousMonday(@ServingDate)
        RETURN 1

    RETURN 0
END
GO

CREATE FUNCTION GetPreviousMonday(@Date DATETIME)
RETURNS DATETIME
AS
BEGIN
    RETURN DATEADD(DD,-(DATEPART(WEEKDAY, GETDATE())+5)%7, @Date)
END
GO

CREATE FUNCTION HasSeafood(@ProductIDs ProductList READONLY)
RETURNS BIT
AS 
BEGIN
    IF EXISTS (
    SELECT *
    FROM @ProductIDs as L
        INNER JOIN Products AS P ON L.ProductID = P.ProductID
        INNER JOIN Categories C on P.CategoryID = C.CategoryID
    WHERE C.CategoryName LIKE 'Owoce morza')
        RETURN 1

    RETURN 0
END
GO

CREATE FUNCTION CanMakeReservation(@IndividualID INT, @ProductIDs ProductList READONLY)
RETURNS BIT
AS
BEGIN
    DECLARE @WZ INT
    SELECT @WZ = Value
    FROM Parameters
    WHERE ParameterID LIKE 'WZ'

    DECLARE @WK INT
    SELECT @WK = Value
    FROM Parameters
    WHERE ParameterID LIKE 'WK'

    DECLARE @ClientID INT
    SELECT @ClientID = ClientID
    FROM Individuals
    WHERE IndividualID = @IndividualID

    DECLARE @OrdersTotal INT
    SET @OrdersTotal = (SELECT COUNT(*)
    FROM Orders
    WHERE ClientID = @ClientID)

    DECLARE @PriceTotal money
    SET @PriceTotal = (SELECT SUM(P.UnitPrice)
    FROM @ProductIDs AS IDs INNER JOIN Products AS P ON P.ProductID
    = IDs.ProductID)

    IF @PriceTotal >= @WZ AND @OrdersTotal >= @WK BEGIN
        RETURN 1
    END
    RETURN 0
END
GO

CREATE FUNCTION GetCurrentDiscount(@IndividualID INT, @Date DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @result INT
    SET @result = (SELECT D.Value
    FROM Individuals AS I
        INNER JOIN Discounts D on I.IndividualID = D.IndividualID
    WHERE I.IndividualID = @IndividualID AND @Date BETWEEN D.StartDate AND D.EndDate)
    RETURN @result
END