$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-ADOuFromDN" {
    It "Alerts that OU is not found in the string" {
        Get-ADOuFromDN -DistinguishedName 'DN=joebloggs,DC=Boss,DC=Com' | Should Be $false 
    }
    It "Removes the DN and returns a string starting with OU" {
        Get-ADOuFromDN -DistinguishedName 'DN=joebloggs,OU=Users,DC=Boss,DC=Com' | Should -eq 'OU=Users,DC=Boss,DC=Com'
    }
    It "Returns from the first OU entry" {
        Get-ADOuFromDN -DistinguishedName 'DN=joebloggs,OU=Users,OU=IT,OU=TopDogs,DC=Boss,DC=Com' | Should -eq 'OU=Users,OU=IT,OU=TopDogs,DC=Boss,DC=Com'
    }
}
