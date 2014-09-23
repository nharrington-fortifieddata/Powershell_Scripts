function checkinstance(
[string] $servername
)
{
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$SqlConnection.ConnectionString = "Server=$servername;Database=master;Integrated Security=True"
$SqlCmd.CommandText = "create table #serverproperty (property varchar(100),value varchar(100))
insert into #serverproperty values ('MachineName',convert(varchar(100), SERVERPROPERTY ('Machinename')))
insert into #serverproperty values ('Servername',convert(varchar(100),  SERVERPROPERTY ('ServerName') ))
insert into #serverproperty values ('InstanceName',convert(varchar(100), SERVERPROPERTY ('ServerName') ))
insert into #serverproperty values ('Edition',convert(varchar(100),SERVERPROPERTY ('Edition')  ))
insert into #serverproperty values ('EngineEdition',convert(varchar(100),  SERVERPROPERTY ('EngineEdition'))  )
insert into #serverproperty values ('BuildClrVersion',convert(varchar(100), SERVERPROPERTY ('Buildclrversion'))  )
insert into #serverproperty values ('Collation', convert(varchar(100),SERVERPROPERTY ('Collation'))  )
insert into #serverproperty values ('ProductLevel',convert(varchar(100),  SERVERPROPERTY ('ProductLevel')) )
insert into #serverproperty values ('IsClustered',convert(varchar(100),SERVERPROPERTY ('IsClustered') ))
insert into #serverproperty values ('IsFullTextInstalled',convert(varchar(100),SERVERPROPERTY ('IsFullTextInstalled ') ))
insert into #serverproperty values ('IsSingleuser',convert(varchar(100),  SERVERPROPERTY ('IsSingleUser ') ))
set nocount on
select * from #serverproperty
drop table #serverproperty"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0]
$SqlConnection.Close()
}
