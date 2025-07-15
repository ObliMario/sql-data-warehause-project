/*
=====================================================
Datenbank und Schemata erstellen
=====================================================

Zweck des Skripts:
Dieses Skript erstellt eine neue Datenbank mit dem Namen 'DataWarehouse', nachdem überprüft wurde, ob sie bereits existiert.
Falls die Datenbank existiert, wird sie gelöscht und neu erstellt. Zusätzlich richtet das Skript drei Schemata in der Datenbank ein: 'bronze', 'silver' und 'gold'.

WARNUNG:
Das Ausführen dieses Skripts löscht die gesamte 'DataWarehouse'-Datenbank, falls sie existiert.
Alle Daten in der Datenbank werden dauerhaft gelöscht. Gehen Sie vorsichtig vor
und stellen Sie sicher, dass Sie ordnungsgemäße Backups haben, bevor Sie dieses Skript ausführen.
*/

/*
=====================================================
Create Database and Schemas
=====================================================

Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
within the database: 'bronze', 'silver', and 'gold'.

WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/

USE master;
GO
-- Drop and recreate 'DataWarehouse' database if it exists

IF EXISTS ( SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO
-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
