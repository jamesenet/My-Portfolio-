SELECT
*
FROM customers

SELECT 
*
FROM geography


--Query to join Customers data and geography data to enrich customer data with geographic location
SELECT
	c.CustomerID,
	c.CustomerName,
	c.Email,
	c.Gender,
	c.Age,
	g.Country,
	g.City
FROM 
	customers as c
LEFT JOIN
--RIGHT JOIN
--INNER JOIN
--FULL OUTER JOIN
	geography as g
ON
	c.GeographyID = g.GeographyID,

	CASE
		WHEN c.Age BETWEEN 15 AND 24 THEN 'Youth'
		WHEN c.Age BETWEEN 25 AND 64 THEN 'Adult'
		ELSE 'Seniors'
	END AS AgeBracket


