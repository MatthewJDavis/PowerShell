Properties {
    $creds = $credential
    $ComputerName = $ComputerName
}


Task default -depends Test

Task AnalysePlugin {
    $moduleResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\Plugins\*\*.psm1  -Severity @('Error', 'Warning')
    if ($moduleResults) {
        $moduleResults | Format-Table
        Write-Error -Message 'One or more script analyser errors/ warnings were found'
    }
}

Task test -depends AnalysePlugin {
    'running tests'
}

Task deployQA -depends test {
    'Deploying to QA'
    $s = New-PSSession -ComputerName $ComputerName -Credential $creds
    Copy-Item $PSScriptRoot\plugins\* -ToSession $s -Destination C:\poshbot\plugins -Recurse -Force
    Invoke-Command -Session $s -ScriptBlock { Restart-Service -Name 'poshbot1' }
    Remove-PSSession -Session $s 
}

Task deployProd -depends test {
    'Deploying to prod'
    Invoke-PSDeploy -Tags Prod -Force
}