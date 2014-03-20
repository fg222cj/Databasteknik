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

/* Uppgift 2.a.1 */

CREATE PROCEDURE usp_InsertArtikel
@Artnamn varchar(30),
@Antal smallint,
@Pris decimal(6,2),
@Rabatt decimal(2,2),
@Plats char(10)
AS
BEGIN
	INSERT INTO Artikel (Artnamn, Antal, Pris, Rabatt, Plats)
	VALUES (@Artnamn, @Antal, @Pris, @Rabatt, @Plats);
END
GO


/* Uppgift 2.a.2 */

CREATE PROCEDURE usp_UpdateArtikel
@Artikelid int,
@Artnamn varchar(30),
@Antal smallint,
@Pris decimal(6,2),
@Rabatt decimal(2,2),
@Plats char(10)
AS
BEGIN
	UPDATE Artikel
	SET Artnamn = @Artnamn,
	Antal = @Antal,
	Pris = @Pris,
	Rabatt = @Rabatt,
	Plats = @Plats
	WHERE ArtikelID = @Artikelid;
END
GO

/* Uppgift 2.a.3 */

CREATE PROCEDURE usp_DeleteArtikel
@Artikelid int = 0
AS
BEGIN
	DELETE FROM Artikel
	WHERE ArtikelID = @Artikelid;
END
GO