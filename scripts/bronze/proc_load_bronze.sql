/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

-- Bulk insert crm cust_info table 

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    PRINT '=========================================================';
    PRINT 'Loading Bronze Layer';
    PRINT '=========================================================';

    PRINT '---------------------------------------------------------';
    PRINT 'Loading CRM Tables';
    PRINT '---------------------------------------------------------';

    SET @batch_start_time = GETDATE(); 
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

    PRINT '>> Inserting Data Into: bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM 'datasets/source_crm/cust_info.csv'  -- within the container, he location of the file
    WITH(
        DATA_SOURCE = 'dataset',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK -- Minimize the number of log records for the insert operation
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> -------------------'

    -- Bulk insert crm prd_info table 
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;

    PRINT '>> Inserting Data Into: bronze.crm_prd_info';
    BULK INSERT bronze.crm_prd_info
    FROM 'datasets/source_crm/prd_info.csv'  -- within the container, he location of the file
    WITH(
        DATA_SOURCE = 'dataset',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK -- Minimize the number of log records for the insert operation
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> -------------------';

    -- Bulk insert crm sales_details table 
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;

    PRINT '>> Inserting Data Into: bronze.crm_sales_details';   
    BULK INSERT bronze.crm_sales_details
    FROM 'datasets/source_crm/sales_details.csv'  -- within the container, he location of the file
    WITH(
        DATA_SOURCE = 'dataset',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK -- Minimize the number of log records for the insert operation
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> -------------------';

    PRINT '---------------------------------------------------------';
    PRINT 'Loading ERP Tables';
    PRINT '---------------------------------------------------------'; 

    -- Bulk insert erp cust az12 table 
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;

    PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
    BULK INSERT bronze.erp_cust_az12
    FROM 'datasets/source_erp/CUST_AZ12.csv'  -- within the container, he location of the file
    WITH(
        DATA_SOURCE = 'dataset',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK -- Minimize the number of log records for the insert operation
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> -------------------';

    -- Bulk insert erp cust az12 table 
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.erp_loc_a101';   
    TRUNCATE TABLE bronze.erp_loc_a101;

    PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
    BULK INSERT bronze.erp_loc_a101
    FROM 'datasets/source_erp/LOC_A101.csv'  -- within the container, he location of the file
    WITH(
        DATA_SOURCE = 'dataset',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK -- Minimize the number of log records for the insert operation
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> -------------------';

    -- Bulk insert erp cust az12 table 
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'datasets/source_erp/PX_CAT_G1V2.csv'  -- within the container, he location of the file
    WITH(
        DATA_SOURCE = 'dataset',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK -- Minimize the number of log records for the insert operation
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> -------------------'; 

    SET @batch_end_time = GETDATE(); 
    PRINT '=============================================';
    PRINT 'Loading Bronze Layer is Completed!';
    PRINT '     - Total Dureation:' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_date) AS NVARCHAR) + 'seconds'; 
    PRINT '=============================================';

END

EXEC bronze.load_bronze