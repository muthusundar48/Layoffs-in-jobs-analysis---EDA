```sql
SELECT *
FROM layoffs_v2;
```

---What is the max number of layoff
```sql
SELECT MAX(total_laid_off)
FROM layoffs_v2;
```

---Where 100% layoff happened
```sql
SELECT *
FROM layoffs_v2
WHERE percentage_laid_off=1;
```

---Company wise layoffs in numbers
```sql
SELECT company, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY company
ORDER BY 2 DESC;
```

---Date period from which to which layoffs occured
```sql
SELECT MIN(`date`),MAX(`date`)
FROM layoffs_v2;
```

---Company wise layoffs in numbers
```sql
SELECT industry, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY industry
ORDER BY 2 DESC;
```

---Layoffs grouped based on date
```sql
SELECT `date`, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY `date`
ORDER BY 1 DESC;
```

---Year wise layoffs in numbers
```sql
SELECT YEAR(`date`), SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
```

```sql
SELECT stage, SUM(total_laid_off) as total
FROM layoffs_v2
GROUP BY stage
ORDER BY 2 DESC;
```

------Month wise layoffs in numbers
```sql
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS laid_off
FROM layoffs_v2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;
```

---Creating Cte's to calculate rolling total of layoff
```sql
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
```

---Creating 2 Cte's to rank the top 5 companies which layoof theie employess ordered in year
```sql
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
```







