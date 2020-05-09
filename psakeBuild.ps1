Task default -depends Analyse

Task Analyse -description 'Analyse script with PSScriptAnalyzer' {
    $saResults = Invoke-ScriptAnalyzer -Path Tools\*.ps1 -Severity @('Warning', 'Error')
    if($saResults) {
        $saResults | Format-Table
        Write-Error -Message 'One or more Script Analyser errors/warnings were found'
    }
}
