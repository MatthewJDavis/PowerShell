# Query teamcity api with PowerShell using auth, will return builds
# Set env vars
# [Environment]::SetEnvironmentVariable("user", "user", "User")
# [Environment]::SetEnvironmentVariable("password", "password", "User")

function Get-TCBuilds {
    [CmdletBinding()]
    param (
        # UserName to connect to teamcity
        [Parameter(Mandatory=$true)]
        [string]
        $UserName,
        # Password of user
        [Parameter(Mandatory=$true)]
        [string]
        $Password  
    )
    
    begin {
    }
    
    process {
        $pair = "$($UserName):$($Password)"
        $url = 'http://ipaddress:8111/app/rest/builds'

        $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
        $basicAuthValue = "Basic $encodedCreds"
        $headers = @{
            "Authorization" = $basicAuthValue;
            "Accept" = "application/xml";
            "Content-Type" = "application/xml";
        }

        [xml]$resp = Invoke-RestMethod -Method get -Uri $url -Headers $headers 
        
        # create custom psojbect here
        $i = 0

        while ($i -le $resp.builds.build.Length) {
            Write-output -InputObject $resp.builds.build.buildTypeId[$i]
            Write-Output -InputObject $resp.builds.build.status[$i]
            Write-Output -InputObject $resp.builds.build.id[$i]
            $i ++
        }
                
        Write-Output $resp
    }
    
    end {
    }
}