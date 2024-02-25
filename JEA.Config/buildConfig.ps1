function buildJEAConfiguration {
    param(
        [Parameter(Mandatory)]
        [string]
        $ConfigurationName
    )

    function getJSONConfig {
        # Returns the global JEA config as a json object
        $config = Get-Content 'C:\JEA\JEA.Config\config.json'
        $json = $config | ConvertFrom-Json
        return $json
    }

    function buildRoleCapabilityConfiguration {
        # Builds the PS Role Capability configuration
        $buildRoleCapabilityConfiguration = @{
            defaultConfig       = @{
                scriptsToProcess        = @(
                    $config.RoleCapabilities.scriptsToProcess.authorizedAccessDisclaimer
                    $config.RoleCapabilities.scriptsToProcess.welcomeMessage
                    $config.RoleCapabilities.scriptsToProcess.setLocation
                )
                visibleAliases          = @(
                    $config.RoleCapabilities.VisibleAliases.ls
                    $config.RoleCapabilities.VisibleAliases.dir
                    $config.RoleCapabilities.VisibleAliases.pwd
                    $config.RoleCapabilities.VisibleAliases.cd
                )
                visibleCmdlets          = @(
                    @{
                        getChildItem              = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.getChildItem.name
                            Parameters = @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.getChildItem.parameters.path.parameterName
                            },
                            @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.getChildItem.parameters.recurse.parameterName
                            },
                            @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.getChildItem.parameters.hidden.parameterName
                            },
                            @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.getChildItem.parameters.filter.parameterName
                            }
                        }
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
                        testComputerSecureChannel = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.testComputerSecureChannel.Name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.testComputerSecureChannel.parameters.server.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.testComputerSecureChannel.parameters.server.validatePattern.domainControllers
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
            appSupportDomain    = @{
                modulesToImport         = @(
                    $config.RoleCapabilities.modulesToImport.iisAdministration
                    $config.RoleCapabilities.modulesToImport.webAdministration
                )
                visibleCmdlets          = @(
                    @{
                        getIisAppPool = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.getIisAppPool.name
                            Parameters = @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.getIisAppPool.parameters.name.parameterName
                            }
                        }
                    }
                    @{
                        restartWebAppPool = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.restartWebAppPool.name
                            Parameters = @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.restartWebAppPool.parameters.name.parameterName
                            }
                        }
                    }
                )
                visibleExternalCommands = @(
                    $config.RoleCapabilities.VisibleExternalCommands.iisReset
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
                    @{
                        restartService = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.restartService.name
                            Parameters = @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.restartService.parameters.name.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.restartService.parameters.name.validatePattern.appSupport
                            },
                            @{
                                Name            = $config.RoleCapabilities.VisibleCmdlets.restartService.parameters.displayName.parameterName
                                ValidatePattern = $config.RoleCapabilities.VisibleCmdlets.restartService.parameters.displayName.validatePattern.appSupport
                            }
                        }
                    }
                )
            }
            appSupportAPI       = @{
                modulesToImport         = @(
                    $config.RoleCapabilities.modulesToImport.iisAdministration
                    $config.RoleCapabilities.modulesToImport.webAdministration
                )
                visibleCmdlets          = @(
                    @{
                        getIisAppPool = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.getIisAppPool.name
                            Parameters = @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.getIisAppPool.parameters.name.parameterName
                            }
                        }
                    }
                    @{
                        restartWebAppPool = @{
                            Name       = $config.RoleCapabilities.VisibleCmdlets.restartWebAppPool.name
                            Parameters = @{
                                Name = $config.RoleCapabilities.VisibleCmdlets.restartWebAppPool.parameters.name.parameterName
                            }
                        }
                    }
                )
                visibleExternalCommands = @(
                    $config.RoleCapabilities.VisibleExternalCommands.iisReset
                )
            }
        }
        return $buildRoleCapabilityConfiguration
    }
    
    function buildSessionConfiguration {
        # Builds the PS Session configuration
        $buildSessionConfiguration = @{
            appSupportDomain    = @{
                SessionType         = $config.SessionConfiguration.SessionType.restrictedRemoteServer
                TranscriptDirectory = $config.SessionConfiguration.TranscriptDirectory.default
                RoleDefinitions     = @{
                    $config.SessionConfiguration.GroupRoleDefinitions.appSupport = @{
                        RoleCapabilityFiles = $config.SessionConfiguration.RoleCapabilityFiles.appSupportDomain
                    }
                }
            }
            appSupportSubDomain = @{
                SessionType         = $config.SessionConfiguration.SessionType.restrictedRemoteServer
                TranscriptDirectory = $config.SessionConfiguration.TranscriptDirectory.default
                RoleDefinitions     = @{
                    $config.SessionConfiguration.GroupRoleDefinitions.appSupport = @{
                        RoleCapabilityFiles = $config.SessionConfiguration.RoleCapabilityFiles.appSupportSubDomain
                    }
                }
            }
        }
        return $buildSessionConfiguration
    }
    
    function buildVisibleCmdlets {
        [array]$VisibleCmdlets = @()
        # Builds the default visible cmdlets
        $cmdlets = for ($i = 0; $i -lt $roleCapabilityConfiguration.defaultConfig.VisibleCmdlets.Count; $i++) {
            $roleCapabilityConfiguration.defaultConfig.VisibleCmdlets
        }
        $VisibleCmdlets += $cmdlets
        # Builds the profile specific visible cmdlets
        for ($i = 0; $i -lt $roleCapabilityConfiguration.$ConfigurationName.VisibleCmdlets.Count; $i++) {
            $VisibleCmdlets += $roleCapabilityConfiguration.$ConfigurationName.VisibleCmdlets[$i]
        }
        return $VisibleCmdlets.Values
    }

    function applyDefaultConfig {
        # Rolls all of the default config settings into the specified profile
        for ($i = 0; $i -lt $roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name.Count; $i++) {
            if ($roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name[$i] -eq 'VisibleCmdlets') {
                continue
            }

            if ($roleCapabilityConfiguration.$ConfigurationName.GetEnumerator().Name -notcontains $roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name[$i]) {
                $roleCapabilityConfiguration.$ConfigurationName.Add($roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name[$i], $roleCapabilityConfiguration.defaultConfig[$roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name[$i]])
            }
            else {
                $roleCapabilityConfiguration.$ConfigurationName.($roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name[$i]) += $roleCapabilityConfiguration.defaultConfig[$roleCapabilityConfiguration.defaultConfig.GetEnumerator().Name[$i]]
            }
        }
    }

    # Parses the JSON to an object
    $config = getJSONConfig
    # Builds the role capability configuration
    $roleCapabilityConfiguration = buildRoleCapabilityConfiguration
    # Rolls all of the default config settings into the specified profile
    applyDefaultConfig
    # Correctly format the visible cmdlets in the way that JEA expects them
    $VisibleCmdlets = buildVisibleCmdlets
    $roleCapabilityConfiguration.$ConfigurationName.VisibleCmdlets = $VisibleCmdlets
    # Builds the session configuration
    $sessionConfiguration = buildSessionConfiguration
    # Config object to be returned
    $jeaConfig = @{
        PSRC = $roleCapabilityConfiguration
        PSSC = $sessionConfiguration
    }
    return $jeaConfig
}