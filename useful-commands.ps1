# Place to store useful oneliners

# Find the sources that can log to an eventlog
(Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application).pschildname


# Remove a user / group from directories - must remove inheritance first
# Remove inheritance
$acl = Get-Acl -Path $folderName
$acl.SetAccessRuleProtection($true,$true)
Set-Acl -Path $folderName -AclObject $acl

# Remove user access
$acl = Get-Acl -Path $folderName
$acl.Access | Where-Object {$_.IdentityReference -eq "BUILTIN\Users" } | ForEach-Object { $acl.RemoveAccessRuleSpecific($_) }
Set-Acl -Path $folderName -AclObject $acl

# AWS parameter for cloudformation stack
function New-CloudFormationParameter ($paramName, $paramValue) {
  $parameter = new-object Amazon.CloudFormation.Model.Parameter 
  $parameter.ParameterKey = $paramName
  $parameter.ParameterValue = $paramValue
  Return $parameter
}

$subNet = New-CloudFormationParameter -paramName 'SubnetId' -paramValue $instanceSubnet
$key = New-CloudFormationParameter -paramName 'KeyName' -paramValue $instanceKey
$stackName = 'win-stack'

# update with path to the cloudformation
$template = Get-Content -Path './windows-cloudformation.yml' -Raw

# test the template is valid
Test-CFNTemplate -TemplateBody $template

# create the cloudformation
$params = @($imageId, $name, $description, $owner, $availabilityZone, $iamProfile, $vpcID, $subNet, $key)

New-CFNStack -StackName $stackName -TemplateBody $template -Parameter $params

# get the private IP address
(Get-CFNStack -StackName $stackName).outputs.outputvalue

# get the instanceid from the cloudformation
$instanceId = (Get-CFNStackResources -StackName $stackName | Where-Object -Property LogicalResourceId -EQ 'Ec2Instance').PhysicalResourceId

#location of pem file
$pemfileLocation = ''

Get-EC2PasswordData -InstanceId $instanceId -PemFile $pemfileLocation -Decrypt
