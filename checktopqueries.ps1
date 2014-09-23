function checktopqueries(
[string] $servername
)
{
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$SqlConnection.ConnectionString = 
    "Server=$servername;Database=master;Integrated Security=True"
$SqlCmd.CommandText = "
If LEFT(convert(varchar(100),
   SERVERPROPERTY('productversion')),1) in ('9','1')
begin 
select Top 10        case when sql_handle IS NULL
       then ' '
       else ( substring(st.text,(qs.statement_start_offset+2)/2,       
   (case when qs.statement_end_offset = -1         
   then len(convert(nvarchar(MAX),st.text))*2      
   else qs.statement_end_offset    
   end - qs.statement_start_offset) /2  ) )
        end as query_text 
,creation_time,       last_execution_time 
,rank() over(order by (total_worker_time+0.0)/
 execution_count desc,
 sql_handle,statement_start_offset ) as row_no
,       (rank() over(order by (total_worker_time+0.0)/
 execution_count desc,
 sql_handle,statement_start_offset ))%2 as l1
,       (total_worker_time+0.0)/1000 as total_worker_time
,       (total_worker_time+0.0)/(execution_count*1000) 
 as [AvgCPUTime]
,       total_logical_reads as [LogicalReads]
,       total_logical_writes as [LogicalWrites]
,       execution_count
,       total_logical_reads+total_logical_writes as [AggIO]
,       (total_logical_reads+total_logical_writes)/
 (execution_count+0.0) as [AvgIO]
,       db_name(st.dbid) as db_name
,       st.objectid as object_id
from sys.dm_exec_query_stats  qs
cross apply sys.dm_exec_sql_text(sql_handle) st
where total_worker_time  > 0 
order by (total_worker_time+0.0)/(execution_count*1000) 
end
else
begin
print 'Server version is not SQL Server 2005 or above. Can''t query TOP queries'
end"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet)|out-null
$dbs =$DataSet.Tables[0]
$dbs 

$SqlConnection.Close()
}
