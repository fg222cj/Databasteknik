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

ALTER PROCEDURE usp_InsertArtikel
@Artnamn varchar(30),
@Antal smallint,
@Pris decimal(6,2),
@Rabatt decimal(2,2),
@Plats char(10)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Artikel (Artnamn, Antal, Pris, Rabatt, Plats)
		VALUES (@Artnamn, @Antal, @Pris, @Rabatt, @Plats);
	END TRY
	BEGIN CATCH
		RAISERROR('Ett fel uppstod när artikeln skulle föras in.', 16, 1)
		RETURN (1)
	END CATCH
END
GO

/* Uppgift 2a2 */

ALTER PROCEDURE usp_UpdateArtikel
@Artikelid int,
@Artnamn varchar(30),
@Antal smallint,
@Pris decimal(6,2),
@Rabatt decimal(2,2),
@Plats char(10)
AS
BEGIN
	IF EXISTS (SELECT ArtikelID FROM Artikel WHERE ArtikelID = @Artikelid)
	BEGIN
		BEGIN TRY
			UPDATE Artikel
			SET Artnamn = @Artnamn,
			Antal = @Antal,
			Pris = @Pris,
			Rabatt = @Rabatt,
			Plats = @Plats
			WHERE ArtikelID = @Artikelid;
		END TRY
		BEGIN CATCH
			RAISERROR('Ett fel uppstod när artikeln skulle uppdateras.', 16, 1)
			RETURN (1)
		END CATCH
	END
END
GO

/* Uppgift 2a3 */

ALTER PROCEDURE usp_DeleteArtikel
@Artikelid int = 0
AS
BEGIN
	IF EXISTS (SELECT ArtikelID FROM Artikel WHERE ArtikelID = @Artikelid)
	BEGIN
		BEGIN TRY
			DELETE FROM Artikel
			WHERE ArtikelID = @Artikelid;
		END TRY
		BEGIN CATCH
			RAISERROR('Ett fel uppstod när artikeln skulle raderas.', 16, 1)
			RETURN (1)
		END CATCH
	END
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

ALTER PROCEDURE usp_InsertFakturarad
@FakturaID int,
@ArtikelID int,
@Antal int,
@Rabatt decimal(2,2),
@MomsID int
AS
BEGIN
	IF EXISTS (SELECT ArtikelID FROM Artikel WHERE ArtikelID = @ArtikelID)
	AND EXISTS (SELECT FakturaID FROM Faktura WHERE FakturaID = @FakturaID)
	BEGIN
		BEGIN TRY
			DECLARE @Pris decimal(6,2), @ErrorMessage varchar(40)
			SET @Pris = (SELECT Pris FROM Artikel WHERE ArtikelID = @ArtikelID);
					
			BEGIN TRAN
				SET @ErrorMessage = 'Fakturaraden kunde inte skapas.'
				INSERT INTO Fakturarad (FakturaID, ArtikelID, Antal, Pris, Rabatt, MomsID)
				VALUES (@FakturaID, @ArtikelID, @Antal, @Pris, @Rabatt, @MomsID);
				
				SET @ErrorMessage = 'Antalet artiklar i lager kunde inte ändras.'
				UPDATE Artikel
				SET Antal = Antal-@Antal
				WHERE ArtikelID = @ArtikelID;
			COMMIT TRAN
		END TRY
		
		BEGIN CATCH
			ROLLBACK TRAN
			RAISERROR(@ErrorMessage, 16, 1)
			RETURN (1)
		END CATCH
	END
END
GO

/* Uppgift 3b */

ALTER PROCEDURE usp_InsertKund
@Namn varchar(40),
@Adress varchar(30),
@Postnr varchar(6),
@Ort varchar(25),
@KategoriID int,
@Rabatt decimal(2,2),
@Anteckningar varchar(255)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO Kund (Namn, Adress, Postnr, Ort, KategoriID, Rabatt, Anteckningar)
			VALUES (@Namn, @Adress, @Postnr, @Ort, @KategoriID, @Rabatt, @Anteckningar);
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		RAISERROR('Kunde inte lägga till kunden.', 16, 1)
	END CATCH
END
GO

ALTER PROCEDURE usp_InsertTelefon
@Telenr varchar(15),
@TeltypID int,
@KundID int
AS
BEGIN
	IF EXISTS (SELECT KundID FROM Kund WHERE KundID = @KundID)
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Telefon (Telenr, TeltypID, KundID)
				VALUES (@Telenr, @TeltypID, @KundID);
			COMMIT TRAN
		END TRY
		
		BEGIN CATCH
			ROLLBACK TRAN
			RAISERROR('Kunde inte lägga till ett telefonnummer.', 16, 1)
		END CATCH
	END
END
GO

ALTER PROCEDURE usp_InsertKundWithTelefon
@Namn varchar(40),
@Adress varchar(30),
@Postnr varchar(6),
@Ort varchar(25),
@KategoriID int,
@Rabatt decimal(2,2),
@Anteckningar varchar(255),
@Telenr varchar(15),
@TeltypID int
AS
BEGIN
	BEGIN TRY
		EXEC usp_InsertKund @Namn, @Adress, @Postnr, @Ort, @KategoriID, @Rabatt, @Anteckningar
		EXEC usp_InsertTelefon @Telenr, @TeltypID, @@IDENTITY
	END TRY
	
	BEGIN CATCH
		RAISERROR('Något gick fel när kund och telefonnummer skulle läggas in.', 16, 1)
		RETURN (1)
	END CATCH
END
GO

/* Uppgift 3c */

ALTER PROCEDURE usp_DeleteFakturarad
@FakturaID int,
@ArtikelID int
AS
BEGIN
	BEGIN TRY
		DECLARE @ErrorMessage varchar(40)
		BEGIN TRAN
			SET @ErrorMessage = 'Kunde inte reglera antal på artikelnivå.'
			UPDATE Artikel
			SET Antal = Antal + (SELECT SUM(Antal) 
								 FROM Fakturarad
								 WHERE FakturaID = @FakturaID
								 AND ArtikelID = @ArtikelID)
			WHERE ArtikelID = @ArtikelID;
			SET @ErrorMessage = 'Kunde inte radera fakturaraden/raderna.'
			DELETE FROM Fakturarad
			WHERE FakturaID = @FakturaID AND ArtikelID = @ArtikelID;
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN (1)
	END CATCH
END
GO


ALTER PROCEDURE usp_DeleteFaktura
@FakturaID int
AS
BEGIN
	BEGIN TRY
		DECLARE @ErrorMessage varchar(40)
		
		DECLARE fakturaradCursor CURSOR
		FOR SELECT ArtikelID
		FROM Fakturarad
		WHERE FakturaID = @FakturaID
		FOR UPDATE;
		
		OPEN fakturaradCursor
		DECLARE @ArtikelID int
		FETCH fakturaradCursor INTO @ArtikelID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC usp_DeleteFakturarad @FakturaID, @ArtikelID -- Raderar samtliga rader med samma artikel samtidigt istället för rad för rad.
			FETCH fakturaradCursor INTO @ArtikelID
		END
		CLOSE fakturaradCursor
		DEALLOCATE fakturaradCursor
		
		SET @ErrorMessage = 'Kunde inte radera fakturan.'
		BEGIN TRAN
			DELETE FROM Faktura
			WHERE FakturaID = @FakturaID;
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN (1)
	END CATCH
END
GO

