SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS Total_Off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, 
Total_Off,
SUM(Total_Off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (Company, Years , Total_Laid_Off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
),Company_Year_Rank AS
(SELECT * , DENSE_RANK() OVER (PARTITION BY Years ORDER BY Total_Laid_Off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;
