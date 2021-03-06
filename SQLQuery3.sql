USE [UD13_fg222cj_Faktura]
GO
/****** Object:  Trigger [dbo].[ut_UpdateArtikel]    Script Date: 04/03/2014 14:10:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ut_UpdateArtikel] ON [dbo].[Artikel]
AFTER UPDATE
AS 
BEGIN
	IF UPDATE (Artnamn)
	BEGIN
		INSERT INTO Logging (tbl, tblID, kol, old, new, datum, usr)
		SELECT 'Artikel', i.ArtikelID, 'Artnamn', d.Artnamn, i.Artnamn, GETDATE(), SYSTEM_USER
		FROM inserted as i INNER JOIN deleted as d
		ON i.ArtikelID = d.ArtikelID;
	END
END
GO