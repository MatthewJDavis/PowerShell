<#
.Synopsis
Get-PhysicalAdapter retrieves the physical network adapter information from one or more computers.
.DESCRIPTION
Get-PhysicalAdapter uses WMI to retrieve the Win32_networkadapter instances from one or more computers. It displays each adapter's MAC address, adapter type,
Device ID, name and speed.
.PARAMETER ComputerName
The computer name or names to query. This is mandatory.
.EXAMPLE
Get-PhysicalAdapter -ComputerName localhost
.EXAMPLE
Get-PhysicalAdapter -ComputerName server-1
#>
function Get-PhysicalAdapter {
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [Alias('hostname')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    Begin {
        Write-Verbose "Connecting to $ComputerName"
    }
    Process {
        if ($ComputerName -eq $env:COMPUTERNAME -or $ComputerName -eq 'localhost') {
            $cimQuery = Get-CimInstance -ClassName  win32_networkadapter 
        } else {
            $cimQuery = Get-CimInstance -ClassName  win32_networkadapter -ComputerName $ComputerName
        }

        $cimQuery |
        Where-Object -FilterScript { $_.PhysicalAdapter } |
        Select-Object MACAddress, AdapterType, DeviceID, Name, Speed
    }
    End {
        Write-Verbose "Finished running command"
    }
}




