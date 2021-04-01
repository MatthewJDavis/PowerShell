# Script to query the TeamCity API and get all the last time a build was added to the build queue.
# Requires a user with access to TeamCity to authenticate with the API - credentials add with Get-Credential - this is for the older version of TeamCity that does not support access tokens.
# Do not use a user with sysadmin role - creds are sent base64 encoded! Create a user for this specific task then remove once done (or enable guest auth and update url as needed).
# CSV will be created with all the details or appeneded if one already exists.

# authenticate - create session
$Credential = Get-Credential
$uri = 'https://ci.example.com'
$csvLocation = 'C:\temp\lastQueueDate.csv'

#region create header with credentials
$RESTAPIUser = $Credential.UserName
$Credential.Password | ConvertFrom-SecureString | Out-Null
$RESTAPIPassword = $Credential.GetNetworkCredential().password
$pair = "$($RestAPIUser):$($RESTAPIPassword)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{
    'Authorization' = $basicAuthValue;
    'Accept'        = 'application/xml';
    'Content-Type'  = 'application/xml';
}
#endregion create header with credentials

#region create session
try {
    $server = "$Uri" + '/app/rest/server'
    Invoke-RestMethod -Method Get -UseBasicParsing -Uri $server -Headers $headers -SessionVariable session
} catch [System.Net.WebException] {
    Write-Output $_.exception.message
}
#endregion create session

# list of projects
$projUri = "$uri/app/rest/projects"
[xml]$projectList = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $projUri -WebSession $session

foreach ($project in $projectList.projects.project) {
    #region project
    $projDetailUri = "$uri$($project.href)"
    [xml]$projectDetailList = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $projDetailUri -WebSession $session
    #endregion project
    #region build
    foreach ($build in $projectDetailList.project.buildTypes.buildType) {
        [xml]$lastQueueDate = Invoke-RestMethod -Method Get -UseBasicParsing -Uri "$Uri/app/rest/builds/?locator=buildType:$($build.id),count:1&fields=build(queuedDate)" -WebSession $session

        $buildDetails = [PSCustomObject]@{
            ParentProjectID = "$($project.parentProjectId)"
            buildName       = "$($projectDetailList.project.buildTypes.buildType.name)"
            buildUrl        = "$($build.webUrl)"
            lastQueueDate   = "$($lastQueueDate.builds.build.queuedDate)"
        }
        $buildDetails | Export-Csv -Path $csvLocation -Append 
    }
    #endregion build
}
