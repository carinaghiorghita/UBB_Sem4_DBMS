USE RESTAURANT
GO

--DELETE FROM MenuItem WHERE name='Benedict Eggs'
--SELECT * FROM MenuItem

--part 1
BEGIN TRAN
WAITFOR DELAY '00:00:04'
INSERT INTO MenuItem(itemID,name,price,quantity) VALUES (17,'Benedict Eggs',15,200)
COMMIT TRAN