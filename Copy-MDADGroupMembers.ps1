# Copy groups members from one AD group to another AD group.
$sourceGroup = ''
$destinationGroup = ''
$userList = Get-ADGroupMember -Identity $sourceGroup

foreach($user in $userList) {
  Add-ADGroupMember -Identity $destinationGroup -Members $user.samaccountname
}
