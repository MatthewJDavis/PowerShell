$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$Root = Resolve-Path "$projectRoot\Remove-MDOldFile"

Get-Module Remove-MDOldFile | Remove-Module -Force

Import-Module $Root\Remove-MDOldFile.psm1 -Force

Describe "Remove-MDOldFile" {
    $TestDrive = 'TestDrive:\'
    Context "Test removal date logic" {
        # Create 3 test files with last write times of 10, 20 and 30 days ago
        10, 20, 30 | ForEach-Object { Set-Content -Value 'Test'-Path $TestDrive"ofd$_.txt"
            Set-ItemProperty -Path $TestDrive"ofd$_.txt" -Name 'LastWriteTime' -Value (Get-Date).AddDays(-$_)
        }

        It "It removes no files" {
            Remove-MDOldFile -Path  $TestDrive -NumberOfDaysToKeep 45 -FileType 'txt'
            (Get-ChildItem  $TestDrive).count | Should Be 3
        }
        It "It removes 1 file over 25 days old" {
            Remove-MDOldFile -Path  $TestDrive -NumberOfDaysToKeep 25 -FileType 'txt'
            (Get-ChildItem $TestDrive).count | Should Be 2
        }
        It "It removes 2 files over 15 days old" {
            Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 11 -FileType 'txt'
            (Get-ChildItem $TestDrive).count | Should Be 1
        }
        It "It removes all files over 2 days old" {
            Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 2 -FileType 'txt'
            (Get-ChildItem $TestDrive).count | Should Be 0
        }
        It "Warns when a path is not found" {
            Mock Test-Path { return $false }
            Remove-MDOldFile -Path 'TestDrive:\NoPath' -NumberOfDaysToKeep 10 -FileType 'txt' -WarningVariable warn 3> $null
            $warn.message | Should Be 'Path not found'
        }
        Context "File type removal" {
            'txt', 'log', 'etl', 'dll', 'exe', 'msc' | 
            ForEach-Object { Set-Content -Value 'test' -Path $TestDrive"test.$_" }
 
            It "It removes txt files" {
                Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 0 -FileType 'txt'
                $RemainingFiles = (Get-ChildItem -Path $TestDrive).Name 
                ($RemainingFiles -like "*.txt").Count | Should Be 0
            }

            It "It removes log files" {
                Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 0 -FileType 'log'
                $RemainingFiles = (Get-ChildItem -Path $TestDrive).Name 
                ($RemainingFiles -like "*.log").Count | Should Be 0
            }
            It "It removes etl files" {
                Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 0 -FileType 'etl'
                $RemainingFiles = (Get-ChildItem -Path $TestDrive).Name 
                ($RemainingFiles -like "*.etl").Count | Should Be 0
            }
            It "It does not remove dll files" {
                Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 0 -FileType 'txt'
                $RemainingFiles = (Get-ChildItem -Path $TestDrive).Name 
                ($RemainingFiles -like "*.dll").Count | Should Be 1
            }
            It "It does not remove exe files" {
                Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 0 -FileType 'txt'
                $RemainingFiles = (Get-ChildItem -Path $TestDrive).Name 
                ($RemainingFiles -like "*.exe").Count | Should Be 1
            }
            It "It does not remove msc files" {
                Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 0 -FileType 'txt'
                $RemainingFiles = (Get-ChildItem -Path $TestDrive).Name 
                ($RemainingFiles -like "*.msc").Count | Should Be 1
            }
        }
    }
}