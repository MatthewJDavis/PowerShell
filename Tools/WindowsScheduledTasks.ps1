<# 
Reminder how to create and register a scheduled task!

Create and register a new scheduled task on windows
Create a reoccuring task at 9:00am
Script location is c:\scripts
Working directory is changed to the same location to load dll and use exe in script
#>

$PowerShellLocation = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$Arguments = '-File "C:\scripts\Get-FTPDownload.ps1  -NoLogo -NonInteractive -NoProfile'
$WorkingDirectory = 'C:\scripts\'
$TaskName = 'test-win-scp-fetch'
$Description = 'test winscp fetch'

$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At '9:00'

$action = New-ScheduledTaskAction -Execute $PowerShellLocation -Argument $Arguments -WorkingDirectory $WorkingDirectory

$task = New-ScheduledTask -Action $action -Trigger $trigger -Description $Description

Register-ScheduledTask -InputObject $task -TaskName $TaskName

#Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
