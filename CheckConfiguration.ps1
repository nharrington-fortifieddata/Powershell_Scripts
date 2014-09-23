function checkconfiguration(
[string] $servername
)
{
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$SqlConnection.ConnectionString = "Server=$servername;Database=master;Integrated Security=True"
$SqlCmd.CommandText = "exec master.dbo.sp_configure 'show advanced options',1  reconfigure"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet)
$SqlCmd.CommandText = "
set nocount on
create table #config (name varchar(100), minimum bigint, maximum bigint, config_value bigint, run_value bigint)
insert #config exec ('master.dbo.sp_configure')
set nocount on
select * from #config as mytable
drop table #config
"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet)
$SqlConnection.Close()
$DataSet.Tables[0].rows
}
