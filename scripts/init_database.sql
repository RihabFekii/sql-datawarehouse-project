/*
===================================================
Create Database and Schemas
===================================================
Script Purpose: 
    This script creates a new database names 'DataWarehouse' after checking if it already exists. 
    IF the database exists, it is dropped and recreated. 
    Additionaly, the script sets up three schemas within the database: 'bronze', 'silver' and 'gold'. 

WARNING: 
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in this database will be premanently deleted. Proceed with caution
    and ensure you have a proper backup before running this script. 
*/ 

USE master; 
GO 

-- Drop and create the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
    DROP DATABASE DataWarehouse; 
END; 
GO

-- Create Database 'DataWarehouse'
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