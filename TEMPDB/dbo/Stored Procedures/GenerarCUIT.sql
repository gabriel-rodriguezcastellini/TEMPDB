CREATE PROCEDURE GenerarCUIT 
AS
BEGIN
    DECLARE @cuitPrefix INT
    DECLARE @cuitNumber VARCHAR(8)
    DECLARE @cuit VARCHAR(11)
    DECLARE @suma INT
    DECLARE @i INT
    DECLARE @verificador INT

    SET @verificador = 10  -- Inicializar el verificador con 10 para iniciar el bucle

    WHILE @verificador = 10  -- Continuar recalculando hasta obtener un verificador diferente de 10
    BEGIN
        SET @cuitPrefix = (SELECT TOP 1 value FROM (VALUES (20), (24), (27), (30), (34)) AS prefix(value) ORDER BY NEWID())
        SET @cuitNumber = CAST((RAND() * 89999999 + 10000000) AS INT)
        SET @cuit = CAST(@cuitPrefix AS VARCHAR) + @cuitNumber
        SET @suma = 0
        SET @i = 1

        WHILE @i <= LEN(@cuit)
        BEGIN
            SET @suma = @suma + CAST(SUBSTRING(@cuit, LEN(@cuit) - @i + 1, 1) AS INT) * (2 + ((@i - 1) % 6))
            SET @i = @i + 1
        END

        SET @verificador = (11 - (@suma % 11)) % 11
    END

    SELECT @cuit + CAST(@verificador AS VARCHAR) AS 'CUIT'
END;

EXEC GenerarCUIT;