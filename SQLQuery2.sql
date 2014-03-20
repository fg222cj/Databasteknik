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

/* Uppgift 2a1 */

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

/* Uppgift 2a2 */

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

/* Uppgift 2a3 */

CREATE PROCEDURE usp_DeleteArtikel
@Artikelid int = 0
AS
BEGIN
	DELETE FROM Artikel
	WHERE ArtikelID = @Artikelid;
END
GO

/* Uppgift 2b */

ALTER PROCEDURE usp_SelectArtiklar
@ArtikelID int = 0
AS
IF @ArtikelID = 0
	BEGIN
		SELECT ArtikelID, Artnamn, Antal, Pris, (Antal*Pris) AS Lagervärde
		FROM Artikel;
	END
ELSE
	BEGIN
		SELECT ArtikelID, Artnamn, Antal, Pris, (Antal*Pris) AS Lagervärde
		FROM Artikel
		WHERE ArtikelID = @ArtikelID;
		IF @@ROWCOUNT = 0
			RAISERROR('Den specificerade artikeln existerar inte.', 16, 1)
			RETURN (1)
	END
GO

/* Uppgift 2c */

ALTER PROCEDURE usp_Telefonlista
@KundID int = 0
AS
IF @KundID = 0
	BEGIN
		WITH TelefonLista AS
		(
			SELECT Namn, Ort, Telenr, Teltyp
			FROM Kund AS K LEFT JOIN Telefon AS T
			ON K.KundID = T.KundID
			LEFT JOIN Teltyp AS Tt
			ON T.TeltypID = Tt.TelTypID
		)
		SELECT *
		FROM TelefonLista
		ORDER BY Namn, Teltyp;
	END
ELSE
	BEGIN
		WITH TelefonLista AS
		(
			SELECT Namn, Ort, Telenr, Teltyp
			FROM Kund AS K LEFT JOIN Telefon AS T
			ON K.KundID = T.KundID
			INNER JOIN Teltyp AS Tt
			ON T.TeltypID = Tt.TelTypID
			WHERE K.KundID = @KundID
		)
		SELECT *
		FROM TelefonLista
		ORDER BY Namn, Teltyp;
		IF @@ROWCOUNT = 0
			RAISERROR('Den specificerade kunden existerar inte.', 16, 1)
			RETURN (1)
	END
GO

/* Uppgift 2d */

CREATE PROCEDURE usp_ForsaljningsStatistik
@FromDate date,
@ToDate date
AS
BEGIN
	SELECT A.ArtikelID, A.Artnamn, F.Datum, Fr.Antal, Fr.Pris, (A.Antal * A.Pris) AS Lagervärde
	FROM Faktura AS F INNER JOIN Fakturarad AS Fr
	ON F.FakturaID = Fr.FakturaID
	INNER JOIN Artikel AS A
	ON A.ArtikelID = Fr.ArtikelID
	ORDER BY A.Artnamn;
	IF @@ROWCOUNT = 0
		RAISERROR('Det fanns inga fakturor inom det valda intervallet.', 16, 1)
		RETURN (1)
END
GO

/* Uppgift 3a */

