function Get-MDSSLCertificateExpiry {
    <#
    .SYNOPSIS
        Get the expiry date of an SSL certificate from a website.
    .DESCRIPTION
        Connects to a give uri and returns the expiry date and uri of the website
    .EXAMPLE
    Get-MDSSLCertificateExpiry -Uri 'https://matthewdavis111.com'

    ExpiryDate          Uri
    ----------          ---
    16/10/2019 19:59:59 https://matthewdavis111.com

    Returns the expiry date of the ssl certificate from https://matthewdavis111.com

    .NOTES
        Not working on PowerShell core, ServicePoint.Certificate is empty
    #>
    #Requires -Version 5.1
    [CmdletBinding()]
    param (
        # Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent. Enter a URI. https:// is required
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Uri
    )
    
    begin {
    }
    
    process {
        try {
            $request = [System.Net.HttpWebRequest]::Create($uri)
            $request.GetResponse().Dispose()
            $cert = $request.ServicePoint.Certificate

            $properties = @{
                ExpiryDate = $cert.GetExpirationDateString()
                Uri        = $Uri
            }
            $Output = New-Object -TypeName pscustomobject -Property $properties
            $Output
            
        } catch {
            Write-Error  $_.Exception.Message
        }
    }
    
    end {
    }
}



