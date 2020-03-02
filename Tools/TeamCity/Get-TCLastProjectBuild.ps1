function Get-TCLastProjectBuild {
  [CmdletBinding()]
  param (
    # Parameter help description
    [Parameter(Mandatory=$true)]
    [string]
    $UserName,
    # Parameter help description
    [Parameter(Mandatory=$true)]
    [string]
    $Password
  )
  
  begin {
  }
  
  process {
    
        $pair = "$($UserName):$($Password)"
        $url = 'http://51.143.152.188:8111/guestAuth/app/rest/projects'

        $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
        $basicAuthValue = "Basic $encodedCreds"
        $headers = @{
            "Authorization" = $basicAuthValue;
            "Accept" = "application/xml";
            "Content-Type" = "application/xml";
        }

        [xml]$projects = Invoke-RestMethod -Method get -Uri $url -Headers $headers
        [xml]$projects = Invoke-RestMethod -uri $url -UseBasicParsing$
        $i = 1
        foreach($project in $projects){
          
          $projectId = $projects.projects.project.id[$i]
          $lastBuildUrl = "http://51.143.152.188:8111/guestAuth/app/rest/builds/?locator=project:$projectId,count:1"
          [xml]$lastBuilds = Invoke-WebRequest -Uri $lastBuildUrl
          $i++
        }
                
        Return $lastBuilds
        
  }
  
  end {
  }
}