-- Заполняем Продукты (берём из файла "Цены.xlsx")
INSERT INTO Products (ProductName, Unit, Price) VALUES
('Сметана классическая 15% 540г.', 'шт', 89),
('Кефир 2,5% 900г.', 'шт', 80),
('Кефир 3,2% 900г.', 'шт', 82),
('Молоко 2,5% 900г.', 'шт', 70),
('Сметана классическая 20% 540г.', 'шт', 92);

-- Заполняем Материалы (из файлов "Спецификация" и "Цены")
INSERT INTO Materials (MaterialName, Unit, Price) VALUES
('Молоко нормализованное', 'кг', 34),
('Закваска сметанная', 'кг', 45),
('Сливки 33%', 'кг', 120);   -- добавили третий материал для количества

-- Заполняем Спецификацию (из файла "Спецификация" + свой пример)
-- Для продукта "Сметана классическая 15% 540г." (ProductID=1)
INSERT INTO BillOfMaterials (ProductID, MaterialID, Quantity) VALUES
(1, 1, 0.9),   -- молоко
(1, 2, 0.07);  -- закваска
-- Добавим ещё спецификацию для другого продукта (например, Кефир 2,5%)
INSERT INTO BillOfMaterials (ProductID, MaterialID, Quantity) VALUES
(2, 1, 0.95);   -- на 1 шт кефира нужно 0.95 кг молока

-- Заполняем Заказчиков (из файла "Заказчики.json")
INSERT INTO Customers (CustomerName, INN, Address, Phone, IsSalesman, IsBuyer) VALUES
('ООО "Поставка"', '', 'г.Пятигорск', '+79198634592', 1, 1),
('ООО "Кинотеатр Квант"', '26320045123', 'г. Железноводск, ул. Мира, 123', '+79884581555', 1, 0),
('ООО "Ромашка"', '4140784214', 'г. Омск, ул. Строителей, 294', '+79882584546', 0, 1),
('ООО "Ассоль"', '2629011278', 'г. Калуга, ул. Пушкина, 94', '+79184572398', 0, 1);

-- Заполняем Заказы (из файла "Заказ покупателя.xlsx")
INSERT INTO Orders (OrderNumber, OrderDate, CustomerID, TotalAmount) VALUES
('№2', '2026-06-06', (SELECT CustomerID FROM Customers WHERE CustomerName LIKE '%Ассоль%'), 2488),
('№3', '2026-06-10', (SELECT CustomerID FROM Customers WHERE CustomerName = 'ООО "Ромашка"'), 0),  -- сумму потом пересчитаем
('№4', '2026-06-15', (SELECT CustomerID FROM Customers WHERE CustomerName = 'ООО "Поставка"'), 0);

-- Заполняем Строки заказов (из того же файла)
-- Для заказа №2
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 2, 12, 80),   -- Кефир 2,5% 900г.
(1, 3, 9, 82),    -- Кефир 3,2% 900г.
(1, 4, 10, 79);   -- Молоко 2,5% 900г. (цена 79 в файле, но у нас 70 – оставляем как в заказе)
-- Обновим итоговую сумму в заказе №2
UPDATE Orders SET TotalAmount = (SELECT SUM(Amount) FROM OrderDetails WHERE OrderID = 1) WHERE OrderID = 1;

-- Добавим ещё 2 заказа (чтобы было не менее 3)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(2, 1, 5, 89),   -- сметана 15%
(2, 5, 3, 92),   -- сметана 20%
(3, 2, 20, 80);  -- кефир 2,5%
-- Обновим суммы для заказов 2 и 3
UPDATE Orders SET TotalAmount = (SELECT SUM(Amount) FROM OrderDetails WHERE OrderID = 2) WHERE OrderID = 2;
UPDATE Orders SET TotalAmount = (SELECT SUM(Amount) FROM OrderDetails WHERE OrderID = 3) WHERE OrderID = 3;

-- Заполняем Производство (из файла "Производство.xlsx")
INSERT INTO Productions (ProductionNumber, ProductionDate, ProductID, Quantity) VALUES
('№1', '2025-06-09', 1, 1),    -- сметана 15% 1 шт
('№2', '2025-06-12', 2, 50),   -- кефир 2,5% 50 шт
('№3', '2025-06-14', 4, 30);   -- молоко 2,5% 30 шт

-- Заполняем Расход материалов в производстве (по спецификации)
-- Для производства №1 (сметана 15%)
INSERT INTO ProductionMaterials (ProductionID, MaterialID, QuantityUsed) VALUES
(1, 1, 0.9 * 1),   -- молоко (0.9 кг на шт)
(1, 2, 0.07 * 1);  -- закваска

-- Для производства №2 (кефир 2,5%) – по спецификации №2 (кефир: молоко 0.95 кг на шт)
INSERT INTO ProductionMaterials (ProductionID, MaterialID, QuantityUsed) VALUES
(2, 1, 0.95 * 50);  -- молоко

-- Для производства №3 (молоко 2,5% – это не материал, а продукт; расход материалов не задан, добавим пример)
INSERT INTO ProductionMaterials (ProductionID, MaterialID, QuantityUsed) VALUES
(3, 1, 1.0 * 30);   -- на 1 шт молока (продукт) нужно 1 кг сырого молока

-- Проверим, что в каждой таблице не менее 3 записей
SELECT 'Products' AS TableName, COUNT(*) FROM Products
UNION SELECT 'Materials', COUNT(*) FROM Materials
UNION SELECT 'BillOfMaterials', COUNT(*) FROM BillOfMaterials
UNION SELECT 'Customers', COUNT(*) FROM Customers
UNION SELECT 'Orders', COUNT(*) FROM Orders
UNION SELECT 'OrderDetails', COUNT(*) FROM OrderDetails
UNION SELECT 'Productions', COUNT(*) FROM Productions
UNION SELECT 'ProductionMaterials', COUNT(*) FROM ProductionMaterials;