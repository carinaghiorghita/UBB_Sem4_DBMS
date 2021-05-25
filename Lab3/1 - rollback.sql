USE RESTAURANT
GO

DROP TABLE IF EXISTS LogTable 
CREATE TABLE LogTable(
	Lid INT IDENTITY PRIMARY KEY,
	TypeOperation VARCHAR(50),
	TableOperation VARCHAR(50),
	ExecutionDate DATETIME
);

GO

--use m:n relation Allergens - MenuItem
SELECT * FROM Allergens
SELECT * FROM MenuItem
SELECT * FROM Allergens_MenuItem
GO

CREATE OR ALTER FUNCTION ufValidateName (@name VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return=1
	IF (@name IS NULL OR LEN(@name)<2)
	BEGIN
		SET @return=0
	END
	RETURN @return
END
GO

CREATE OR ALTER FUNCTION ufValidatePrice (@price DECIMAL(6,2))
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return=1
	IF (@price<0)
	BEGIN
		SET @return=0
	END
	RETURN @return
END
GO


CREATE OR ALTER FUNCTION ufValidateQuantity (@quantity DECIMAL(6,2))
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return=1
	IF (@quantity<0)
	BEGIN
		SET @return=0
	END
	RETURN @return
END
GO

CREATE OR ALTER PROCEDURE uspAddMenuItem (@id SMALLINT, @name VARCHAR(30), @price DECIMAL(6,2), @quantity DECIMAL(6,2))
AS
	SET NOCOUNT ON
	IF (dbo.ufValidateName(@name) <> 1)
	BEGIN
		RAISERROR('Name is invalid',14,1)
	END
	IF (dbo.ufValidatePrice(@price) <> 1)
	BEGIN
		RAISERROR('Price is invalid',14,1)
	END
	IF (dbo.ufValidateQuantity(@quantity) <> 1)
	BEGIN
		RAISERROR('Quantity is invalid',14,1)
	END
	IF EXISTS (SELECT * FROM MenuItem WHERE itemID = @id)
	BEGIN
		RAISERROR('Menu item already exists',14,1)
	END
	INSERT INTO MenuItem VALUES (@id,@name,@price,@quantity)
	INSERT INTO LogTable VALUES('add','menu item',GETDATE())
GO

CREATE OR ALTER PROCEDURE uspAddAllergen (@id SMALLINT, @name VARCHAR(30))
AS
	SET NOCOUNT ON
	IF (dbo.ufValidateName(@name) <> 1)
	BEGIN
		RAISERROR('Name is invalid',14,1)
	END
	IF EXISTS (SELECT * FROM Allergens WHERE allergID = @id)
	BEGIN
		RAISERROR('Allergen already exists',14,1)
	END
	INSERT INTO Allergens VALUES (@id, @name)
	INSERT INTO LogTable VALUES('add','allergen',GETDATE())
GO

CREATE OR ALTER PROCEDURE uspAddMenuItemAllergen (@allergid SMALLINT,@itemid SMALLINT)
AS
	SET NOCOUNT ON
	IF NOT EXISTS (SELECT * FROM MenuItem WHERE itemID = @itemid)
	BEGIN
		RAISERROR('Invalid menu item',14,1)
	END
	IF NOT EXISTS (SELECT * FROM Allergens WHERE allergID = @allergid)
	BEGIN
		RAISERROR('Invalid allergen',14,1)
	END
	IF EXISTS (SELECT * FROM Allergens_MenuItem WHERE allergID = @allergid AND itemID = @itemid)
	BEGIN
		RAISERROR('Pair already exists',14,1)
	END
	INSERT INTO Allergens_MenuItem VALUES (@allergid, @itemid)
	INSERT INTO LogTable VALUES('add','allergen_menuitem',GETDATE())
GO

CREATE OR ALTER PROCEDURE uspAddCommitScenario
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC uspAddMenuItem 11,'Spaghetti Bolognese', 25.00, 300.00
		EXEC uspAddAllergen 11, 'glucoze'
		EXEC uspAddMenuItemAllergen 11,11
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddRollbackScenario
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC uspAddMenuItem 10,'Spaghetti Bolognese', 25.00, 300.00
		EXEC uspAddAllergen 10, 'g' --this will fail due to validation, so everything fails
		EXEC uspAddMenuItemAllergen 10,10
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH
GO

EXEC uspAddRollbackScenario
EXEC uspAddCommitScenario

SELECT * FROM LogTable

DELETE FROM Allergens_MenuItem WHERE allergID = 11
DELETE FROM MenuItem WHERE itemID = 11
DELETE FROM Allergens WHERE allergID = 11
