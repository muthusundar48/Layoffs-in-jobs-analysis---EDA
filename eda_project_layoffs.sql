SELECT *
FROM layoffs_v2;

SELECT MAX(total_laid_off)
FROM layoffs_v2;

SELECT *
FROM layoffs_v2
WHERE percentage_laid_off=1;

SELECT company, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_v2;

SELECT industry, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY industry
ORDER BY 2 DESC;

SELECT `date`, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS laid_off
FROM layoffs_v2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;


WITH Rolling_Total AS
(
SELECT 
	SUBSTRING(`date`,1,7) AS `MONTH`,
	SUM(total_laid_off) AS laid_off
FROM layoffs_v2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1)
SELECT 
	`MONTH`, 
	laid_off, 
    SUM(laid_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_v2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year(company, years, total_laid_offs) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_v2
GROUP BY company, YEAR(`date`)
),
company_year_ranking AS(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_offs DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_ranking
WHERE Ranking<=5
;







