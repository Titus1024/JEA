# PowerShell JEA

[JEA (Just Enough Administration)](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/overview?view=powershell-5.1) is natively supported on Windows and requires minimal setup on the individual machines.

## Excerpts from [Overview of Just Enough Administration (JEA) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/overview?view=powershell-5.1)

>Just Enough Administration (JEA) is a security technology that enables delegated administration for anything managed by PowerShell. With JEA, you can:
>
>* Reduce the number of administrators on your machines using virtual accounts or group-managed service accounts to perform privileged actions on behalf of regular users.
>* Limit what users can do by specifying which cmdlets, functions, and external commands they can run.
>* Better understand what your users are doing with transcripts and logs that show you exactly which commands a user executed during their session.
>
>JEA addresses this problem through the principle of Least Privilege. With JEA, you can configure a management endpoint for DNS administrators that gives them access only to the PowerShell commands they need to get their job done. This means you can provide the appropriate access to repair a poisoned DNS cache or restart the DNS server without unintentionally giving them rights to Active Directory, or to browse the file system, or run potentially dangerous scripts. Better yet, when the JEA session is configured to use temporary privileged virtual accounts, your DNS administrators can connect to the server using non-admin credentials and still run commands that typically require admin privileges. JEA enables you to remove users from widely privileged local/domain administrator roles and carefully control what they can do on each machine.

## Configuring a node with JEA

1. Identify the JEA role of the node(s)
    * Development, Database Etc.
2. Identify the sub role of the node(s)
    * ProjectA, PreProdDatabase, ProductionDatabase, etc.
3. Copy the required folders to the C:\JEA directory on the node. If this directory does not exist, create it.
    * JEA.Config
    * JEA.Dev.ProjectA, JEA.Database.PreProd, etc.
4. Launch PowerShell as admin on the node(s) and run the below command to register the node(s) with JEA

    ```PowerShell
    Register-PSSessionConfiguration -Name JEA.Database.PreProd -Path C:\JEA\JEA.Database.PreProd\SessionConfiguration\JEA.Database.PreProd.pssc
    ```

## Traditional JEA Configuration VS Modular JEA Configuration

### Traditional

```PowerShell
@{
    # List of visible cmdlets with parameters
    VisibleCmdlets          = @(
        @{ Name = 'Get-Process'; Parameters = @{ Name = @{ ValidatePattern = '^[a-zA-Z0-9]+$' }; Id = @{ ValidatePattern = '^\d+$' } } },
        @{ Name = 'Restart-Service'; Parameters = @{ Name = @{ ValidatePattern = '^[a-zA-Z0-9]+$' }; Force = @{ ValidateSet = $true, $false } } },
        @{ Name = 'Stop-Service'; Parameters = @{ Name = @{ ValidatePattern = '^[a-zA-Z0-9]+$' }; Force = @{ ValidateSet = $true, $false } } },
        @{ Name = 'Start-Service'; Parameters = @{ Name = @{ ValidatePattern = '^[a-zA-Z0-9]+$' }; PassThru = @{ ValidateSet = $true, $false } } },
        @{ Name = 'Get-Service'; Parameters = @{ Name = @{ ValidatePattern = '^[a-zA-Z0-9]+$' }; DisplayName = @{ ValidatePattern = '^[a-zA-Z0-9\s]+$' } } },
        @{ Name = 'Set-Service'; Parameters = @{ Name = @{ ValidatePattern = '^[a-zA-Z0-9]+$' }; Status = @{ ValidateSet = 'Running', 'Stopped' } } },
        @{ Name = 'New-Item'; Parameters = @{ Path = @{ ValidatePattern = '^[\w\\:]+$' }; ItemType = @{ ValidateSet = 'Directory', 'File' } } },
        @{ Name = 'Remove-Item'; Parameters = @{ Path = @{ ValidatePattern = '^[\w\\:]+$' }; Force = @{ ValidateSet = $true, $false } } },
        @{ Name = 'Get-Content'; Parameters = @{ Path = @{ ValidatePattern = '^[\w\\:]+$' }; Encoding = @{ ValidateSet = 'ASCII', 'UTF8', 'Unicode', 'UTF7', 'UTF32', 'BigEndianUnicode', 'Default', 'OEM' } } },
        @{ Name = 'Set-Content'; Parameters = @{ Path = @{ ValidatePattern = '^[\w\\:]+$' }; Value = @{ ValidatePattern = '^[\w\s]+$' } } }
    )

    # List of visible functions
    VisibleFunctions        = 'Invoke-HelpDeskFunction'

    # List of visible external commands
    VisibleExternalCommands = 'C:\\Windows\\System32\\notepad.exe'

    # List of visible aliases
    VisibleAliases          = 'gci', 'ls', 'dir'

    # List of visible providers
    VisibleProviders        = 'FileSystem', 'Registry'
}
```

Using the traditional configuration you can see with only 10 commands there is already a dense amount of configuration in the PSRC. Additionally, a large amount of duplicate code for similar and separate JEA profiles that is hard to update across the board.

### Modular

```PowerShell
@{
    # Modules to import when applied to a session
    VisibleAliases = $roleCapabilityConfiguration.PSRC.JEA.Database.PreProd.visibleAliases

    # Cmdlets to make visible when applied to a session
    VisibleCmdlets = @($roleCapabilityConfiguration.PSRC.JEA.Database.PreProd.visibleCmdlets)

    # External commands (scripts and applications) to make visible when applied to a session
    VisibleExternalCommands = $roleCapabilityConfiguration.PSRC.JEA.Database.PreProd.visibleExternalCommands
    
    # Functions to make visible when applied to a session
    VisibleFunctions = $roleCapabilityConfiguration.PSRC.JEA.Database.PreProd.visibleFunctions
    
    # Providers to make visible when applied to a session
    VisibleProviders = $roleCapabilityConfiguration.PSRC.JEA.Database.PreProd.visibleProviders

    # Scripts to run when applied to a session
    ScriptsToProcess = $roleCapabilityConfiguration.PSRC.JEA.Database.PreProd.scriptsToProcess
}
```

The amount of configuration in the PSRC is always the same. Updating configuration settings is immediate and easy to track and manage.
Using the modular approach does have more initial overhead, but the benefits far outweigh the cost in the long term.

### How modular configuration works

The global JEA config lives in a JSON file and the configuration profiles are created with buildConfig.ps1

```JSON
{
"VisibleCmdlets": {
            "getService": {
                "name": "Get-Service",
                "parameters": {
                    "name": {
                        "parameterName": "Name",
                        "validateSet": {
                            "spooler": "spooler"
                        },
                        "validatePattern": {
                            "appSupport": "IT\\..+"
                        }
                    },
                    "displayName": {
                        "parameterName": "DisplayName",
                        "validateSet": {
                            "spooler": "Print Spooler"
                        },
                        "validatePattern": {
                            "appSupport": "IT\\..+"
                        }
                    }
                }
            }
        }
}
```

The modular approach also allows for simple reuse of common commands, aliases, etc.

```PowerShell
$buildRoleCapabilityConfiguration = @{
            defaultConfig       = @{
                scriptsToProcess        = @(
                    $config.RoleCapabilities.scriptsToProcess.welcomeMessage
                )
                visibleAliases          = @(
                    $config.RoleCapabilities.VisibleAliases.ls
                    $config.RoleCapabilities.VisibleAliases.dir
                    $config.RoleCapabilities.VisibleAliases.pwd
                    $config.RoleCapabilities.VisibleAliases.cd
                )
                visibleCmdlets          = @(
                    @{
                        getLocation               = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.getLocation.Name
                            Parameters = @{
                                Name = '*'
                            }
                        }
                        setLocation               = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.setLocation.Name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.setLocation.parameters.path.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.setLocation.parameters.path.validatePattern.logsAndConfig
                            }
                        }
                        getContent                = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.getContent.Name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.getContent.parameters.path.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.getContent.parameters.path.validatePattern.logsAndConfig
                            }
                        }
                    }
                ) 
                visibleFunctions        = @(
                    $config.RoleCapabilities.VisibleFunctions.enableTabCompletion
                )
                visibleExternalCommands = @(
                    $config.RoleCapabilities.VisibleExternalCommands.ping
                    $config.RoleCapabilities.VisibleExternalCommands.ipconfig
                )
                visibleProviders        = @(
                    $config.RoleCapabilities.VisibleProviders.fileSystem
                )
            }
            appSupportSubDomain = @{
                visibleCmdlets = @(
                    @{
                        getService = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.getService.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.getService.parameters.name.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.getService.parameters.name.validatePattern.appSupport
                            },
                            @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.getService.parameters.displayName.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.getService.parameters.displayName.validatePattern.appSupport
                            }
                        }
                    }
                )
            }
}
```
