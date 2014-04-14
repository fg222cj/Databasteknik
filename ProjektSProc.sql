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
		RAISERROR('Ett fel uppstod n�r personen skulle f�ras in.', 16, 1)
		RETURN (1)
	END CATCH
END
GO
