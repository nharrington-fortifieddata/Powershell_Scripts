#Function to check the HDD information on the host machine

Function checkHD([string] $Hostname)
{
$drives=get-wmiobject -class Win32_LogicalDisk -computername $hostname -errorvariable errorvar
if (-not $errorvar)
{
foreach ($drive in $drives)
{
if ($drive.drivetype -eq "3")
{
$message= "DeviceID="+$drive.Deviceid+" Size="+
	$drive.size/1048576+"MB Free Space="+
	$drive.freespace/1048576 +"MB Percentage Used="+
	(($drive.Size/1048576)-($drive.freespace/1048576))/
	($drive.Size/1048576) *100+"%"
write-host $message -background "GREEN" -foreground "BLACK"
}
}
}
}
