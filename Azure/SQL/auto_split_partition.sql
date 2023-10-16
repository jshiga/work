ALTER PROCEDURE [dbo].PROC_split_partition @start_date DATE, @end_date DATE
AS
BEGIN

    -- 動的なparitionを生成する生テーブルの作成
    IF OBJECT_ID('#partitions_raw') IS NOT NULL
    BEGIN
        DROP TABLE #partitions_raw;
    END
    DECLARE @sql_crt_parition_raw_table NVARCHAR(max);
    SET @sql_crt_parition_raw_table = 'CREATE TABLE #partitions_raw (ptn_no INT) WITH (DISTRIBUTION = HASH(ptn_no))';
    EXEC sp_executesql @sql_crt_parition_raw_table;

    -- 動的なparitionを生成する生テーブルへのデータ挿入
    DECLARE @sql_ins_parition_raw_table NVARCHAR(max);
    SET @sql_ins_parition_raw_table = 'INSERT INTO #partitions_raw VALUES (@parition_date)';
    
    WHILE @start_date <= @end_date
    BEGIN
        DECLARE @tmp_sql_ins_parition_raw_table NVARCHAR(max);
        SET @tmp_sql_ins_parition_raw_table = REPLACE(@sql_ins_parition_raw_table,'@parition_date',FORMAT(@start_date,'yyyyMMdd'));
        -- PRINT @tmp_sql_ins_parition_raw_table;
        EXEC sp_executesql @tmp_sql_ins_parition_raw_table;
        SET @start_date = DATEADD(MONTH,1, FORMAT(@start_date,'yyyyMMdd'));
    END
    
    -- 動的なparitionを生成する本テーブルの生成
    IF OBJECT_ID('#partitions') IS NOT NULL
    BEGIN
        DROP TABLE #partitions;
    END
    DECLARE @sql_crt_parition_table NVARCHAR(max);
    SET @sql_crt_parition_table = 'CREATE TABLE #partitions WITH (DISTRIBUTION = HASH(ptn_no)) AS ';
    SET @sql_crt_parition_table = @sql_crt_parition_table + 'SELECT ptn_no, ROW_NUMBER() OVER (ORDER BY ptn_no) as seq_no FROM #partitions_raw;'
    EXEC sp_executesql @sql_crt_parition_table;
    
    
    -- factテーブルとpartition table のの統合
    DECLARE @c INT = (SELECT COUNT(*) FROM #partitions)
    ,       @i INT = 1                        --iterator for while loop
    ,       @q NVARCHAR(MAX)                  --query
    ,       @p INT                            --partition_number
    ,       @t NVARCHAR(128)    = 'test_fact' --table_name;

    WHILE @i <= @c
    BEGIN
        SET @p = (SELECT ptn_no FROM partitions WHERE seq_no = @i);
        -- PRINT @p;
        SET @q = (SELECT N'ALTER TABLE '+@t+' SPLIT RANGE ('+CAST(@p AS CHAR(8))+');');
        -- PRINT @q;
        EXECUTE sp_executesql @q;
        SET @i+=1;
    END
    
END
GO