CREATE PROCEDURE GenerarCUIT
    @generatedCUIT NVARCHAR(20) OUTPUT
AS
BEGIN
    DECLARE @cuitPrefix INT
    DECLARE @cuitNumber VARCHAR(8)
    DECLARE @cuit NVARCHAR(11)
    DECLARE @suma INT
    DECLARE @i INT
    DECLARE @verificador INT

    SET @verificador = 10

    WHILE @verificador = 10
    BEGIN
        SET @cuitPrefix = (SELECT TOP 1 value FROM (VALUES (20), (24), (27), (30), (34)) AS prefix(value) ORDER BY NEWID())
        SET @cuitNumber = CAST((RAND() * 89999999 + 10000000) AS INT)
        SET @cuit = CAST(@cuitPrefix AS nvarchar) + @cuitNumber
        SET @suma = 0
        SET @i = 1

        WHILE @i <= LEN(@cuit)
        BEGIN
            SET @suma = @suma + CAST(SUBSTRING(@cuit, LEN(@cuit) - @i + 1, 1) AS INT) * (2 + ((@i - 1) % 6))
            SET @i = @i + 1
        END

        SET @verificador = (11 - (@suma % 11)) % 11
    END

    SET @generatedCUIT = SUBSTRING(@cuit, 1, 2) + '-' + SUBSTRING(@cuit, 3, 8) + '-' + CAST(@verificador AS NVARCHAR) COLLATE Modern_Spanish_CI_AS
END
GO