-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_InsertPerson
@Fnamn varchar(20),
@Enamn varchar(20),
@Adress varchar(30),
@Postnr varchar(6),
@Ort varchar(25),
@Personnr varchar(12)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO Person (Fnamn, Enamn, Adress, Postnr, Ort, Personnr)
			VALUES (@Fnamn, @Enamn, @Adress, @Postnr, @Ort, @Personnr);
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RAISERROR('Ett fel uppstod när personen skulle föras in.', 16, 1)
		RETURN (1)
	END CATCH
END
GO

ALTER PROCEDURE usp_InsertBokning
@PersonID int,
@SalID int,
@Datum smalldatetime,
@Tidsatgang tinyint
AS
BEGIN
	IF EXISTS (SELECT PersonID FROM Person WHERE PersonID = @PersonID)
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Bokning (PersonID, SalID, Datum, Tidsatgang)
				VALUES (@PersonID, @SalID, @Datum, @Tidsatgang);
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			RAISERROR('Ett fel uppstod när bokningen skulle utföras.', 16, 1)
			RETURN (1)
		END CATCH
	END
END
GO

CREATE PROCEDURE usp_InsertSal
@Namn varchar(20)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO Sal (Namn)
			VALUES (@Namn);
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RAISERROR('Ett fel uppstod när bokningen skulle utföras.', 16, 1)
		RETURN (1)
	END CATCH
END
GO