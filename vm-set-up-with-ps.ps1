# Set up a vm with PowerShell and choco for PS development
# Invoke-Webrequest -uri 'https://raw.githubusercontent.com/MatthewJDavis/PowerShell/master/vm-set-up-with-ps.ps1' -UseBasicParsing -OutFile .\set-up.ps1

# Install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Install choco packages
choco install sysinternals -y
choco install vscode -y
choco install googlechrome -y
choco install cmder -y
choco install git -y

# code --install-extension ms-vscode.PowerShell
# code --install-extenson msazurermtools.azurerm-vscode-tools
# code --install-extenson eridem.vscode-nupkg

