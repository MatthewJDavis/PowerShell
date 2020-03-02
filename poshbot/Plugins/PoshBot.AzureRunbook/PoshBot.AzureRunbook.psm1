$Width = 80

function Invoke-AzureRunbook {
    <#
  .SYNOPSIS
    Get the status of a website

  .EXAMPLE
    !Invoke-AzureRunbook
    Invokes an Azure runbook
  .INPUTS
    Inputs (if any)
  .OUTPUTS
    Output (if any)
  .NOTES
    General notes
  #>

    [PoshBot.BotCommand(
        CommandName = 'azurerunbook',
        Permissions = 'write',
        Aliases = ('runbook', 'rb')
    )]

    [CmdletBinding()]
    param (
        # URL of the website
        [Parameter(Position = 0)]
        [String]
        $Message
    )

    $payload = @(
        @{
            "Message" = "$Message"
        }
        @{
            "Channel" = "$($PoshBotContext.To)"
        }
    )

    $body = ConvertTo-Json -InputObject $payload

    $uri = ''

    $response = Invoke-WebRequest -Uri $uri -UseBasicParsing -Method Post -Body $body
    
    if ($response.StatusDescription -eq 'Accepted') {
        $o = "The request was accepted by the Azure runbook and will be processed. Job details: $($response.Content)" | Out-String -Width $Width
    } else {
        $o = "There was an error with the Azure runbook. Please try again or raise a request with the details $($response.Content)"  | Out-String -Width $Width
    }

    New-PoshBotCardResponse -Type Normal -Text $o
}   

Export-ModuleMember -Function Invoke-AzureRunbook