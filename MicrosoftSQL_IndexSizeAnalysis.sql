/*
	Index Size query
	In SQL Server environments on Microsoft platforms, cloud or on-prem,
	this query will profile the tables in a target database to provie the following size statistics:
	-TableName: Name of the table
	-TotalSizeKB: Overall size of the table
	-DataSizeKB: The size of the database table in its base storage (i.e. Heap or Clustered Index)
	-IndexSizeKB: The size of Nonclustered indexes for the table.
	-TotalIndexes: The number of non-clustered indexes

*/
SELECT 
    t.NAME AS TableName,
    SUM(s.used_page_count) * 8 AS TotalSizeKB,
    SUM(CASE 
            WHEN (i.index_id < 2) THEN (s.used_page_count) * 8
            ELSE 0
        END) AS DataSizeKB,
    SUM(CASE 
            WHEN (i.index_id > 1) THEN (s.used_page_count) * 8
            ELSE 0
        END) AS IndexSizeKB,
    COUNT(DISTINCT i.index_id) - 1 AS TotalIndexes  -- Subtracting 1 because index_id = 0 or 1 is the table data itself
FROM 
    sys.dm_db_partition_stats AS s 
INNER JOIN sys.tables AS t ON 
	s.object_id = t.object_id
INNER JOIN sys.indexes AS i ON i.object_id = t.object_id AND s.index_id = i.index_id
--Change the filter below to the desired table name
--WHERE t.NAME LIKE '%Person%'

GROUP BY 
    t.NAME
ORDER BY 
    TotalSizeKB DESC;

