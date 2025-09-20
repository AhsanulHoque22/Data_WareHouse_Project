/*
===================================================================================================
Create Database
====================================================================================================
Script Pusrpose:
	This script creaters a new database named 'DataWarehouse' after ckecking if it already exists.
    If the database exists,it is droppped and recreated.
    
Warning: 
		Running this script will drop the entire database named 'DataWarehouse' if it exists.
        All data in the database will bepermanently deleted. Proceed with caution,
        ensure you have proper backups before running this script.
*/
CREATE DATABASE IF NOT EXISTS DataWarehouse;
USE DataWarehouse;
