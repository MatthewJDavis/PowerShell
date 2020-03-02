<#
.SYNOPSIS
    Tests when an SSL certificate will expire
.DESCRIPTION
    Uses Get-MDSSLCertificateExpiry cmdlet to get the certificate expiry date.
    It then converts the returned string to a datetime type and compares with the date.
    Set to alert for certs that are expiring in 14 days and under
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

$date = Get-Date

$WebRequest = Get-MDSSLCertificateExpiry -Uri 'https://matthewdavis111.com'
$ExpiryDate = [datetime]::Parse($WebRequest.ExpiryDate)

# Alert if there is less than 14 days until expiry
if ($ExpiryDate.AddDays(-14) -lt $date) {
    #Send alert
    Write-Output "$uri Cert expires on the $ExpiryDate"
}


