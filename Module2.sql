--- Модуль 2. Шифрование пароля.
USE BD;
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'DEMO2025!';
CREATE CERTIFICATE MyCert WITH SUBJECT = 'User password';
CREATE SYMMETRIC KEY MyKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE MyCert;
GO

OPEN SYMMETRIC KEY MyKey DECRYPTION BY CERTIFICATE MyCert;

UPDATE Users
SET EncryptedPassword = ENCRYPTBYKEY(KEY_GUID('MyKey'), EncryptedPassword);

CLOSE SYMMETRIC KEY MyKey;
GO

ALTER TABLE Users DROP COLUMN Password;
GO

--- При закрытом ключе, занчения паролей будут скрыты (хэш)
SELECT * FROM Users;

--- При открытом ключе, значения паролей будут открыты.
OPEN SYMMETRIC KEY MyKey DECRYPTION BY CERTIFICATE MyCert;

SELECT UserName, CONVERT(VARCHAR, DECRYPTBYKEY(EncryptedPassword)) AS Password
FROM Users;

CLOSE SYMMETRIC KEY MyKey;
