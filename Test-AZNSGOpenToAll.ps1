# Check AZ NSG for RDP wide open

$subscriptionIdList = (Get-AzSubscription).Id

    foreach ($subcriptionId in $subscriptionIdList){
    Set-azcontext -Subscription $subcriptionId | Out-Null
    
    $nsgList = Get-AzNetworkSecurityGroup
        Write-Output "Open RDP ports to the internet in subscription $((Get-AzContext).Name)"
        foreach ($nsg in $nsgList){
            if ($nsg.SecurityRules.DestinationPortRange -contains 3389 -and $nsg.SecurityRules.SourcePortRange -eq '*'){
                    "Network security group name: $($nsg.Name)"
                    "Security Rule Name: $($nsg.SecurityRules | Where-Object -Property DestinationPortRange -contains 3389| Select-Object -ExpandProperty name)"
            }
        }
    }



# Add deny all 100 rule

foreach ($subcriptionId in $subscriptionIdList){
    Set-azcontext -Subscription $subcriptionId | Out-Null
    (Get-AzContext).Name
    $nsgList = Get-AzNetworkSecurityGroup
  
      foreach ($nsg in $nsgList){
          if ($nsg.SecurityRules.DestinationPortRange -contains 3389 -and $nsg.SecurityRules.SourcePortRange -eq '*'){
                  $nsg.Name
                  $nsg.SecurityRules | Where-Object -Property DestinationPortRange -contains 3389| Select-Object name
                  Add-AzNetworkSecurityRuleConfig -Name 'DenyAll' -Description 'Deny all traffic' -Protocol '*' -DestinationPortRange '*' -NetworkSecurityGroup $nsg -SourcePortRange '*' -Priority '100' -Direction Inbound -Verbose -Access Deny -SourceAddressPrefix '*' -DestinationAddressPrefix '*'
                  Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg
              }
      }
  }
