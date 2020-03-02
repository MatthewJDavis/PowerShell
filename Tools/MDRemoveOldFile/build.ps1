[cmdletbinding()]
param(
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [ValidateSet('default', 'AnalyseFunction', 'RunFunctionTests', 'RunManifestTests', 'DeployModule')]
    [string[]]
    $Task = 'default'
)

if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Scope CurrentUser }
if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -Scope CurrentUser }
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -Scope CurrentUser }

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -Verbose:$VerbosePreference