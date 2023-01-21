CREATE ROLE Administrator
GRANT ALL TO Administrator

CREATE ROLE Customer
GRANT SELECT ON CurrentlyFreeTables TO Customer
GRANT SELECT ON CurrentMenu TO Customer
GRANT EXECUTE ON CanOrderSeafood TO Customer
GRANT EXECUTE ON GetPreviousMonday TO Customer
GRANT EXECUTE ON HasSeafood TO Customer

CREATE ROLE IndividualCustomer
GRANT Customer TO IndividualCustomer
GRANT SELECT ON IndividualReservationsHistory TO IndividualCustomer
GRANT SELECT ON CurrentDiscounts TO IndividualCustomer
GRANT EXECUTE ON GetCurrentDiscount TO IndividualCustomer
GRANT EXECUTE ON AddIndividualReservation TO IndividualCustomer
GRANT EXECUTE ON AddOrder TO IndividualCustomer
GRANT EXECUTE ON MakeTakeaway TO IndividualCustomer

CREATE ROLE CompanyCustomer
GRANT Customer TO CompanyCustomer
GRANT SELECT ON CompanyReservationsHistory TO CompanyCustomer
GRANT EXECUTE ON AddOrder TO CompanyCustomer
GRANT EXECUTE ON AddNamedCompanyReservation TO Employee
GRANT EXECUTE ON AddAnonymousCompanyReservation TO Employee
GRANT EXECUTE ON MakeTakeaway TO CompanyCustomer

CREATE ROLE Employee
GRANT SELECT ON CompanyOrders TO Employee
GRANT SELECT ON IndividualOrders TO Employee
GRANT SELECT ON IndividualReservationsHistory TO Employee
GRANT SELECT ON CurrentDiscounts TO Employee
GRANT SELECT ON CurrentlyFreeTables TO Employee
GRANT SELECT ON CurrentMenu TO Employee
GRANT SELECT ON ProductDetails TO Employee
GRANT SELECT ON UpcommingTakeawayOrders TO Employee
GRANT SELECT ON UpcommingReservations TO Employee
GRANT SELECT ON CompanyReservationsHistory TO Employee
GRANT SELECT ON SeaFoodOrders TO Employee
GRANT EXECUTE ON CanOrderSeafood TO Employee
GRANT EXECUTE ON GetPreviousMonday TO Employee
GRANT EXECUTE ON HasSeafood TO Employee
GRANT EXECUTE ON AddIndividual TO Employee
GRANT EXECUTE ON AddComapny TO Employee
GRANT EXECUTE ON AddIndividualReservation TO Employee
GRANT EXECUTE ON AddNamedCompanyReservation TO Employee
GRANT EXECUTE ON AddAnonymousCompanyReservation TO Employee
GRANT EXECUTE ON AddOrder TO Employee
GRANT EXECUTE ON MakeTakeaway TO Employee

CREATE ROLE Manager
GRANT Employee TO Manager
GRANT SELECT ON EmployeeStats TO Manager
GRANT SELECT ON GeneralProductStats TO Manager
GRANT SELECT ON MonthlyOrderStats TO Manager
GRANT SELECT ON WeeklyOrderStats TO Manager
GRANT SELECT ON MonthlyProductStats TO Manager
GRANT SELECT ON ProductDetails TO Manager
GRANT SELECT ON ReservationsToCheck TO Manager
GRANT SELECT ON TableReservationDetails TO Manager
GRANT SELECT ON MonthlyCompanyOrders TO Manager
GRANT SELECT ON AverageServiceTime TO Manager
GRANT SELECT ON AverageProductServingTime TO Manager
GRANT EXECUTE ON AddToMenu TO Manager
GRANT EXECUTE ON AcceptReservation TO Manager
GRANT EXECUTE ON AddEmployee TO Manager
GRANT EXECUTE ON MakeManager TO Manager
GRANT EXECUTE ON AddTable To Manager
GRANT EXECUTE ON AddTableToReservation To Manager
GRANT EXECUTE ON ChangeParameter To Manager
