CREATE FUNCTION fnCCExpiration

(
	@ccnum AS VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	
	
	DECLARE @DayEOM VARCHAR(MAX) = (SELECT EOMONTH(DATEFROMPARTS(ExpYear, ExpMonth, 1)) FROM Sales.CreditCard WHERE CardNumber = @ccnum) 
	
			SET @ccnum = @DayEOM 

	RETURN @ccnum
END
GO



CREATE FUNCTION FnTaxRate

(
	@StateID AS VARCHAR(MAX), @TaxType AS VARCHAR(MAX)
)
RETURNS SMALLMONEY
AS
BEGIN
	
	DECLARE @TaxRate VARCHAR(MAX) = (SELECT TaxRate FROM Sales.SalesTaxRate WHERE StateProvinceID = @StateID AND TaxType = @TaxType)

	RETURN @TaxRate 
END
GO




CREATE FUNCTION InchesToCentimeters 
(
		@Input INT
)
RETURNS DECIMAL(10, 5)
AS
BEGIN
DECLARE @Output DECIMAL(10,5) =(@input * 2.54)
RETURN @Output
END
GO



CREATE FUNCTION GallonsToLiter
(
		@Input DECIMAL
)
RETURNS DECIMAL(10, 5)
AS
BEGIN
DECLARE @Output DECIMAL(10, 5) =(@input * 3.78541)
RETURN @Output
END
GO

CREATE FUNCTION PoundsToKilograms
(
		@Input DECIMAL
)
RETURNS DECIMAL(10, 5)
AS
BEGIN
DECLARE @Output DECIMAL(10, 5) =(@input * 0.453592)
RETURN @Output
END
GO

SELECT [dbo].[fnCCExpiration](77772030376004) AS CardExpiration

SELECT [DBO].[FnTaxRate](63,1) AS TaxRate

SELECT [dbo].[GallonsToliter](5) AS [Gallons to Liter]

SELECT [dbo].[InchesToCentimeters] (5) AS [Inches to Centimeters]

SELECT [dbo].[PoundsToKilograms](15) AS [Pounds to Kilograms]




