task default -depends AnalyseFunction
$ModuleName = 'Remove-MDOldFile'

task AnalyseFunction {
    'Running Script Analyser on the function'
    $FunctionSAResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\$ModuleName\*.psm1 -Severity @('Error', 'Warning') 
    if ($FunctionSAResults) {
        $FunctionSAResults | Format-Table
        Write-Error -Message 'One or more script analyser errors/ warnings were found'
    }
}

task RunFunctionTests {
    'Running Pester test on the function'
    $FunctionTestResults = Invoke-Pester -Path $PSScriptRoot\Tests\$ModuleName.Tests.ps1 -PassThru -OutputFile results.xml -OutputFormat NUnitXml
    if ($FunctionTestResults.FailedCount -gt 0) {
        $FunctionTestResults | Format-Table
        Write-Error -Message 'One or more pester tests failed.'
    }
}

task RunManifestTests {
    'Running Pester test on the module manifest'
    $ManifestTestResults = Invoke-Pester -Path $PSScriptRoot\Tests\Manifest.Tests.ps1 -PassThru -OutputFile results.xml -OutputFormat NUnitXml
    if ($ManifestTestResults.FailedCount -gt 0) {
        $ManifestTestResults | Format-Table
        Write-Error -Message 'One or more pester tests failed.'
    }
}

task DeployModule -depends AnalyseFunction, RunFunctionTests, RunManifestTests {
    'Deploying module'
    Copy-Item $PSScriptRoot\Remove-MDOldFile -Destination C:\TEMP -Recurse -Force
    # $Env:PSModulePath += ';' + (Resolve-Path .) for deploying to a PowerShell repo
}