$ModuleName = 'Remove-MDOldFile'
$FunctionName = 'Remove-MDOldFile'

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$Root = Resolve-Path "$projectRoot\$ModuleName"

Get-Module $ModuleName | Remove-Module -Force

$ModuleInformation = Import-Module $Root\$ModuleName.psd1 -Force -PassThru

$ExportedFunctions = $ModuleInformation.ExportedFunctions.Values.Name

Describe "$ModuleName Module - Testing Manifest File (.psd1)" {
    Context 'Manifest' {
        It "Should have an author" {
            $ModuleInformation.Author | Should not BeNullOrEmpty
        }
        It "Should export 1 function" {
            $ExportedFunctions.count | Should Be 1
        }
        It "Should export $FunctionName function" {
            $ExportedFunctions | Should Be $FunctionName 
        }
    }
}

