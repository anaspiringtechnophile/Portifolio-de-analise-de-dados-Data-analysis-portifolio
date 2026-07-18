USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'db_portaria')
BEGIN
    ALTER DATABASE db_portaria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE db_portaria;
END;
GO

-- 2. Criar o banco de dados do zero
CREATE DATABASE db_portaria;
GO

-- 3. Entrar no banco de dados criado
USE db_portaria;
GO