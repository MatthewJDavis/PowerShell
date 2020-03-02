$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Restore-MDADUser" {
  Context "Test for enabled AD recycle bin"{
    Mock -CommandName Get-ADOptionalFeature {
      [Microsoft.ActiveDirectory.Management.ADOptionalFeature] @{ 
        DistinguishedName  = 'cn=test'
        EnabledScopes      = '$Null' 
        FeatureGUID        = New-Guid
        FeatureScope       = {ForestOrConfigurationSet}
        IsDisableable      = False
        Name               = 'Recycle Bin Feature'
        ObjectClass        = msDS-OptionalFeature
        ObjectGUID         = New-Guid
        RequiredForestMode = Windows2008R2Forest
      }
    }
    It "Should error if there is no AD recycle bin enabled" {
      Restore-MDADUser -sAMAccountName 'test.mctest' | Should Throw
    }
  }
}