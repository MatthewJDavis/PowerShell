function New-MDSlackMessage {
    <#
    .SYNOPSIS
        Send a message to Slack
    .DESCRIPTION
        Send a JSON payload to slack consisting of a text message
    .EXAMPLE
        New-MDSlackMessage -URI $SlackHook -Message 'hi'
        
        Send the message 'hi' to slack
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        Requires a Slack app https://api.slack.com/apps and the URI of the slack hook and a valid bearer token passed to it
    #>
    param(
        # URI of Slack Hook
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $URI,
        # Message To Send
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $Message
    )
    
    $payload = @{
        "text" = $Message
    }

    Invoke-RestMethod -Method Post -Uri $SlackHook  -Body (ConvertTo-Json -InputObject $payload -Compress) -UseBasicParsing | Out-Null
}