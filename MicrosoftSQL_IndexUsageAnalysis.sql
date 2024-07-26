/*

	Index usage query
	In SQL Server environments on Microsoft platforms, cloud or on-prem,
	this query will profile the tables in a target database to provide the following usage statistics:
	-DatabaseName
	-TableName
	-IndexName
	-User_seeks*: The number of times the index was used in a Seek operation in the database engine.
	-User_Scans*: The number of times the index was used in a Scan operation in the database engine.
	-User_lookups: The number of times the index was used in a Lookup operation in the database engine.
	-User_updates: The number of times the index was updated by operations on the table, such as inserts, updates and deletes.

	*The metrics from this view will be the number of operations as of:
	-The last system restart, if the SQL Server environment is on-prem or IaaS
	-The initiation of the environment if the SQL Server environment is in the Azure cloud. 
	    Depending on your redundancy settings, these statistics may be reset by those operations

*/
SELECT 
    DB_NAME(database_id) AS DatabaseName,
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    user_seeks,
    user_scans,
    user_lookups,
    user_updates
FROM 
    sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON 
		s.object_id = i.object_id 
		AND s.index_id = i.index_id
WHERE 
    database_id = DB_ID() -- Filters by the current database
ORDER BY 
    user_updates DESC, user_seeks + user_scans + user_lookups DESC;
