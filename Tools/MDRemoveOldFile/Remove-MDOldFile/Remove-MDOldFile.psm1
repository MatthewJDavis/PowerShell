function Remove-MDOldFile {
    <#
    .SYNOPSIS
        Removes files that have a write time older than the passed in amount of days
    .DESCRIPTION
        Removes files with the specified extension that are older than (last write time) the number of days to keep that in input to the function.
    .EXAMPLE
        PS C:\> Remove-MDOldFile -Path C:\test -NumberOfDaysToKeep 10 -FileType txt
        Removes all txt files in the C:\test directory that were written to over 10 days ago
        
        PS C:\> Remove-MDOldFile -Path C:\test -NumberOfDaysToKeep 20 -FileType etl
        Removes all etl files in the C:\test directory that were written over 20 days ago

        PS C:\> Remove-MDOldFile -Path C:\test -NumberOfDaysToKeep 5 -FileType log
        Removes all log files in the C:\test directory that were written over 5 days ago

    .INPUTS
    .OUTPUTS
    .NOTES
    #>
    [CmdletBinding(
        SupportsShouldProcess = $True
    )]
    param (
        # Path of directory
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $Path,
        # Number of days to keep
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]
        $NumberOfDaysToKeep,
        # File Type to remove
        [Parameter(Mandatory)]
        [string]
        [ValidateSet("log", "txt", "etl")]
        $FileType
    )
    
    begin {
    }
    
    process {
        if (Test-Path $Path) {
            Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.LastWriteTime -LT (Get-Date).AddDays(-$NumberOfDaysToKeep) -and $_.Name -like "*.$FileType" } |
            Remove-Item -Force 
        } else {
            Write-Warning "Path not found"
        }
    }
    
    end {
    }
}
