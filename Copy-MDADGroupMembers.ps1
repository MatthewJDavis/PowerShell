# Copy groups members from one AD group to the target AD group.
$baseGroup = ''
$targetGroup = ''
$userList = Get-ADGroupMember -Identity $baseGroup

foreach($user in $userList) {
  Add-ADGroupMember -Identity $targetGroup -Members $user.samaccountname
}
