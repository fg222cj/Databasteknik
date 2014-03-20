USE UD13_fg222cj_Faktura;

/* Uppgift 3a */

INSERT INTO Kund (Namn, Adress, Postnr, Ort, KategoriID, Rabatt)
VALUES ('Danielssons Elektriska AB', 'Storgatan 128', '123 56', 'STOCKHOLM', 1, 0.03);

INSERT INTO Telefon (KundID, Telenr, TeltypID)
VALUES (6, '08-897 02 00', 6)

INSERT INTO Telefon (KundID, Telenr, TeltypID)
VALUES (6, '070-547 02 87', 5)

/* Uppgift 3b */

INSERT INTO Artikel (Artnamn, Antal, Pris)
VALUES ('Bildskärm, platt, 10ms', 47, 2173.00)

INSERT INTO Artikel (Artnamn, Antal, Pris)
VALUES ('Tangentbord', 36, 280.00)

INSERT INTO Artikel (Artnamn, Antal, Pris)
VALUES ('Nätkabel, TP kat 5', 1020, 2.50)

/* Uppgift 3c */

INSERT INTO Faktura (Datum, Betvillkor, KundID)
VALUES ('2012-04-20', 25, 6)

/* Uppgift 4a */

UPDATE Kund
SET KategoriID = 4
WHERE KundID = 1

/* Uppgift 4b */

UPDATE Telefon
SET Telenr = '0480-492239'
WHERE KundID = 2 AND Telenr = '0480-479888'

/* Uppgift 4c */

UPDATE Artikel
SET Pris = ROUND(Pris*1.08, 2)

/* Uppgift 4d */



/* Uppgift 4e */

UPDATE Artikel
SET Plats = 'HLP 25'
WHERE Artnamn like 'Bildskärm%'

/* Uppgift 4f */

UPDATE Artikel
SET Plats = 'Förråd 10'
WHERE Plats IS NULL

/* Uppgift 4g */

UPDATE Fakturarad
SET Pris = (SELECT Pris FROM Artikel
WHERE ArtikelID = 2)
WHERE ArtikelID = 2

/* Uppgift 5a */

DELETE
FROM Telefon
WHERE KundID = 6 AND TeltypID = 6

/* Uppgift 5b */

DELETE
FROM Fakturarad
WHERE ArtikelID = 4

/* Uppgift 5c */

DELETE
FROM Kategori
WHERE KategoriID = 4

/* Tack vare den referentiella integriteten mellan tabellerna Kund
 * och Kategori så går det inte att ta bort den här posten. No action
 * innebär att ingen post i Kategori kan tas bort om den har en
 * barnpost i Kund.  */

/* Uppgift 6a */

SELECT *
FROM Kund

/* Uppgift 6b */

SELECT Namn, Postnr, Ort
FROM Kund

/* Uppgift 6c */

SELECT Namn, Postnr, Ort
FROM Kund
ORDER BY Postnr DESC

/* Uppgift 6d */

SELECT Namn, Adress + ' ' + Postnr + ' ' + Ort AS Postadress
FROM Kund
ORDER BY Ort ASC

/* Uppgift 6e */

SELECT ArtikelID, Artnamn, Antal, Pris, FLOOR(Pris*Antal) AS Artikelvärde
FROM Artikel

/* Uppgift 6f */

SELECT ArtikelID, Artnamn, Plats, Antal, '______' AS 'Nytt antal'
FROM Artikel

/* Uppgift 6g */

SELECT ArtikelID, Artnamn, Antal, Pris, FLOOR(Pris*Antal) AS Artikelvärde
FROM Artikel
WHERE Antal > 22 AND Plats = 'Förråd 10'

/* Uppgift 6h */

SELECT TOP 5 ArtikelID, Artnamn, Antal, Pris, FLOOR(Pris*Antal) AS Artikelvärde
FROM Artikel
ORDER BY Artikelvärde DESC

/* Uppgift 7a */

SELECT K.KundID, Namn, Ort, Telenr
FROM Kund AS K INNER JOIN Telefon AS T
ON K.KundID = T.KundID
ORDER BY Namn

/* Uppgift 7b */

SELECT Datum, Betvillkor, A.Artnamn, Fr.Antal, Fr.Pris, Moms*100 AS Moms, Fr.Rabatt, ROUND((Fr.Pris*Fr.Antal)*(1-Fr.Rabatt)*(1+Moms), 2) AS Summa
FROM Faktura AS F INNER JOIN Fakturarad AS Fr
ON F.FakturaID = Fr.FakturaID
INNER JOIN Artikel AS A
ON A.ArtikelID = Fr.ArtikelID
INNER JOIN Moms AS M
ON Fr.MomsID = M.MomsID

/* Uppgift 7c */

SELECT Datum, Betvillkor, A.Artnamn, Fr.Antal, Fr.Pris, Moms*100 AS Moms, Fr.Rabatt,
ROUND((Fr.Pris*Fr.Antal)*(1-Fr.Rabatt)*(1+Moms), 2) AS Summa, DATEADD(DAY, Betvillkor, Datum) AS Förfallodatum
FROM Faktura AS F INNER JOIN Fakturarad AS Fr
ON F.FakturaID = Fr.FakturaID
INNER JOIN Artikel AS A
ON A.ArtikelID = Fr.ArtikelID
INNER JOIN Moms AS M
ON Fr.MomsID = M.MomsID

/* Uppgift 7d */

SELECT Namn, Kategori, Datum, Betvillkor
FROM Kund INNER JOIN Kategori
ON Kund.KategoriID = Kategori.KategoriID
LEFT JOIN Faktura
ON Kund.KundID = Faktura.KundID
/* Ändra LEFT till INNER om vi endast vill se kunder som har fakturor. */

/* Uppgift 7e */

SELECT Namn, Kategori, Datum, Betvillkor
FROM Kund INNER JOIN Kategori
ON Kund.KategoriID = Kategori.KategoriID
LEFT JOIN Faktura
ON Kund.KundID = Faktura.KundID
WHERE Datum > '2012-04-01' AND Datum < '2012-04-30'

/* Uppgift 7f */

SELECT Namn, Adress + ' ' + Postnr + ' ' + Ort AS Postadress
FROM Kund
WHERE KundID NOT IN (SELECT DISTINCT KundID FROM Faktura)

/* Uppgift 7g */

SELECT ArtikelID, Artnamn, Pris, Antal
FROM Artikel
WHERE ArtikelID NOT IN (SELECT DISTINCT ArtikelID FROM Fakturarad)

/* Uppgift 8a */

SELECT COUNT(KundID) AS 'Antal kunder'
FROM Kund

/* Uppgift 8b */

SELECT FLOOR(ROUND(SUM(Antal*Pris),0)) AS Artikelvärde
FROM Artikel

/* Uppgift 8c */

SELECT SUM(Antal) AS Antal, FLOOR(ROUND(SUM(Antal*Pris),0)) AS Artikelvärde,
FLOOR(ROUND(MAX(Antal*Pris),0)) AS Maxvärde, FLOOR(ROUND(MIN(Antal*Pris),0)) AS Minvärde,
FLOOR(ROUND(AVG(Antal*Pris),0)) AS Medelvärde
FROM Artikel

/* Uppgift 8d */

SELECT SUM(Antal) AS Antal, FLOOR(ROUND(SUM(Antal*Pris),0)) AS Artikelvärde,
FLOOR(ROUND(MAX(Antal*Pris),0)) AS Maxvärde, FLOOR(ROUND(MIN(Antal*Pris),0)) AS Minvärde,
FLOOR(ROUND(AVG(Antal*Pris),0)) AS Medelvärde
FROM Artikel
WHERE Lagervarde > (SELECT FLOOR(ROUND(AVG(Antal*Pris),0)) FROM Artikel)

/* Uppgift 8e */

SELECT F.FakturaID, F.Datum, ROUND(SUM((Fr.Pris*Fr.Antal)*(1-Fr.Rabatt)),2) AS 'Summa ex. moms',
ROUND(SUM((Fr.Pris*Fr.Antal)*(1-Fr.Rabatt)*(1+M.Moms)), 2) AS 'Summa inkl. moms'
FROM Faktura AS F
INNER JOIN Fakturarad AS Fr
ON F.FakturaID = Fr.FakturaID
INNER JOIN Moms AS M
ON Fr.MomsID = M.MomsID
GROUP BY F.FakturaID, F.Datum

/* Uppgift 9a */

SELECT CONVERT(date, Datum) AS Datumet, Betvillkor, A.Artnamn, Fr.Antal, Fr.Pris, Moms*100 AS Moms, Fr.Rabatt,
ROUND((Fr.Pris*Fr.Antal)*(1-Fr.Rabatt)*(1+Moms), 2) AS Summa, CONVERT(date, DATEADD(DAY, Betvillkor, Datum)) AS Förfallodatum
FROM Faktura AS F INNER JOIN Fakturarad AS Fr
ON F.FakturaID = Fr.FakturaID
INNER JOIN Artikel AS A
ON A.ArtikelID = Fr.ArtikelID
INNER JOIN Moms AS M
ON Fr.MomsID = M.MomsID

/* Uppgift 9b */

SELECT *, CAST(Postnr AS varchar(3)) AS RegionNr
FROM Kund

/* Uppgift 9c */

SELECT UPPER(Artnamn) + '  ' + CAST(Lagervarde AS varchar(15)) AS Artikel
FROM Artikel

/* Uppgift 9d */

SELECT DATEDIFF(DAY, CONVERT(date, GETDATE()), CONVERT(date, '2014-12-31')) AS Nyår,
DATEDIFF(DAY, CONVERT(date, GETDATE()), CONVERT(date, '2014-04-20')) AS Födelsedag,
DATENAME(DW, CONVERT(date, '2014-04-20')) AS Födelseveckodag

