---- Модуль 3. Резервное копирование и восстановление базы данных.
--- Делаем резервное копирование.
 BACKUP DATABASE BD
 TO DISK = 'C:\Backup\DB_Backup.bak'
 WITH FORMAT, MEDIANAME = 'SQLServersBackups', NAME = 'Full backup'
 
 PRINT N'Резервное копирование завершенно';


 --- Восстановление базы данных.
 RESTORE DATABASE BD
 FROM DISK = 'C:\Backup\DB_Backup.bak'
 WITH REPLACE, RECOVERY;

 PRINT N'Восстановление базы данных завершенно';