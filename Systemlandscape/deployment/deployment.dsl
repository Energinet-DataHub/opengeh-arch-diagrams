# PoC on building a model where
#  - "deploymentNodes" are used for Azure resources
#  - "containers" are Azure resource agnostics
#
# Since "architectualRunway.dsl" doesn't use this separation we cannot use "extend"
# and instead have a copy of necessary model pieces.
workspace "DataHub 3.0" {

    model {
        dh3User = person "DH3 User" "Person that uses the DataHub 3 Web App"

        dh2 = softwareSystem "DataHub 2" "Developed and maintained by CGI"

        dhOrganization = enterprise "DataHub Organization" {
            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." {
                dh3WebApp = group "Web App" {
                    frontend = container "UI" "Provides DH3 functionality to users via their web browser." "Angular"
                    bff = container "Backend for frontend" "Combines data for presentation on DataHub 3 UI" "Asp.Net Core Web API"

                    frontend -> bff "Uses" "JSON/HTTPS"
                }

                ## wholesale = container "Wholesale" "Calculates and performs aggregations."
                wholesale = group "Wholesale" {
                    wholesaleApi = container "Wholesale API" "" "Asp.Net Core Web API"
                    wholesaleDb = container "Database" "Stores batch processing state" "SQL Database Schema" "Data Storage"

                    wholesaleProcessManager = container "Process Manager" "Handles batch processing" "Azure Function App"

                    wholesaleStorage = container "Storage" "Stores batch results" "JSON and CSV files" "Data Storage"
                    wholesaleCalculator = container "Calculator" "" "Python wheel"

                    wholesaleApi -> wholesaleDb "Reads from and writes to"
                    wholesaleApi -> wholesaleStorage "Reads from"

                    wholesaleProcessManager -> wholesaleDb "Reads from"
                    wholesaleProcessManager -> wholesaleCalculator "Triggers"
                    wholesaleCalculator -> wholesaleStorage "Write to"
                }
            }
        }

        # Relationships between people and software systems

        # Relationships to/from containers
        dh3User -> frontend "View and start jobs using"
        bff -> wholesaleApi "Uses" "JSON/HTTPS"

        # Relationships to/from components
    }

    views {
        systemlandscape "SystemLandscape" {
            include *
            autoLayout
        }

        systemcontext dh3 "SystemContext" {
            include *
            autoLayout
        }

        container dh3 {
            include *
            autolayout
        }

        container dh3 "WebApp" {
            include dh3WebApp wholesaleApi
            autolayout
        }

        container dh3 "Wholesale" {
            include wholesale
            autolayout
        }

        themes default https://static.structurizr.com/themes/microsoft-azure-2021.01.26/theme.json

        styles {
            element "Data Storage" {
                shape Cylinder
            }

            element "Group" {
                color #444444
            }
        }
    }
}