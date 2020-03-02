[cmdletbinding()]
param(
    [string[]]$Task = 'default',
    [string]$ComputerName,
    [PSCredential]$Credential
)

if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -Scope CurrentUser }
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -Scope CurrentUser }
if (!(Get-Module -Name PSDeploy -ListAvailable)) { Install-Module -Name PSDeploy -Scope CurrentUser }

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -Verbose:$VerbosePreference -parameters @{'credential' = $Credential; 'ComputerName' = $ComputerName }