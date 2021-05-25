USE RESTAURANT
GO

CREATE OR ALTER PROCEDURE uspAddMenuItemRecover (@id SMALLINT, @name VARCHAR(30), @price DECIMAL(6,2), @quantity DECIMAL(6,2))
AS
	SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
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
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddAllergenRecover (@id SMALLINT, @name VARCHAR(30))
AS
	SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
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
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddMenuItemAllergenRecover (@allergid SMALLINT,@itemid SMALLINT)
AS
	SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
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
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspBadAddScenario
AS
	EXEC uspAddMenuItemRecover 10,'Spaghetti Bolognese', 25.00, 300.00
	EXEC uspAddAllergenRecover 10, 'g' --this will fail, but the item added before will still be in the database
	EXEC uspAddMenuItemAllergenRecover 10,10
GO

CREATE OR ALTER PROCEDURE uspGoodAddScenario
AS
	EXEC uspAddMenuItemRecover 12,'Spaghetti Bolognese', 25.00, 300.00
	EXEC uspAddAllergenRecover 12, 'glucoze'
	EXEC uspAddMenuItemAllergenRecover 12,12
GO

EXEC uspBadAddScenario
SELECT * FROM LogTable

EXEC uspGoodAddScenario
SELECT * FROM LogTable

SELECT * FROM Allergens
SELECT * FROM MenuItem
SELECT * FROM Allergens_MenuItem

DELETE FROM Allergens_MenuItem WHERE itemID=10 AND allergID=10
DELETE FROM Allergens_MenuItem WHERE itemID=12 AND allergID=12

DELETE FROM Allergens WHERE allergID=12
DELETE FROM Allergens WHERE allergID=10

DELETE FROM MenuItem WHERE itemID=12
DELETE FROM MenuItem WHERE itemID=10
