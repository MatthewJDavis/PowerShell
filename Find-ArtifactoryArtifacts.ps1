# Find interesting files stored on artifactory

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ReportPath = '/tmp/artifacts.html'
)

$baseUri = 'http://localhost/artifactory/api/'
$searchUri = $baseUri + 'search/artifact?name='
$wordList = 'pem', 'password', 'credentials', 'creds', 'key', 'id_rsa', 'pfx'
$resultList = [collections.generic.list[string]]::new()
$artifactList = [collections.generic.list[psCustomObject]]::new()

#region Search artifacts
foreach ($word in $wordList) {
    $query = $searchUri + '*.' + $word

    $result = Invoke-RestMethod -Method Get -Uri $query

    if ($result.results.count -gt 0) {
        foreach ($uri in $result.results.uri) {
            $resultList.Add($uri)
        }
    }
}
#endregion

#region Artifact details
foreach ($result in $resultList) {
    # Artifact stats
    $statUri = $baseUri + 'storage/' + $result.Split('/')[-2] + '/' + $result.Split('/')[-1] + '?stats'
    $stats = Invoke-RestMethod -Method Get -Uri $statUri

    # Artifact properties
    $propUri = $baseUri + 'storage/' + $result.Split('/')[-2] + '/' + $result.Split('/')[-1] + '?properties\[=x[, y]\]'
    $props = Invoke-RestMethod -Method Get -Uri $propUri

    $artifactDetails = [PSCustomObject]@{
        path                 = $props.path
        repo                 = $props.repo
        createdBy            = $props.createdBy
        created              = $props.created
        downloadCount        = $stats.downloadCount
        lastDownloaded       = $stats.lastDownloaded
        remoteDownloadCount  = $stats.remoteDownloadCount
        remoteLastDownloaded = $stats.lastDownloaded
        lastModified         = $props.lastModified
        modifiedBy           = $props.modifiedBy
        lastUpdated          = $props.lastUpdated
        uri                  = $stats.uri
    }
    $artifactList.Add($artifactDetails)
}
#endregion Artifact details

#region Report
$title = "<h1>Files found in Artifactory: $baseUri</h1>"
$count = "<h2>Artifacts found: " + $artifactList.Count + "</h2>"

$body = [collections.generic.list[string]]::new()

foreach ($artifact in $artifactList) {
    $artHtml = $artifact | ConvertTo-Html -Fragment -As List -PreContent "<h3>$($artifact.path.split('/'))</h3>"
    $body.Add($artHtml)
}

$header = @"
    <style>

    h1 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;
    }
    h2 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;
    }
    h3 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 14px;
    }
    table {
        font-size: 12px;
        border: 0px;
        font-family: Arial, Helvetica, sans-serif;
    }
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}
    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
    </style>
"@

$report = ConvertTo-Html -Body "$title $count $body" -Title 'Artifactory file report' -Head $header
$report | Out-File $ReportPath
#endregion Report

