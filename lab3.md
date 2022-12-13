# Lab 3

## INNER JOIN

1. Napisz polecenie zwracające nazwy produktów i firmy je
dostarczające (baza northwind)
```SQL
SELECT ProductName, CompanyName
FROM Products
INNER JOIN suppliers ON Suppliers.SupplierID = Products.SupplierID
```
2. Napisz polecenie zwracające jako wynik nazwy klientów, którzy
złożyli zamówienia po 01 marca 1998 (baza northwind)
```SQL
SELECT CompanyName, OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE OrderDate > '3/1/98'

## LEFT/RIGHT JOIN
```
3. Napisz polecenie zwracające wszystkich klientów z datami
zamówień
```SQL
SELECT CompanyName, Orders.OrderDate
From Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
```
Important to notice: This will return clients even if the clien didn't order anything

### Exercise:
1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
```SQL
SELECT Products.ProductName, Products.UnitPrice, Suppliers.CompanyName
FROM Products
INNER JOIN Suppliers on Products.SupplierID = Suppliers.SupplierID
WHERE UnitPrice BETWEEN 20 AND 30
```
2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
dostarczanych przez firmę ‘Tokyo Traders’
```SQL
SELECT ProductName, UnitsInStock
FROM Products
INNER JOIN Suppliers on Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.CompanyName LIKE 'Tokyo Traders'
```
3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
to pokaż ich dane adresowe?
```SQL
SELECT CompanyName, Address, City, Country
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE OrderID IS NULL
```
4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
których aktualnie nie ma w magazynie
```SQL
SELECT CompanyName, Phone
FROM Suppliers
INNER JOIN Products ON Products.SupplierID = Suppliers.SupplierID
WHERE UnitsInStock = 0
```
5. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
library). Interesuje nas imię, nazwisko i data urodzenia dziecka
```SQL
SELECT member.firstname, member.lastname, juvenile.birth_date
FROM Juvenile
INNER JOIN Member ON juvenile.member_no = member.member_no
```

6. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
```SQL
SELECT DISTINCT title
FROM loan INNER JOIN title ON loan.title_no = title.title_no
```

7. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao
Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
zapłacono karę
```SQL
SELECT in_date, DATEDIFF(DAY, due_date, in_date) as days_delay, fine_assessed, fine_paid, fine_waived
FROM loanhist INNER JOIN title ON loanhist.title_no = title.title_no
WHERE title LIKE 'Tao Teh King' AND due_date < in_date
```

8. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
przez osobę o nazwisku: Stephen A. Graff
``` SQL
SELECT loan.isbn
FROM loan
INNER JOIN member ON member.member_no = loan.member_no
WHERE member.firstname LIKE 'Stephen' AND member.middleinitial = 'A' AND member.lastname LIKE 'Graff'
```

## CROSS JOIN
Napisz polecenie, wyświetlające CROSS JOIN między shippers i
suppliers. użyteczne dla listowania wszystkich możliwych
sposobów w jaki dostawcy mogą dostarczać swoje produkty
```SQL
SELECT suppliers.companyname, shippers.companyname
FROM suppliers
CROSS JOIN shippers
```
## JOINING MULTIPLE TABLES
Napisz polecenie zwracające listę produktów zamawianych w dniu
1996-07-08
```SQL
SELECT OrderDate, ProductName
FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON O.orderid = OD.orderid
INNER JOIN Products AS P
ON OD.productid = P.productid
WHERE orderdate = ‘7/8/96
```
### Exercise: (page 20)
1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy,
interesują nas tylko produkty z kategorii ‘Meat/Poultry’
```SQL
SELECT ProductName, UnitPrice, S.Address
FROM Products
INNER JOIN Suppliers S on Products.SupplierID = S.SupplierID
INNER JOIN Categories C on Products.CategoryID = C.CategoryID
WHERE C.CategoryName LIKE '%Meat/Poultry%' AND UnitPrice BETWEEN 20 AND 30
```

2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu
podaj nazwę dostawcy.
```SQL
SELECT ProductName, UnitPrice, S.CompanyName
FROM Products
INNER JOIN Categories C on Products.CategoryID = C.CategoryID
INNER JOIN Suppliers S on Products.SupplierID = S.SupplierID
WHERE C.CategoryName LIKE 'Confections'
```

3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
dostarczała firma ‘United Package’
```SQL
SELECT S.CompanyName, S.Phone
FROM Customers
INNER JOIN Orders O on Customers.CustomerID = O.CustomerID
INNER JOIN Shippers S on O.ShipVia = S.ShipperID
WHERE S.CompanyName LIKE 'United Package'
```

4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
‘Confections’
```SQL
SELECT DISTINCT CompanyName, Phone
FROM Customers
INNER JOIN Orders O ON Customers.CustomerID = O.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P on OD.ProductID = P.ProductID
INNER JOIN Categories C on P.CategoryID = C.CategoryID
WHERE C.CategoryName LIKE 'Confections'
```

page 21

5. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres
zamieszkania dziecka.
```SQL
SELECT m.firstname, m.lastname, j.birth_date, a.street, a.city, a.state, a.zip
FROM member AS m
INNER JOIN juvenile AS j ON j.member_no = m.member_no
INNER JOIN adult AS a ON a.member_no = j.adult_member_no
```

6. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres
zamieszkania dziecka oraz imię i nazwisko rodzica.
```SQL
SELECT m.firstname, m.lastname, j.birth_date, a.street, a.city, a.state, am.firstname + ' ' + am.lastname AS parent_name
FROM member AS m
INNER JOIN juvenile j on m.member_no = j.member_no
INNER JOIN adult a on j.adult_member_no = a.member_no
INNER JOIN member am on a.member_no = am.member_no
```

## SELF JOIN
Napisz polecenie, które pokazuje pary pracowników zajmujących
to samo stanowisko
```SQL
SELECT a.employeeid, a.lastname AS name, a.title AS title, b.employeeid, b.lastname AS name, b.title AS title
FROM employees AS a
INNER JOIN employees AS b
ON a.title = b.title
WHERE a.employeeid < b.employeeid
```
1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza
northwind)
```SQL
SELECT Sup.Firstname + ' ' + Sup.LastName AS Supervisor, Sub.FirstName + ' ' + Sub.LastName AS Subordinate
FROM Employees AS Sup
LEFT JOIN Employees Sub ON Sup.EmployeeID = Sub.ReportsTo
```

2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych
(baza northwind)
```SQl
SELECT Sup.Firstname + ' ' + Sup.LastName AS Supervisor, Sub.FirstName + ' ' + Sub.LastName AS Subordinate
FROM Employees AS Sup
LEFT JOIN Employees Sub ON Sup.EmployeeID = Sub.ReportsTo
WHERE Sub.EmployeeID IS NULL
```

3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
urodzone przed 1 stycznia 1996
```SQL
SELECT DISTINCT m.firstname + ' ' + m.lastname,  a.state, a.city, a.street, j.birth_date
FROM juvenile as j
INNER JOIN adult a on j.adult_member_no = a.member_no
INNER JOIN member m on a.member_no = m.member_no
WHERE YEAR(j.birth_date) < 1996
```

4. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków
biblioteki, którzy aktualnie nie przetrzymują książek.
```SQL
SELECT DISTINCT m.firstname + ' ' + m.lastname, a.street, a.city, a.state
FROM juvenile as j
INNER JOIN adult a on j.adult_member_no = a.member_no
INNER JOIN member m on a.member_no = m.member_no
INNER JOIN loan l ON m.member_no = l.member_no
WHERE YEAR(j.birth_date) < 1996 AND l.out_date + 14 <= l.due_date
```
## UNION

1. Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę –
name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą
kolumnę – address) dla wszystkich dorosłych członków biblioteki
```SQL
SELECT m.firstname + ' ' + m.lastname as full_name,
       a.street + ', ' + trim(a.zip) + ' ' + a.city + ' ' + a.state as full_address
FROM member AS m
INNER JOIN adult AS a on m.member_no = a.member_no
```

2. Napisz polecenie, które zwraca: isbn, copy_no, on_loan, title, translation, cover,
dla książek o isbn 1, 500 i 1000. Wynik posortuj wg ISBN
```SQL
SELECT i.isbn, c.copy_no, c.on_loan, t.title, i.translation, i.cover
FROM item as i
INNER JOIN title AS t ON t.title_no = i.title_no
INNER JOIN copy AS c ON i.isbn = c.isbn
WHERE i.isbn in (1, 500, 1000)
```

3. Napisz polecenie które zwraca o użytkownikach biblioteki o nr 250, 342, i 1675
(dla każdego użytkownika: nr, imię i nazwisko członka biblioteki), oraz informację
o zarezerwowanych książkach (isbn, data)
```SQL
SELECT m.member_no, isnull(a.member_no, j.adult_member_no) AS adult_member_no, m.firstname, m.lastname, r.isbn, r.log_date
FROM member AS m
LEFT JOIN adult AS a ON m.member_no = a.member_no
LEFT JOIN juvenile AS j ON m.member_no = j.member_no
LEFT JOIN reservation AS r ON adult_member_no = r.member_no
WHERE m.member_no IN (250, 342, 1675)
```

4. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż
dwoje dzieci zapisanych do biblioteki
```SQl
SELECT a.member_no
FROM member AS m
INNER JOIN adult AS a ON m.member_no = a.member_no AND a.state = 'AZ'
INNER JOIN juvenile AS j ON j.adult_member_no = a.member_no
GROUP BY a.member_no
HAVING count(j.member_no) > 2
```

5.Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej
niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni
(CA) i mają więcej niż troje dzieci zapisanych do biblioteki
```SQL
SELECT a.member_no
FROM member as m
INNER JOIN adult AS a ON m.member_no = a.member_no AND a.state = 'AZ'
INNER JOIN juvenile AS j ON j.adult_member_no = a.member_no
GROUP BY a.member_no
HAVING count(j.member_no) > 2
UNION
SELECT a.member_no
FROM member AS m
INNER JOIN adult AS a ON m.member_no = a.member_no AND a.state = 'CA'
INNER JOIN juvenile AS j ON j.adult_member_no = a.member_no
GROUP BY a.member_no
HAVING COUNT(j.member_no) > 3
```

# JOIN Homework
## Homework 1
1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
nazwę klienta.
```SQL
SELECT C.CompanyName, SUM(OD.Quantity)
FROM Orders AS O
INNER JOIN [Order Details] OD On O.OrderID = OD.OrderID
INNER JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName;
```
2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
łączna liczbę zamówionych jednostek jest większa niż 250
```SQL
SELECT C.CompanyName, SUM(OD.Quantity)
FROM Orders AS O
INNER JOIN [Order Details] OD On O.OrderID = OD.OrderID
INNER JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
HAVING SUM(OD.Quantity) > 250
```

3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
klienta.
```SQL
SELECT O.OrderID, C.CompanyName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS FinalPrice
FROM Orders AS O
INNER JOIN [Order Details] OD on O.OrderID = OD.OrderID
INNER JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
```

4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
łączna liczba jednostek jest większa niż 250
```SQL
SELECT O.OrderID, C.CompanyName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS FinalPrice
FROM Orders AS O
INNER JOIN [Order Details] OD on O.OrderID = OD.OrderID
INNER JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
HAVING SUM(OD.Quantity) > 250
```

5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko
pracownika obsługującego zamówienie.
```SQL
SELECT O.OrderID, C.CompanyName, E.FirstName + ' ' + E.LastName AS FullName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS FinalPrice
FROM Orders AS O
INNER JOIN [Order Details] OD on O.OrderID = OD.OrderID
INNER JOIN Customers C on O.CustomerID = C.CustomerID
INNER JOIN Employees E on O.EmployeeID = E.EmployeeID
GROUP BY O.OrderID, C.CompanyName, E.FirstName + ' ' + E.LastName
HAVING SUM(OD.Quantity) > 250
```

## Homework 2
1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
klientów jednostek towarów z tek kategorii
```SQL
SELECT C.CategoryName, SUM(OD.Quantity)
FROM Categories AS C
INNER JOIN Products P on C.CategoryID = P.CategoryID
INNER JOIN [Order Details] OD on P.ProductID = OD.ProductID
GROUP BY C.CategoryName
```

2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
klientów jednostek towarów z tek kategorii.
```SQL
SELECT C.CategoryName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS FullPrice
FROM Categories AS C
INNER JOIN Products P on C.CategoryID = P.CategoryID
INNER JOIN [Order Details] OD on P.ProductID = OD.ProductID
GROUP BY C.CategoryName
```

3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:  
    a. łącznej wartości zamówień   
    ```SQL
    SELECT C.CategoryName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS FullPrice
    FROM Categories AS C
    INNER JOIN Products P on C.CategoryID = P.CategoryID
    INNER JOIN [Order Details] OD on P.ProductID = OD.ProductID
    GROUP BY C.CategoryName
    ORDER BY FullPrice
    ``` 
    b. łącznej liczby zamówionych przez klientów jednostek towarów.
    ```SQL
    SELECT C.CategoryName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS FullPrice
    FROM Categories AS C
    INNER JOIN Products P on C.CategoryID = P.CategoryID
    INNER JOIN [Order Details] OD on P.ProductID = OD.ProductID
    GROUP BY C.CategoryName
    ORDER BY SUM(OD.Quantity)
    ```
4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
```SQL
SELECT O.OrderID, ROUND(SUM(OD.Unitprice * OD.Quantity * (1 - OD.Discount)), 2) + O.freight
FROM Orders AS O
INNER JOIN [order details] as od on od.orderid = O.orderid
GROUP BY O.orderid, O.freight
ORDER BY 2 DESC
```

## Homework 3

1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
```SQL
SELECT CompanyName, COUNT(OrderID)
FROM Shippers
INNER JOIN Orders ON Orders.ShipVia = Shippers.ShipperID
WHERE YEAR(Orders.ShippedDate) = 1997
GROUP BY CompanyName
```
2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
zamówień) w 1997r, podaj nazwę tego przewoźnika.
```SQL
SELECT TOP 1 CompanyName, COUNT(OrderID)
FROM Shippers
INNER JOIN Orders ON Orders.ShipVia = Shippers.ShipperID
WHERE YEAR(Orders.ShippedDate) = 1997
GROUP BY CompanyName
ORDER BY 1 DESC
```

3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
obsłużonych przez tego pracownika
```SQL
SELECT FirstName + '' + LastName AS FullName, SUM(OD.UnitPrice * Quantity * (1 - Discount)) AS FullQuantity
FROM Employees
INNER JOIN Orders ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = Orders.OrderID
GROUP BY FirstName + '' + LastName
```
4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
nazwisko takiego pracownika.
```SQL
SELECT TOP 1 FirstName + ' ' + LastName AS name, COUNT(OrderID)
FROM Employees
INNER JOIN Orders
ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY FirstName + ' ' + LastName
ORDER BY COUNT(OrderID) DESC
```
5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika.
```SQL
SELECT TOP 1 FirstName + '' + LastName, SUM(OD.UnitPrice*Quantity*(1-Discount))
FROM Employees
INNER JOIN Orders ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN [Order Details] AS OD on OD.OrderID = Orders.OrderID
WHERE YEAR(Orders.ShippedDate) = 1997
GROUP BY FirstName + '' + LastName
ORDER BY 2 DESC
```
6. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
obsłużonych przez tego pracownika. Ogranicz wynik tylko do pracowników  
    a. którzy mają podwładnych
    ```SQL
    SELECT DISTINCT
    A.FirstName + ' ' + A.LastName,
    SUM(OD.UnitPrice * Quantity * (1 - Discount))
    FROM Employees AS A
    INNER JOIN Orders ON Orders.EmployeeID = A.EmployeeID
    INNER JOIN [Order Details] AS OD ON OD.OrderID = Orders.OrderID
    INNER JOIN Employees AS B ON A.EmployeeID = B.ReportsTo
    GROUP BY A.FirstName + ' ' + A.LastName, A.EmployeeID, B.EmployeeID

    ```
    Uwaga na `GROUP BY` PO `A.EmployeeID` oraz `B.EmployeeID` - bez tego wartość mnoży się razy ilość podwłasnych
    
    b. którzy nie mają podwładnych  
    ```SQL
    SELECT
        A.FirstName + ' ' + A.LastName,
        SUM(OD.UnitPrice * Quantity * (1 - Discount))
    FROM Employees AS A
    LEFT JOIN Employees AS B ON A.EmployeeID = B.ReportsTo
    INNER JOIN Orders ON Orders.EmployeeID = A.EmployeeID
    INNER JOIN [Order Details] AS OD ON OD.OrderID = Orders.OrderID
    WHERE B.ReportsTo IS NULL
    GROUP BY A.FirstName + ' ' + A.LastName
    ```