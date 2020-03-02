# From: https://poshbot.readthedocs.io/en/latest/guides/quickstart/
# http://ramblingcookiemonster.github.io/PoshBot/

# Install the module from PSGallery
Install-Module -Name PoshBot -Repository PSGallery

# Import the module
Import-Module -Name PoshBot

$Token = ''
$BotName = 'test-bot' 
$BotAdmin = 'matt'
$PoshbotPath = 'C:\poshbot'
$PoshbotConfig = Join-Path $PoshbotPath config.psd1
$PoshbotPlugins = Join-Path $PoshbotPath plugins
$PoshbotLogs = Join-Path $PoshbotPath logs

$BotParams = @{
  Name                     = $BotName
  BotAdmins                = $BotAdmin
  CommandPrefix            = '!'
  LogLevel                 = 'Info'
  BackendConfiguration     = @{
    Name  = 'SlackBackend'
    Token = $Token
  }
  AlternateCommandPrefixes = 'bender', 'hal'
  ConfigurationDirectory   = $PoshbotPath
  LogDirectory             = $PoshbotLogs
  PluginDirectory          = $PoshbotPlugins
}

# Set up folders for logging and plugins, save the config
$null = mkdir $PoshbotPath, $PoshbotPlugins, $PoshbotLogs -Force
$pbc = New-PoshBotConfiguration @BotParams
Save-PoshBotConfiguration -InputObject $pbc -Path $PoshbotConfig


# Start a new instance of PoshBot interactively or in a job.
Start-PoshBot -Configuration $pbc #-AsJob