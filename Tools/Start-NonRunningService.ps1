#Start a non-running service. Can be used as a scheduled task.
#Run the following command to create a new eventlog. New-EventLog -LogName TestLog -Source TestApp

$service = Get-Service -Name Bits

if ($service.Status -ne "Running")
{
    $service.Start()
    Write-EventLog -LogName TestLog -Source TestApp -EntryType Information  -EventId 1 -Message "Service was stopped and needed to be started" -Category 1

}
else
{
    Write-EventLog -LogName TestLog -Source TestApp -EntryType Information  -EventId 0 -Message "Service was running. No action required." -Category 1
}