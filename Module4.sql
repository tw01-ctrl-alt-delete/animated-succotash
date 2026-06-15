-- 1. Создаём базу данных (если её нет)
CREATE DATABASE CompanyDB;
GO

USE CompanyDB;
GO

-- 2. Таблица "Продукты"
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Unit NVARCHAR(20) NOT NULL,        -- ед. изм.: шт, кг
    Price DECIMAL(10,2) NOT NULL
);

-- 3. Таблица "Материалы"
CREATE TABLE Materials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialName NVARCHAR(100) NOT NULL,
    Unit NVARCHAR(20) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

-- 4. Таблица "Спецификация" (состав продукта)
CREATE TABLE BillOfMaterials (
    BOMID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    MaterialID INT NOT NULL,
    Quantity DECIMAL(10,3) NOT NULL,   -- количество материала на 1 единицу продукта
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);

-- 5. Таблица "Заказчики"
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    INN NVARCHAR(20) NULL,
    Address NVARCHAR(200) NULL,
    Phone NVARCHAR(20) NULL,
    IsSalesman BIT NOT NULL,   -- является продавцом?
    IsBuyer BIT NOT NULL       -- является покупателем?
);

-- 6. Таблица "Заказы"
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber NVARCHAR(20) NOT NULL,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    TotalAmount DECIMAL(10,2) NULL,   -- итоговая сумма (можно заполнять позже)
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 7. Таблица "Строки заказа"
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,  -- цена на момент заказа
    Amount AS (Quantity * UnitPrice) PERSISTED, -- вычисляемая сумма
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 8. Таблица "Производство"
CREATE TABLE Productions (
    ProductionID INT IDENTITY(1,1) PRIMARY KEY,
    ProductionNumber NVARCHAR(20) NOT NULL,
    ProductionDate DATE NOT NULL,
    ProductID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,   -- сколько единиц продукта произведено
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 9. Таблица "Расход материалов в производстве"
CREATE TABLE ProductionMaterials (
    ProdMaterialID INT IDENTITY(1,1) PRIMARY KEY,
    ProductionID INT NOT NULL,
    MaterialID INT NOT NULL,
    QuantityUsed DECIMAL(10,3) NOT NULL,
    FOREIGN KEY (ProductionID) REFERENCES Productions(ProductionID),
    FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);