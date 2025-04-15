/*
=================================================================
QUALITY CHECK for the crm_cust_info TABLE 
=================================================================
*/
-- Check for Nulls & Duplicates in the Primary Key 
-- Expectation: No results
SELECT COUNT(*),
cst_id
FROM silver.crm_cust_info
GROUP BY (cst_id)
HAVING COUNT(cst_id) >1 or cst_id is NULL;

SELECT count(*) 
FROM silver.crm_cust_info

-- Check for unwanted Spaces
-- Expectation: No results
SELECT
cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); 

-- Data standardization & Consistency
SELECT DISTINCT(cst_gndr)
FROM bronze.crm_cust_info; 

SELECT DISTINCT(cst_marital_status)
FROM bronze.crm_cust_info; 

/*
-----------------------------------------------------------------
To verify that the inserted data in the silver layer are cleansed 
& standardized, We do the same checks again
-----------------------------------------------------------------
*/

/*
=================================================================
QUALITY CHECK for -- crm_cust_info TABLE 
=================================================================
*/

-- Check for Nulls & Duplicates in the Primary Key 
-- Expectation: No results
SELECT COUNT(*),
cst_id
FROM silver.crm_cust_info
GROUP BY (cst_id)
HAVING COUNT(cst_id) >1 or cst_id is NULL;

-- Check for unwanted Spaces
-- Expectation: No results
SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); 

-- Data standardization & Consistency
SELECT DISTINCT(cst_gndr)
FROM silver.crm_cust_info; 

SELECT DISTINCT(cst_marital_status)
FROM silver.crm_cust_info; 

-- Check all the table
SELECT * FROM silver.crm_cust_info; 

/*
=================================================================
QUALITY CHECK for -- crm_prd_info TABLE 
=================================================================
*/

SELECT * FROM bronze.crm_prd_info;

-- Check duplicates or Null values 
-- Expectation: No Results 
SELECT prd_id, 
COUNT(prd_id)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1 OR prd_id is NULL

-- Check for unwanted Spaces
-- Expectation: No results
SELECT
prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm); 

-- Check for NULLS and negative numbers
-- Expectation: No results
SELECT
prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost is NULL; 

-- Data standardization & consistency 
-- To replace low cardinality cols with real values 
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info; 

-- Check for unvalid data order
-- End data = start_date of the next record - 1 
SELECT * 
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


-- =========================================================
-- QUALITY CHECK for -- crm_sales_details TABLE 
-- =========================================================

-- Check for unwanted Spaces in Strings 
-- Expectation: No results
SELECT
sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num); 

-- Check integrity of the columns which will be used to join with other tables 
-- Exceptation: No results

SELECT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key  NOT IN (SELECT prd_key from silver.crm_prd_info);

-- Check for invalid dates  
-- negative numbers or zeros can't be casted to a date.
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 

-- Check for invalid dates  
-- negative numbers or zeros can't be casted to a date (you need first to cast to varchar then DATE).
SELECT sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 

-- Check for invalid dates
-- Exceptation: No results
SELECT *
FROM bronze.crm_sales_details
WHERE  sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check data consistency between sales, quantity and price 
-- >> Business rule: sales = quantity * price 
-- >> sales can not be negative, NULL or zeros 
SELECT
sls_price,
sls_quantity,
sls_sales
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales is NULL OR sls_price is NULL OR sls_quantity is NULL 
OR sls_sales <=0 OR sls_price <=0 OR sls_quantity <=0

-- =========================================================
-- erp_cust_az12
-- =========================================================

-- check standardization 
-- expraction: no results 
SELECT DISTINCT gen
FROM bronze.erp_cust_az12