function checkdatabases(
[string] $servername
)
{
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$DataSet2 = New-Object System.Data.DataSet
$DataSet3 = New-Object System.Data.DataSet
$DataSet4 = New-Object System.Data.DataSet
$SqlConnection.ConnectionString = 
  "Server=$servername;Database=master;Integrated Security=True"
$SqlCmd.CommandText = "select name from master.dbo.sysdatabases"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet)|out-null
$dbs =$DataSet.Tables[0]
#$dbs 
foreach ($db in $dbs)
{
#$db.name
$SqlCmd.CommandText = $db.name+"..sp_spaceused "
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet2) |out-null
}
$DataSet2.Tables[0]| format-table -autosize

foreach ($db in $dbs)
{
#$db.name
$SqlCmd.CommandText = "
select '"+$db.name+"' as Dbname,
DATABASEPROPERTY('"+$db.name+"','IsInRecovery') as Inrecovery,
DATABASEPROPERTY('"+$db.name+"','IsInLoad')  as InLoad,
DATABASEPROPERTY('"+$db.name+"','IsEmergencyMode')  as InEmergency,
DATABASEPROPERTY('"+$db.name+"','IsOffline') as Isoffline,
DATABASEPROPERTY('"+$db.name+"','IsReadOnly')  as IsReadonly,
DATABASEPROPERTY('"+$db.name+"','IsSingleUser')  as IsSingleuser,
DATABASEPROPERTY('"+$db.name+"','IsSuspect') as IsSuspect,
DATABASEPROPERTY('"+$db.name+"','IsInStandBy') as IsStandby,
DATABASEPROPERTY('"+$db.name+"','Version') as version,
DATABASEPROPERTY('"+$db.name+"','IsTruncLog') as IsTrunclog
"
#$SqlCmd.CommandText 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet4) |out-null
}
$DataSet4.Tables[0]| format-table -autosize
$SqlCmd.CommandText = "DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet3)|out-null
$DataSet3.Tables[0] | format-table -autosize
$SqlConnection.Close()
}
