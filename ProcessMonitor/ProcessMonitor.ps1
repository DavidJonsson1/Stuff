#https://medium.com/swlh/what-is-process-monitor-8cca0167faaf
#https://guyrleech.wordpress.com/2018/10/01/dynamically-creating-process-monitor-filters/
#https://www.itninja.com/blog/view/procmon-command-line-switches-including-the-hidden-capture-switch
#https://adamtheautomator.com/procmon/

# Requires the use of Windows Sysinternals handle.exe to check for open files
# http://technet.microsoft.com/en-us/sysinternals/bb896655.aspx
clear-host
$ProcMonTest = Read-Host "Enter app with path - (C:\Windows\system32\notepad.exe)"
$CSVFile = Read-Host "Enter CSV log file and path - (C:\temp\notepad.csv)"
$ProcMon = "\\s3slc08nm02\installs$\Utilities\Process Monitor\Procmon.exe"
$HandleExe = "\\s3slc08nm02\installs$\Utilities\Sysinternals\handle.exe"
$ProcMonBack = "$Env:Temp\ProcMonTest.pml"
$FileLocked = $false
 
# make sure backing file isn't present in case it wasn't deleted on last run
$FileExists = Test-Path $ProcMonBack
if ($FileExists -eq $true){
Remove-Item $ProcMonBack -force
}
 
& $ProcMon /Quiet /AcceptEula /Minimized /backingfile $ProcMonBack
 
do{
Start-Sleep -seconds 5 # procmon.exe /waitforidle doesn't appear to work well when scripted with PowerShell
$ProcMonProcess = Get-Process | where {$_.Path -eq $ProcMon}
}while(
$ProcMonProcess.Id -eq $null
)
& $ProcMonTest
Start-Sleep -seconds 2
 
$ProcMonTestProcess = Get-Process | where {$_.Path -eq $ProcMonTest}
Stop-Process $ProcMonTestProcess.Id
 
& $ProcMon /Terminate
 
# Test for file lock on procmon.exe backing file before exporting
do{
Start-Sleep -seconds 1
$TestFileLock = &amp; $HandleExe $ProcMonBack
foreach ($line in $TestFileLock){
if ($line -match "pid:"){
$FileLocked = $true
}
else{
$FileLocked = $false
}
}
}while(
$FileLocked -eq $true
)
 
# Read the procmon.exe backing file and export as CSV
&amp; $ProcMon /openlog $ProcMonBack /SaveAs $CSVFile
&amp; $ProcMon /Terminate
 
# Clean up procmon.exe backing file
$FileExists = Test-Path $ProcMonBack
if ($FileExists -eq $true){
Remove-Item $ProcMonBack -force
}