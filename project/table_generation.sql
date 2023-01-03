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
    StartDate date NOT NULL DEFAULT GETDATE(),
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
    OrderDetailsID int NOT NULL,
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