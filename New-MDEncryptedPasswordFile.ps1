# Create a key to encrypt a password in a file that can be used for PowerShell tasks
# https://www.altaro.com/msp-dojo/encrypt-password-powershell/

$passwordDirectory = 'C:\password'
$keyFile = Join-Path -Path $passwordDirectory -ChildPath 'aes.key'
$passwordFile = Join-Path $passwordDirectory -ChildPath 'password.txt'

$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file  $keyFile

(get-credential).Password | ConvertFrom-SecureString -key (get-content $keyFile) | set-content $passwordFile

# To use

$password = Get-Content $passwordFile | ConvertTo-SecureString -Key (Get-Content $keyFile)
$credential = New-Object System.Management.Automation.PsCredential("userName",$password)
