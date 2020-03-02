function Start-DailyOnEC2 {
    [CmdletBinding()]
    <#
    .SYNOPSIS
        Turn on EC2 instances with a 'DailyOn' tag value of 'True'
    .DESCRIPTION
        Turn on Ec2 instances that are not in a running state and have the tag DailyOn with the value True. Script can be run on a schedule to power on test instances.
        Premissions needed to start EC2 instances for running this script
        #Requires -Module AWSPowerShell.NetCore
        #Requires -PSEdition Core
    .EXAMPLE
        PS C:\> Start-DailyOnEC2
        Starts EC2 instances with a daily on tag in the eu-west-1 region
        PS C:\> Start-DailyOnEC2 -Region us-west-1
        Starts EC2 instances with a daily on tag in the us-west-1 region
    .INPUTS
    .OUTPUTS
    .NOTES
    #>
    param (
        # AWS Region
        [Parameter()]
        [string]
        $Region = 'eu-west-1'
    )
    
    begin {
        Set-DefaultAWSRegion -Region $Region
    }
    process {
        # Get all ec2 instances with DailyOn tag set to true
        try {
            $ec2List = Get-EC2Instance -Filter @(@{name = 'tag:DailyOn'; values = 'True' })
            # Only start instances that are not in a running state
            $ec2List | ForEach-Object {
                if ($_.Instances.state.Name.Value -ne 'running') {
                    Write-Output "Starting $($_.Instances.instanceid)"
                    Start-EC2Instance $_.Instances.instanceid | Out-Null
                } else {
                    Write-Output "$($_.Instances.instanceid) already running"
                }
            }
        } catch {
            Write-Output $_.Exception.Message
        }
    }
    end {
    }
}
