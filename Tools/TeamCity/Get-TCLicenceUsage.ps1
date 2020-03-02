<#
Get the usage of TeamCity agent licences throughout the day
Output a custom object with data retrieved from the TeamCity API

Auth code from = https://virtuallysober.com/2018/01/04/introduction-to-powershell-rest-api-authentication/
TeamCity API docs = https://confluence.jetbrains.com/display/TCD10/REST+API

User has to be an admin to get server licence data

Matthew Davis
2018-05-28
#>

$baseUrl = 'http://51.143.152.188:8111/app/rest/'


# Code for authentication
$Credentials = Get-Credential -Credential $null
$RESTAPIUser = $Credentials.UserName
$Credentials.Password | ConvertFrom-SecureString
$RESTAPIPassword = $Credentials.GetNetworkCredential().password

$pair = "$($RestAPIUser):$($RESTAPIPassword)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{
    "Authorization" = $basicAuthValue;
    "Accept" = "application/xml";
    "Content-Type" = "application/xml";
}

# Custom object to hold the data of the licences
$licenceStats = [PSCustomObject]@{
  MaxAgents = $null;
  AgentsLeft = $null;
  AuthAgentCount = $null;
  AuthConnectedAgentCount = $null;
  AuthDisconnectedAgentCount = $null
  Date = Get-Date -Format yyyy-MM-dd;
  Time = Get-Date -Format HH:mm
}

# Connect to server to create a session
try {
  $server = "$baseUrl" + "server"
  Invoke-RestMethod -Method Get -UseBasicParsing -Uri $server -Headers $headers -SessionVariable session | Out-Null
}
catch [System.Net.WebException] {
  Write-Output $_.exception.message
}


# Overall licence data
$licenceDataUrl = $baseUrl + 'server/licensingData'
[xml]$licenceData =   Invoke-RestMethod -Method Get -UseBasicParsing -Uri $licenceDataUrl -WebSession $session
$licenceStats.MaxAgents = $licenceData.licensingData.maxAgents
$licenceStats.AgentsLeft = $licenceData.licensingData.agentsLeft

# Count total authorised agents
$agentUrl = $baseUrl + 'agents?locator=authorized:true'
[xml]$authorisedAgents = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $agentUrl -WebSession $session
$licenceStats.AuthAgentCount = $authorisedAgents.agents.count

# Authorised agents that are connected
$connectedLocator = $agentUrl + ',connected:true'
[xml]$authAgentConnected = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $connectedLocator -WebSession $session
$licenceStats.AuthConnectedAgentCount = $authAgentConnected.agents.count

# Authorised agents that are disconnected
$disconnectedLocator = $agentUrl + ',connected:false'
[xml]$authAgentsDisconnected = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $disconnectedLocator -WebSession $session
$licenceStats.AuthDisconnectedAgentCount = $authAgentsDisconnected.agents.count

Remove-Variable session

Export-Csv -Path C:\TEMP\licence-stats.csv -InputObject $licenceStats -NoTypeInformation -Append -Force

Return $licenceStats