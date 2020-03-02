#Simple script to create an AD user
function New-MDADUser {

  [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
  param(
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $FirstName,
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $Surname,
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [SecureString]
    $Password
  )

  $displayName = "$FirstName $Surname"
  $path = ',OU=Users,DC=example,DC=com'
  $description = 'Example of creating a user'
  $domain = 'example.com'
  $samAcctName = ("$FirstName.$Surname").ToLower()
  $upn = "$samAcctName@$domain"

  $params = @{
    'Name'                  = $displayName;
    'GivenName'             = $FirstName;
    'surname'               = $Surname;
    'DisplayName'           = $displayName;
    'Path'                  = $path;
    'Description'           = $description;
    'UserPrincipalName'     = $upn;
    'SamAccountName'        = $samAcctName;
    'AccountPassword'       = $Password;
    'ChangePasswordAtLogon' = $false;
    'Enabled'               = $true
  }

  if ($PSCmdlet.ShouldProcess()) {
    New-ADUser @params
  }
}
