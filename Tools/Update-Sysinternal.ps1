<#
.Synopsis
   Download the latest sysinternals tools
.DESCRIPTION
   Downloads the latest sysinternals tools from https://live.sysinternals.com/ to a specified directory
   The function downloads all .exe and .chm files available
.EXAMPLE
   Update-Sysinternals -Path C:\sysinternals
   Downloads the sysinternals tools to the directory C:\sysinternals
.EXAMPLE
   Update-Sysinternals -Path C:\Users\Matt\OneDrive\Tools\sysinternals
   Downloads the sysinternals tools to a user's OneDrive
#>
function Update-Sysinternal {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param (
        # Path to the directory for sysinternals tools
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )
    begin {
        if($PSVersionTable.PSEdition -ne 'Desktop') {
            throw "$($PSVersionTable.PSEdition) not supported. Needs to run on Windows PowerShell."
        }
        if (-not (Test-Path -Path $Path)) {
            Throw "The Path $_ does not exist"
        }
        $uri = 'https://live.sysinternals.com/'
        $sysToolsPage = Invoke-WebRequest -Uri $uri
    }
    process {
        $sysTools = $sysToolsPage.Links.innerHTML | Where-Object -FilterScript { $_ -like "*.exe" -or $_ -like "*.chm" }
        foreach ($sysTool in $sysTools) {
            if($PSCmdlet.ShouldProcess($sysTool)) {
                Invoke-WebRequest -Uri "$uri/$sysTool" -OutFile "$path/$sysTool"
                Write-Output "Updating $($sysTool)"
            }
        }
    } #process
    end{
    }
}