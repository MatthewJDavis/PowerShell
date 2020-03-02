Deploy PluginsToQA {
    By FileSystemRemote QA {
        FromSource 'poshbot-plugin'
        To '\\192.168.33.20\temp'
        Tagged QA
        WithOptions @{
            Mirror       = $True
            ComputerName = $server
            Credential   = $cred
            ConfigurationName = 'SomeSessionConfig'
        }
    }
    By FileSystem Prod {
        FromSource 'poshbot-plugin'
        To 'C:\Temp\poshbotprod\poshbot-plugin'
        Tagged Prod
    }
}