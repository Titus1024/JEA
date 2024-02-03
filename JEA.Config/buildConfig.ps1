function buildJEAConfiguration {
    param(
        [Parameter(Mandatory)]
        [string]
        $ConfigurationName
    )
    function getJSONConfig {
        $config = Get-Content 'C:\JEA\JEA.Config\config.json'
        $json = $config | ConvertFrom-Json
        return $json
    }
    
    function buildRoleCapabilityConfiguration {
        $buildRoleCapabilityConfiguration = @{
            defaultConfig       = @{
                scriptsToProcess        = @(
                    $config.RoleCapabilities.scriptsToProcess.authorizedAccessDisclaimer
                    $config.RoleCapabilities.scriptsToProcess.welcomeMessage
                )
                visibleAliases          = @(
                    $config.RoleCapabilities.VisibleAliases.ls
                    $config.RoleCapabilities.VisibleAliases.dir
                )
                visibleCmdlets          = @(
                    @{
                        getService = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.getService.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.getService.parameters.name.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.getService.parameters.name.validatePattern.appSupport
                            },
                            @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.getService.parameters.displayName.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.getService.parameters.displayName.validatePattern.appSupport
                            }
                        }
                    }
                    @{
                        restartService = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.restartService.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.name.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.name.validatePattern.appSupport
                            },
                            @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.displayName.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.displayName.validatePattern.appSupport
                            }
                        }
                    }
                    @{
                        getProcess = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.getProcess.name
                            Parameters = @{
                                Name = $config.RoleCapabilities.visibleCmdlets.getProcess.parameters.name.parameterName
                            },
                            @{
                                Name = $config.RoleCapabilities.visibleCmdlets.getProcess.parameters.Id.parameterName
                            }
                        }
                    }
                ) 
                visibleFunctions        = @(
                    $config.RoleCapabilities.VisibleFunctions.enableTabCompletion
                    $config.RoleCapabilities.VisibleFunctions.getLogs
                    $config.RoleCapabilities.VisibleFunctions.restartCustomServices
                    $config.RoleCapabilities.VisibleFunctions.getProcessInformation
                )
                visibleExternalCommands = @(
                    $config.RoleCapabilities.VisibleExternalCommands.ping
                    $config.RoleCapabilities.VisibleExternalCommands.ipconfig
                )
            }
            appSupportDomain    = @{
                scriptsToProcess        = @(
                    $config.RoleCapabilities.scriptsToProcess.authorizedAccessDisclaimer
                    $config.RoleCapabilities.scriptsToProcess.welcomeMessage
                )
                visibleAliases          = @(
                    $config.RoleCapabilities.VisibleAliases.ls
                    $config.RoleCapabilities.VisibleAliases.dir
                )
                visibleCmdlets          = @(
                    @{
                        getIisAppPool = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.getIisAppPool.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.getIisAppPool.parameters.name.parameterName
                                ValidatePattern = '*'
                            }
                        }
                    }
                    @{
                        restartWebAppPool = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.restartWebAppPool.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.restartWebAppPool.parameters.name.parameterName
                                ValidatePattern = '*'
                            }
                        }
                    }
                ) 
                visibleFunctions        = @(
                    $config.RoleCapabilities.VisibleFunctions.enableTabCompletion
                    $config.RoleCapabilities.VisibleFunctions.getLogs
                    $config.RoleCapabilities.VisibleFunctions.restartCustomServices
                    $config.RoleCapabilities.VisibleFunctions.getProcessInformation
                )
                visibleExternalCommands = @(
                    $config.RoleCapabilities.VisibleExternalCommands.ping
                    $config.RoleCapabilities.VisibleExternalCommands.ipconfig
                )
            }
            appSupportSubDomain = @{
                scriptsToProcess        = @(
                    $config.RoleCapabilities.scriptsToProcess.authorizedAccessDisclaimer
                    $config.RoleCapabilities.scriptsToProcess.welcomeMessage
                )
                visibleAliases          = @(
                    $config.RoleCapabilities.VisibleAliases.ls
                    $config.RoleCapabilities.VisibleAliases.dir
                )
                visibleCmdlets          = @(
                    @{
                        getService = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.getService.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.getService.parameters.name.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.getService.parameters.name.validatePattern.appSupport
                            },
                            @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.getService.parameters.displayName.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.getService.parameters.displayName.validatePattern.appSupport
                            }
                        }
                    }
                    @{
                        restartService = @{
                            Name       = $config.RoleCapabilities.visibleCmdlets.restartService.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.name.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.name.validatePattern.appSupport
                            },
                            @{
                                Name            = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.displayName.parameterName
                                ValidatePattern = $config.RoleCapabilities.visibleCmdlets.restartService.parameters.displayName.validatePattern.appSupport
                            }
                        }
                    }
                ) 
                visibleFunctions        = @(
                    $config.RoleCapabilities.VisibleFunctions.enableTabCompletion
                    $config.RoleCapabilities.VisibleFunctions.getLogs
                    $config.RoleCapabilities.VisibleFunctions.restartCustomServices
                    $config.RoleCapabilities.VisibleFunctions.getProcessInformation
                )
                visibleExternalCommands = @(
                    $config.RoleCapabilities.VisibleExternalCommands.ping
                    $config.RoleCapabilities.VisibleExternalCommands.ipconfig
                )
            }
        }
        return $buildRoleCapabilityConfiguration
    }
    
    function buildSessionConfiguration {
        $buildSessionConfiguration = @{
            support = @{
                transcriptDirectory = $config.SessionConfiguration.transcriptDirectory.support
            }
        }
        return $buildSessionConfiguration
    }
    
    function buildVisibleCmdlets {
        $cmdlets = for ($i = 0; $i -lt $roleCapabilityConfiguration.$ConfigurationName.visibleCmdlets.Count; $i++) {
            $roleCapabilityConfiguration.$ConfigurationName.visibleCmdlets[$i][$roleCapabilityConfiguration.$ConfigurationName.visibleCmdlets[$i].Keys]
        }

        
        $cmdletGroupArray = for ($i = 0; $i -lt $roleCapabilityConfiguration.defaultConfig.visibleCmdletGroups.Count; $i++) {
            $roleCapabilityConfiguration.defaultConfig.visibleCmdletGroups[$i][$roleCapabilityConfiguration.defaultConfig.visibleCmdletGroups[$i].Keys]
        }
        $cmdletGroups = foreach ($cmdlet in $cmdletGroupArray) { $cmdlet[$cmdlet.GetEnumerator().Name] }
        
    
        $visibleCmdlets += $cmdlets
        
        try {
            foreach ($cmdlet in $cmdletGroups) {
                $visibleCmdlets += $cmdlet
            }
        }
        catch {
            continue
        }
        
        return $visibleCmdlets
    }

    $config = getJSONConfig
    $roleCapabilityConfiguration = buildRoleCapabilityConfiguration
    
    $visibleCmdlets = buildVisibleCmdlets
    
    $roleCapabilityConfiguration.$ConfigurationName.visibleCmdlets = $visibleCmdlets

    return $roleCapabilityConfiguration[$ConfigurationName]
}