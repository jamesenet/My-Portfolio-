SELECT
*
FROM dbo.products

SELECT
	ProductID,
	ProductName,
	Price,
	--Category,

	CASE -- Categories the produucts into Price Categories : Low, Medium and High
		WHEN Price < 50 THEN 'Low'
		WHEN Price BETWEEN 50 AND 200 THEN 'Medium'
		ELSE 'High'
	END AS PriceCategory

FROM dbo.products;