--- Модуль 6. Создаём архивную таблицу.

-- Создаем архивную таблицу для заказов мая
SELECT * 
INTO Orders_May_Archive
FROM Orders
WHERE MONTH(OrderDate) = 5 
AND YEAR(OrderDate) = 2025;  -- Уточняем год, чтобы избежать ошибок

SELECT * FROM Orders_May_Archive;

-- Удаляем связанные записи из OrderDetail
DELETE FROM OrderDetail
WHERE NumOrder IN (
    SELECT NumOrder 
    FROM Orders_May_Archive
);

-- Удаляем записи из основной таблицы Orders
DELETE FROM Orders
WHERE NumOrder IN (
    SELECT NumOrder 
    FROM Orders_May_Archive
);
