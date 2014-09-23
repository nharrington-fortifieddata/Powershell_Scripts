#Objective: To check various status of SQL Server 
#Host, instances and databases.
#Author: MAK
#Date Written: June 5, 2008
param (
  [string] $Hostname, 
  [string] $instancename
)
$global:errorvar = 0
. ./CheckSQL_Lib.ps1 
Write-host "Checking SQL Server....."
Write-host "........................"
Write-host " "
Write-host "Arguments accepted : $Hostname"
write-host "........................"
Write-host "Pinging the host machine"
write-host "........................"
pinghost $Hostname
if ($status.statuscode -ne " ")
{
Write-host "Checking windows services on the host related to SQL Server"
write-host "..........................................................."
checkservices $Hostname
Write-host "Checking hardware Information....."
Write-host ".................................."
checkhardware $Hostname
Write-host "Checking OS Information....."
Write-host "............................."
checkOS $Hostname
Write-host "Checking HDD Information....."
Write-host "............................."
checkHD $Hostname
Write-host "Checking Network Adapter Information....."
Write-host "........................................."
checknet $Hostname
Write-host "Checking Configuration information....."
Write-host "........................................."
checkconfiguration $instancename |format-table
Write-host "Checking Instance property Information.`...."
Write-host "............................."
checkinstance $instancename |format-table
Write-host "Checking SQL Server databases....."
Write-host "Checking Database status and size....."
Write-host "............................."
checkdatabases $instancename |format-table
Write-host "Checking Top 10 Queries based on CPU Usage."
Write-host "............................."
checktopqueries $instancename |select-object query_text, AvgCPUTime |format-table
;}