$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Update-Sysinternals'{
    Context 'Input'{
        It 'Throws an exception if the path is not found' {
            Mock Test-Path {
                $false
            }
            Update-Sysinternals -Path 'c:\jklfj' | Should Throw 
        }
    }
    Context 'Execution'{

    }
    Context 'Output'{

    }
}