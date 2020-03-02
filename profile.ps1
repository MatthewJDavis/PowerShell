$majorVersion = $Host.Version.Major.ToString()
$minorVersion = $Host.Version.Minor.ToString()
$version = "$majorVersion.$minorVersion"

# Aliases
New-Alias -Name c -Value Clear-Host
New-Alias -Name sub -Value Select-AzureRmSubscription
New-Alias -Name add -Value Add-AzureRmAccount
New-Alias -Name startv -Value Start-AzureRmVM
New-Alias -Name stopv -Value Stop-AzureRmVM

# Custom variables
$hostsFile = 'C:\Windows\System32\drivers\etc\hosts'


# add alias to find accelerators
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
$TAType::Add('accelerators',$TAType) 
# [accelerators]::Get

function Find-Type {
# PowerShell in depth book, P.54    
    param (
        [regex]$Pattern
    )
    [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() |
    Select-String $Pattern
}


Set-Location -Path C:\git
Write-Output "PowerShell version" $version 
Get-Date


# copy VSCode configs to git
Copy-Item C:\Users\Matt\AppData\Roaming\Code\User\*.json -Destination C:\git\configs\vscode\ -Force

$Host.PrivateData.ErrorForegroundColor = 'Cyan'
Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
function Prompt {
    $location = Get-Location
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity

    if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
         $Host.UI.RawUI.WindowTitle = "[ADMIN]: " + $location
    } else {
        $Host.UI.RawUI.WindowTitle = $location
    }

    if ($env:ConEmuANSI -eq "ON") {
    	"PS >"
    } else {
        $env:username + " :: " + (Get-Date -format t) + "> " 
    }
}#prompt

function ip(){
    # Get public IP address
    (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -Method Get).ip
}#ip
