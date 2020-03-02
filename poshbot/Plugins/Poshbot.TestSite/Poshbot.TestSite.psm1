$Width = 80

function Invoke-SiteStatus {
    <#
  .SYNOPSIS
    Get the status of a website

  .EXAMPLE
    !Invoke-SiteStatus
    Explanation of what the example does
  .INPUTS
    Inputs (if any)
  .OUTPUTS
    Output (if any)
  .NOTES
    General notes
  #>

    [PoshBot.BotCommand(
        CommandName = 'sitestatus',
        Permissions = 'read',
        Aliases = ('site', 'ss')
    )]

    [CmdletBinding()]
    param (
        # URL of the website
        [Parameter(Position = 0)]
        [String]
        $Url
    )
    if ($url.Length -gt 0) {
        $r = Invoke-WebRequest -Uri $Url -UseBasicParsing
    }
  

    if ($r.StatusCode -eq 200) {
        $o = "Site is OK, $($r.StatusCode) received" | Out-String -Width $Width
        Write-Output "Site is OK, $($r.StatusCode) received"
    } elseif ($r.status) {
        Write-Output "Did not get a 200 OK status. Got: $r.StatusCode"
        $o = "Did not get a 200 OK status. Got: $r.StatusCode" | Out-String -Width $Width
    } else {
        Write-Output "Error connecting to: $url"
        $o = "Error connecting to: $url" | Out-String -Width $Width

    }
    New-PoshBotCardResponse -Type Normal -Text $o
}

Export-ModuleMember -Function Invoke-SiteStatus