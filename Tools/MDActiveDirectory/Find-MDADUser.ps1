<#
.SYNOPSIS
    Finds an AD user by name
.DESCRIPTION
    Finds an AD user based on the string provided for the name. Default is to filter by GivenName, use switch to filter by surname.
.EXAMPLE
    PS C:\> Find-MDADUser -Name matthew
    Filters and returns users in AD who have the GivenName of Matthew
.Example
    PS C:\> Find-MDADUser -Name smith -Surname
    Filters and returns users in AD who have the surname of Smith
.NOTES
    Saves having to type the filter query lots
#>

function Find-MDADUser {
    [CmdletBinding()]
    param(
        # Name to find
        [Parameter()]
        [string]
        $Name,
        # surname to find
        [Parameter()]
        [switch]$Surname
    )
    switch ($surname) {
        $true { Get-ADUser -filter {Surname -like $Name} }
        Default { Get-ADUser -filter { GivenName -like $Name } }
    }   
}

