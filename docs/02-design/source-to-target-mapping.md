# Source-to-Target Mapping

**Document Version:** 1.0  
**Created:** 12 November 2025  
**Owner:** Kelompok 19 - Zahra (ETL Developer)  
**Purpose:** Complete field-level mapping dari OLTP sources ke Data Warehouse dimensional model

---

## Table of Contents

1. [Dimension Tables Mapping](#dimension-tables-mapping)
2. [Fact Tables Mapping](#fact-tables-mapping)
3. [Transformation Rules Library](#transformation-rules-library)
4. [Load Sequence & Dependencies](#load-sequence--dependencies)
5. [Data Volume Estimates](#data-volume-estimates)

---

## Dimension Tables Mapping

### 1.1 DIM_WAKTU (Date Dimension - Generated)

**Source Type:** Generated (Not from source system)  
**Load Frequency:** One-time (2019-2030 range)  
**SCD Type:** Type 0 (Never changes)  
**Grain:** Per hari (Daily)

| Target Column | Target Data Type | Generation Logic | Business Rule | Sample Output |
|---------------|------------------|------------------|---------------|---------------|
| tanggal_key | INT | FORMAT(date, 'yyyyMMdd') | PK, Format YYYYMMDD | 20240115 |
| tanggal | DATE | Generated date value | Full date | 2024-01-15 |
| hari | VARCHAR(10) | DATENAME(weekday, tanggal) | Senin-Minggu | Senin |
| bulan | INT | MONTH(tanggal) | 1-12 | 1 |
| tahun | INT | YEAR(tanggal) | YYYY | 2024 |
| quarter | INT | DATEPART(quarter, tanggal) | 1-4 | 1 |
| hari_kerja | BIT | IF weekday IN (Mon-Fri) AND NOT holiday THEN 1 ELSE 0 | Exclude weekends + ITERA holidays | 1 |
| bulan_tahun | VARCHAR(20) | CONCAT(month_name, ' ', year) | Display format | Januari 2024 |
| minggu_tahun | INT | DATEPART(week, tanggal) | Week number in year | 3 |
| hari_dalam_bulan | INT | DAY(tanggal) | Day of month | 15 |

**SQL Generation Script:**
```sql
-- Generate date dimension 2019-2030
DECLARE @StartDate DATE = '2019-01-01';
DECLARE @EndDate DATE = '2030-12-31';
WHILE @StartDate <= @EndDate
BEGIN
INSERT INTO dim_waktu (tanggal_key, tanggal, hari, bulan, tahun, quarter, hari_kerja, bulan_tahun, minggu_tahun, hari_dalam_bulan)
VALUES (
CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
@StartDate,
DATENAME(weekday, @StartDate),
MONTH(@StartDate),
YEAR(@StartDate),
DATEPART(quarter, @StartDate),
CASE WHEN DATEPART(weekday, @StartDate) BETWEEN 2 AND 6 THEN 1 ELSE 0 END,
CONCAT(DATENAME(month, @StartDate), ' ', YEAR(@StartDate)),
DATEPART(week, @StartDate),
DAY(@StartDate)
);
SET @StartDate = DATEADD(day, 1, @StartDate);
END;```
