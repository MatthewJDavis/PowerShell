<#
.SYNOPSIS
  Authenticate to TeamCity and return a response and session
.DESCRIPTION
  Authenticate to TeamCity and return the response from the server and web session authentication that can be used with other calls to the TeamCity server
.EXAMPLE
  $uri = ' https://ci.example.com'
  $session = New-TCSession -User 'tcuser' -Uri $uri
  Password for user tcuser: ********
  Invoke-WebRequest -Uri $uri -WebSession $session.session 
.PARAMETER Credential
  Enter the username and password to authenticate to the TeamCity server
.PARAMETER Uri
  Enter the URL or IP address of the TeamCity server (supply the port if on a custom port)
#>
function New-TCSession {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    $Credential,
    [Parameter(Mandatory)]
    [string]
    $Uri
  )
  
  begin {
  }
  
  process {
    # Code for authentication
    $RESTAPIUser = $Credential.UserName
    $Credential.Password | ConvertFrom-SecureString | Out-Null
    $RESTAPIPassword = $Credential.GetNetworkCredential().password

    $pair = "$($RestAPIUser):$($RESTAPIPassword)"

    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    $basicAuthValue = "Basic $encodedCreds"
    $headers = @{
      "Authorization" = $basicAuthValue;
      "Accept"        = "application/xml";
      "Content-Type"  = "application/xml";
    }

    # Trim the trailing / if it's passed with the uri parameter
    $Uri = $Uri.TrimEnd('/')

    # Connect to server to create a session
    try {
      $server = "$Uri" + "/app/rest/server"
      $session = $null
      $response = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $server -Headers $headers -SessionVariable session
      New-Object -TypeName psobject -Property @{
        'response' = $response
        'session'  = $session
      }

    }
    catch [System.Net.WebException] {
      Write-Output $_.exception.message
    }
    Return $session
  }
  
  end {
  }
}




