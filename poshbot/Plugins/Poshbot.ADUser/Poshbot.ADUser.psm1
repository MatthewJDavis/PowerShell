Import-Module -Name ActiveDirectory

$Width = 80

function Get-ADUserStatus {
    <#
    .SYNOPSIS
    Get the status of an AD user
    Requires the users samAccountName with the -identity parameter or search for samAccountNames with the -name parameter
    .EXAMPLE
    !Get-ADUserStatus -i test.mctest
    !Get-ADUserStatus -identity test.mctest
    Gets the account status of the user test.mctest

    !Get-ADUserStatus -n test
    !Get-ADUserStatus -name test
    Returns a list of samAccountNames of users with the name test
    .INPUTS
    AD identity
    AD name
    .OUTPUTS
    Output (if any)
    .NOTES
    General notes
#>

    [PoshBot.BotCommand(
        CommandName = 'aduserstatus',
        Permissions = 'read',
        Aliases = ('us', 'userstatus')
    )]

    [CmdletBinding()]
    param (
        # Identity of AD User
        [Parameter(Position = 1)]
        [Alias('i')]
        [String]
        $Identity,
        # Search by name
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [Alias('n')]
        [String]
        $Name
    )

    if ( $PSBoundParameters.ContainsKey('Name')) {
        $userList = Get-ADUser -Filter "Name -like '*$Name*'"

        if ($userList.count -gt 0) {
            $Title = "List of SamAccountNames for the user name: $($Name)" 
            $o = $userList.samaccountname | Format-List | Out-String -Width $Width
            $Type = 'Normal'
        } else {
            # no users found with specified name
            $Title = 'No Users found'  
            $o = "Unable to find any users with the name $Name"
            $Type = 'Warning'
        }
    } else {
        $user = Get-ADUser -Filter { SamAccountName -eq $Identity } -Properties Enabled, LockedOut, PasswordExpired, PasswordLastSet, LastBadPasswordAttempt, Description

        if ($user) {
            $properties = [ordered]@{
                Enabled                = $user.Enabled
                LockedOut              = $user.LockedOut
                PasswordExpired        = $user.PasswordExpired
                PaswordLastSet         = $user.PasswordLastSet
                PasswordExpires        = ($user.PasswordLastSet).AddDays(90)
                LastBadPasswordAttempt = $user.LastBadPasswordAttempt
                Description            = $user.Description
            }
            $userStatus = New-Object -TypeName psobject -Property $properties
            $Title = "SamAccountName $($user.SamAccountName)" 
            $o = $userStatus | Format-List | Out-String -Width $Width
            $Type = 'Normal'
        } else {
            $Title = 'User Not found'  
            $o = "Unable to find user with the SamAccountName $Identity"
            $Type = 'Warning'
        }
    }


    New-PoshBotCardResponse -Title $Title -Type $Type -Text $o
}

Export-ModuleMember -Function Get-ADUserStatus