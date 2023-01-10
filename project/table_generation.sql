--- Products Area

-- Table: Categories
CREATE TABLE Categories
(
    CategoryID int NOT NULL,
    CategoryName nvarchar NOT NULL,
    CONSTRAINT Categories_pk PRIMARY KEY  (CategoryID)
);

-- Table: Products
CREATE TABLE Products
(
    ProductID int NOT NULL,
    CategoryID int NOT NULL,
    UnitPrice money NOT NULL,
    Description nvarchar NOT NULL DEFAULT '',
    CONSTRAINT ValidUnitPrice CHECK (UnitPrice > 0),
    CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);

ALTER TABLE Products ADD CONSTRAINT Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories (CategoryID);

-- Table: Menu
CREATE TABLE Menu
(
    MenuID int NOT NULL,
    ProductID int NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    CONSTRAINT Menu_pk PRIMARY KEY  (MenuID)
);

ALTER TABLE Menu ADD CONSTRAINT Products_Menu
FOREIGN KEY (ProductID)
REFERENCES Products (ProductID);

--- Employees Area

-- Table: Employees
CREATE TABLE Employees
(
    EmployeeID int NOT NULL,
    FirstName nvarchar NOT NULL,
    Surename nvarchar NOT NULL,
    BirthDate date NOT NULL,
    Role nvarchar NOT NULL,
    CONSTRAINT ValidBirthDate CHECK (BirthDate < GETDATE()),
    CONSTRAINT Employees_pk PRIMARY KEY  (EmployeeID)
);

-- Table: Managers
CREATE TABLE Managers
(
    EmployeeID int NOT NULL,
    CONSTRAINT Managers_pk PRIMARY KEY  (EmployeeID)
);

ALTER TABLE Managers ADD CONSTRAINT Employees_Managers
FOREIGN KEY (EmployeeID)
REFERENCES Employees (EmployeeID);

-- Table: Administrators
CREATE TABLE Administrators
(
    EmployeeID int NOT NULL,
    CONSTRAINT Administrators_pk PRIMARY KEY  (EmployeeID)
);

ALTER TABLE Administrators ADD CONSTRAINT Employees_Administrators
FOREIGN KEY (EmployeeID)
REFERENCES Employees (EmployeeID);

--- Orders Area
-- Table: Orders
CREATE TABLE Orders
(
    OrderID int NOT NULL,
    EmployeeID int NOT NULL,
    OrderDate datetime NOT NULL DEFAULT GETDATE(),
    ServingDate datetime NOT NULL,
    ClientID int NULL,
    CONSTRAINT OrderID PRIMARY KEY  (OrderID)
);
ALTER TABLE Orders ADD CONSTRAINT Client_Orders
FOREIGN KEY (ClientID)
REFERENCES Client (ClientID);

ALTER TABLE Orders ADD CONSTRAINT Orders_Employees
FOREIGN KEY (EmployeeID)
REFERENCES Employees (EmployeeID);

-- Table: OrderDetails
CREATE TABLE OrderDetails
(
    OrderDetailsID int NOT NULL IDENTITY(1, 1),
    OrderID int NOT NULL,
    ProductID int NOT NULL,
    UnitPrice money NOT NULL,
    CONSTRAINT ValidUnitPrice CHECK (UnitPrice > 0),
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderDetailsID)
);
ALTER TABLE OrderDetails ADD CONSTRAINT Order_OrdersDetails
FOREIGN KEY (OrderID)
REFERENCES Orders (OrderID);

ALTER TABLE OrderDetails ADD CONSTRAINT Products_OrderDetails
FOREIGN KEY (ProductID)
REFERENCES Products (ProductID);

-- Table: Takeaway
CREATE TABLE Takeaway
(
    OrderID int NOT NULL,
    PreferredDate datetime NOT NULL,
    CONSTRAINT ValidPreferredDate CHECK (PreferredDate > GETDATE()),
    CONSTRAINT Takeaway_pk PRIMARY KEY  (OrderID)
);

ALTER TABLE Takeaway ADD CONSTRAINT Takeaway_Orders
FOREIGN KEY (OrderID)
REFERENCES Orders (OrderID);

-- Table: TableDetails
CREATE TABLE TableDetails
(
    TableID int NOT NULL,
    NumberOfGuests int NOT NULL,
    ReservationID int NOT NULL,
    CONSTRAINT ValidNumberOfGuests CHECK (NumberOfGuests > 0),
    CONSTRAINT TableDetails_pk PRIMARY KEY  (TableID)
);

ALTER TABLE TableDetails ADD CONSTRAINT TableDetails_Reservations
FOREIGN KEY (ReservationID)
REFERENCES Reservations (ReservationID);

ALTER TABLE TableDetails ADD CONSTRAINT Tables_TableDetails
FOREIGN KEY (TableID)
REFERENCES Tables (TableID);

-- Table: Tables
CREATE TABLE Tables
(
    TableID int NOT NULL,
    Name nvarchar NOT NULL,
    MaxNumberOfGuests int NOT NULL,
    CONSTRAINT UniqueName UNIQUE (Name),
    CONSTRAINT ValidMaxNumberOfGuests CHECK (MaxNumberOfGuests > 0),
    CONSTRAINT Tables_pk PRIMARY KEY  (TableID)
);

--- Reservations Area
-- Table: Client
CREATE TABLE Client
(
    ClientID int NOT NULL,
    Address nvarchar NOT NULL,
    Phone nvarchar NOT NULL,
    Email nvarchar NOT NULL,
    CONSTRAINT ValidPhone CHECK (Phone LIKE '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT UniquePhone UNIQUE (Phone),
    CONSTRAINT ValidEmail CHECK (Email LIKE '%@%'),
    CONSTRAINT UniqueEmail UNIQUE (Email),
    CONSTRAINT Client_pk PRIMARY KEY (ClientID)
);

-- Table: Companies
CREATE TABLE Companies
(
    CompanyID int NOT NULL,
    ClientID int NOT NULL,
    CompanyName nvarchar NOT NULL,
    NIP nvarchar NOT NULL,
    CONSTRAINT ValidNIP CHECK (NIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT UniqueNIP UNIQUE (NIP),
    CONSTRAINT Companies_pk PRIMARY KEY  (CompanyID)
);

ALTER TABLE Companies ADD CONSTRAINT Client_Companies
FOREIGN KEY (ClientID)
REFERENCES Client (ClientID);

-- Table: CompanyReservations
CREATE TABLE CompanyReservations
(
    ReservationID int NOT NULL,
    CONSTRAINT CompanyReservations_pk PRIMARY KEY  (ReservationID)
);

ALTER TABLE CompanyReservations ADD CONSTRAINT Reservations_CompanyReservations
FOREIGN KEY (ReservationID)
REFERENCES Reservations (ReservationID);

-- Table: CompanyReservationsDetails
CREATE TABLE CompanyReservationsDetails
(
    IndividualID int NOT NULL,
    ReservationID int NOT NULL,
    CONSTRAINT CompanyReservationsDetails_pk PRIMARY KEY  (ReservationID, IndividualID)
);

ALTER TABLE CompanyReservationsDetails ADD CONSTRAINT CompanyReservationsDetails_Individuals
FOREIGN KEY (IndividualID)
REFERENCES Individuals (IndividualID);

ALTER TABLE CompanyReservationsDetails ADD CONSTRAINT ReservationCompanyDetails_ReservationCompany
FOREIGN KEY (ReservationID)
REFERENCES CompanyReservations (ReservationID);

-- Table: IndividualReservations
CREATE TABLE IndividualReservations
(
    ReservationID int NOT NULL,
    OrderID int NOT NULL,
    Prepaid bit NOT NULL,
    CONSTRAINT IndividualReservations_pk PRIMARY KEY  (ReservationID)
);

ALTER TABLE IndividualReservations ADD CONSTRAINT IndividualReservations_Orders
FOREIGN KEY (OrderID)
REFERENCES Orders (OrderID);


ALTER TABLE IndividualReservations ADD CONSTRAINT Reservations_IndividualReservations
FOREIGN KEY (ReservationID)
REFERENCES Reservations (ReservationID);

-- Table: Individuals
CREATE TABLE Individuals
(
    IndividualID int NOT NULL,
    ClientID int NOT NULL,
    FirstName nvarchar NOT NULL,
    LastName nvarchar NOT NULL,
    CONSTRAINT Individuals_pk PRIMARY KEY  (IndividualID)
);

ALTER TABLE Individuals ADD CONSTRAINT Client_Individuals
FOREIGN KEY (ClientID)
REFERENCES Client (ClientID);

-- Table: Reservations
CREATE TABLE Reservations
(
    ReservationID int NOT NULL,
    ClientID int NOT NULL,
    ReservationDate datetime NOT NULL DEFAULT GETDATE(),
    StartDate datetime NOT NULL,
    EndDate datetime NOT NULL,
    Accepted bit NOT NULL DEFAULT 0,
    NumberOfGuests int NOT NULL,
    CONSTRAINT ValidNumberOfGuests CHECK (NumberOfGuests >= 2),
    CONSTRAINT ValidDate CHECK (ReservationDate < StartDate AND StartDate < EndDate),
    CONSTRAINT Reservations_pk PRIMARY KEY  (ReservationID)
);

ALTER TABLE Reservations ADD CONSTRAINT Reservations_Client
FOREIGN KEY (ClientID)
REFERENCES Client (ClientID);

-- Table: Discounts
CREATE TABLE Discounts
(
    IndividualID int NOT NULL,
    StartDate datetime NOT NULL DEFAULT GETDATE(),
    EndDate datetime NOT NULL,
    Value int NOT NULL,
    CONSTRAINT ValidDate CHECK (EndDate > StartDate),
    CONSTRAINT ValidValue CHECK (Value > 0 AND Value <= 100),
    CONSTRAINT Discounts_pk PRIMARY KEY  (IndividualID)
);
ALTER TABLE Discounts ADD CONSTRAINT Discounts_Individuals
FOREIGN KEY (IndividualID)
REFERENCES Individuals (IndividualID);

-- Table: DiscountParameters
CREATE TABLE DiscountParameters
(
    ParameterID int NOT NULL,
    ParameterName varchar(2) NOT NULL,
    StartDate datetime NOT NULL DEFAULT GETDATE(),
    EndDate datetime NULL DEFAULT NULL,
    Value int NOT NULL,
    CONSTRAINT ValidDate CHECK (EndDate > StartDate),
    CONSTRAINT ValidValue CHECK (Value > 0),
    CONSTRAINT DiscountParameters_pk PRIMARY KEY  (ParameterID)
);

-- Table: Parameters
CREATE TABLE Parameters
(
    ParameterID varchar(2) NOT NULL,
    Value int NOT NULL ,
    CONSTRAINT ValidValue CHECK (Value >= 0),
    CONSTRAINT Parameters_pk PRIMARY KEY  (ParameterID)
);
