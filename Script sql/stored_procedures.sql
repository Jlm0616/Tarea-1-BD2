USE AdventureWorks;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- ============================================
-- 1. INSERTAR un producto
-- ============================================
CREATE OR ALTER PROCEDURE Production.sp_InsertarProducto
    @Name NVARCHAR(50),
    @ProductNumber NVARCHAR(25),
    @MakeFlag BIT = 0,
    @FinishedGoodsFlag BIT = 0,
    @Color NVARCHAR(15) = NULL,
    @SafetyStockLevel SMALLINT,
    @ReorderPoint SMALLINT,
    @StandardCost MONEY,
    @ListPrice MONEY,
    @DaysToManufacture INT,
    @ProductSubcategoryID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Production.Product
        (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color,
         SafetyStockLevel, ReorderPoint, StandardCost, ListPrice,
         DaysToManufacture, ProductSubcategoryID, SellStartDate, rowguid, ModifiedDate)
    VALUES
        (@Name, @ProductNumber, @MakeFlag, @FinishedGoodsFlag, @Color,
         @SafetyStockLevel, @ReorderPoint, @StandardCost, @ListPrice,
         @DaysToManufacture, @ProductSubcategoryID, GETDATE(), NEWID(), GETDATE());

    SELECT SCOPE_IDENTITY() AS NuevoProductID;
END
GO

-- ============================================
-- 2. ACTUALIZAR un producto
-- ============================================
CREATE OR ALTER PROCEDURE Production.sp_ActualizarProducto
    @ProductID INT,
    @Name NVARCHAR(50),
    @Color NVARCHAR(15) = NULL,
    @ListPrice MONEY,
    @StandardCost MONEY
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Production.Product
    SET Name = @Name,
        Color = @Color,
        ListPrice = @ListPrice,
        StandardCost = @StandardCost,
        ModifiedDate = GETDATE()
    WHERE ProductID = @ProductID;

    SELECT @@ROWCOUNT AS FilasAfectadas;
END
GO

-- ============================================
-- 3. ELIMINAR un producto
-- ============================================
CREATE OR ALTER PROCEDURE Production.sp_EliminarProducto
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Production.Product
    WHERE ProductID = @ProductID;

    SELECT @@ROWCOUNT AS FilasAfectadas;
END
GO

-- ============================================
-- 4. CONSULTAR productos (SELECT simple)
-- ============================================
CREATE OR ALTER PROCEDURE Production.sp_ConsultarProductos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProductID, Name, ProductNumber, Color, ListPrice, StandardCost, SafetyStockLevel
    FROM Production.Product
    ORDER BY ProductID;
END
GO

-- ============================================
-- 5. CONSULTAR productos CON subcategoria (JOIN directo)
-- ============================================
CREATE OR ALTER PROCEDURE Production.sp_ConsultarProductosConSubcategoria
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        p.ProductID,
        p.Name AS NombreProducto,
        p.ProductNumber,
        p.ListPrice,
        sc.Name AS Subcategoria
    FROM Production.Product p
    INNER JOIN Production.ProductSubcategory sc
        ON p.ProductSubcategoryID = sc.ProductSubcategoryID
    ORDER BY p.ProductID;
END
GO
