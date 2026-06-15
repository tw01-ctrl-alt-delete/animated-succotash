--- Модуль 1.
use master;

CREATE DATABASE BD;
GO

USE BD;
GO


CREATE TABLE Users (
   UserName VARCHAR(50) PRIMARY KEY,
   DatabaseName VARCHAR(50),
   EncryptedPassword VARBINARY(MAX)
);
GO


DECLARE @user INT = 1;
DECLARE @user_total INT = 10;
DECLARE @username VARCHAR(10);
DECLARE @dbname VARCHAR(10);
DECLARE @dbpass VARCHAR(8);

WHILE @user <= @user_total
BEGIN
    --- Генерация имени пользователя и имени базы даннных.
    SET @username = 'user' + CAST(@user AS VARCHAR);
    SET @dbname = 'BD' + CAST(@user AS VARCHAR);

    --- Генерация случайного пароля.
    SET @dbpass = LEFT(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''), 12);
    PRINT @dbpass;

    USE[master];
    EXEC('CREATE LOGIN [' +@username+'] WITH PASSWORD = ''' + @dbpass +  ''', CHECK_POLICY = OFF, CHECK_EXPIRATION=OFF;');
    PRINT @username;

    EXEC('CREATE DATABASE [' +@dbname +'];');
    PRINT @dbname;

    EXEC('ALTER LOGIN [' + @username + '] WITH DEFAULT_DATABASE=[' + @dbname + '];');
    EXEC('DENY VIEW ANY DATABASE TO [' +@username +']');
    EXEC('USE [' +@dbname + ']; EXEC dbo.sp_changedbowner @loginame= ''' +@username +''', @map=false;');

    USE BD;
    INSERT INTO Users(UserName,  DatabaseName, EncryptedPassword) VALUES (@username, @dbname, CAST(@dbpass AS VARBINARY(MAX)));
    SET @user= @user +1;

END;

USE BD;
SELECT UserName, DatabaseName, CAST(EncryptedPassword AS VARCHAR(MAX)) AS DbPass FROM Users;
