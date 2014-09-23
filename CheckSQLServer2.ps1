#Objective: To check various status of SQL Server 
#Host, instances and databases.
#Author: MAK
#Date Written: June 5, 2008

ForEach($text in (Get-Content C:\CheckSQLServer\serverlist.txt)) 
{
$ComputerInfo = $text.split(",")
echo $ComputerInfo[0]
echo $ComputerInfo[1]
$global:errorvar = 0
. ./CheckSQL_Lib.ps1 
Write-host "Checking SQL Server....."
Write-host "........................"
Write-host " "
Write-host "Arguments accepted : $ComputerInfo[0]"
write-host "........................"
Write-host "Pinging the host machine"
write-host "........................"
pinghost $ComputerInfo[0]
if ($status.statuscode -ne " ")
{
Write-host "Checking windows services on the host related to SQL Server"
write-host "..........................................................."
checkservices $ComputerInfo[0]
Write-host "Checking hardware Information....."
Write-host ".................................."
checkhardware $ComputerInfo[0]
Write-host "Checking OS Information....."
Write-host "............................."
checkOS $ComputerInfo[0]
Write-host "Checking HDD Information....."
Write-host "............................."
checkHD $ComputerInfo[0]
Write-host "Checking Network Adapter Information....."
Write-host "........................................."
checknet $ComputerInfo[0]
Write-host "Checking Configuration information....."
Write-host "........................................."
checkconfiguration $ComputerInfo[1] |format-table
Write-host "Checking Instance property Information.`...."
Write-host "............................."
checkinstance $ComputerInfo[1] |format-table
Write-host "Checking SQL Server databases....."
Write-host "Checking Database status and size....."
Write-host "............................."
checkdatabases $ComputerInfo[1] |format-table
Write-host "Checking Top 10 Queries based on CPU Usage."
Write-host "............................."
checktopqueries $ComputerInfo[1] |select-object query_text, AvgCPUTime |format-table
;}}