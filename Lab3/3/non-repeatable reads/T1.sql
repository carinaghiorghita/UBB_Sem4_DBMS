USE RESTAURANT
GO

--part 1
INSERT INTO MenuItem(itemID,name,price,quantity) VALUES (15,'Caesar Salad',20,400)
BEGIN TRAN
WAITFOR DELAY '00:00:04'
UPDATE MenuItem 
SET price = 22
WHERE name = 'Caesar Salad'
COMMIT TRAN