<# Example on how to query the Microsoft Graph using PowerShell.
  1. We need to get an access token by Posting to the token endpoint with the Azure AD application
  details.
  2. Use the access token from the response to query the Graph rest api. (Access token is valid for 1 hour before it needs refreshing)
  3. The example shows returning the users data of the directory
  4. The permissions needed in the Azure Active Directory App are
#>

# Get the following values from the Azure AD poral https://aad.portal.azure.com or via PowerShell
$tenantID = '' # (Get-AzureRmTenant).Id
$ApplicationClientID = '' # Get-AzureRmADApplication | Select-Object DisplayName, ApplicationID
$ClientSecret = '' # Only available once under Settings - Keys blade of the app

# Required URLs,  
$graphUrl = 'https://graph.microsoft.com'
$tokenEndpoint = "https://login.microsoftonline.com/$tenantID/oauth2/token"
$userQueryUrl = $graphUrl + "/v1.0/users"

# Create the headers and body so we can get the access token to query the graph
$tokenHeaders = @{
  "Content-Type" = "application/x-www-form-urlencoded";
}

$tokenBody = @{
  "grant_type"    = "client_credentials";
  "client_id"     = "$ApplicationClientID";
  "client_secret" = "$ClientSecret";
  "resource"      = "$graphUrl";
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Headers $tokenHeaders -Body $tokenBody 

# Query the Graph for the users in the tenant. See https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/resources/users
$queryHeaders = @{
  "Content-Type"  = "application/json"
  "Authorization" = "Bearer $($tokenResponse.access_token)"
}

$userList = Invoke-RestMethod -Method Get -Uri $userQueryUrl -Headers $queryHeaders

Write-Output $userList.value.displayName