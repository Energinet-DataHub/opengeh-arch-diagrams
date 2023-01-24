workspace "DataHub 3.0" {

    model {
        extUser = person "External user" "Person that works with the DataHub 3 system" ""
        actor = softwareSystem "Actor" "For example a grid company or electricity supplier" "Actor"
        dh2 = softwareSystem "DataHub 2" "Developed and maintained by CGI"

        dhOrganization = enterprise "DataHub Organization" {
            dh3User = person "Energinet user" "Person that works within Energinet (for example a FAS-user)" ""
            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." {
                # Containers and groups described in separate repos
            }
        }
        
        # Relationships to/from 
        dh3User -> dh3 "View and start jobs" "using browser"
        extUser -> dh3 "View and start jobs" "using browser"
        actor -> dh3 "See results (RSM messages)" "HTTPS"
        dh2 -> dh3 "Transferes data for calculations" "using AzCopy"
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
        themes https://raw.githubusercontent.com/Energinet-DataHub/opengeh-arch-diagrams/main/source/datahub3-model/theme.json

        styles {
            element "Data Storage" {
                shape Cylinder
            }
            element "Group" {
                color #444444
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Frontend" {
                shape WebBrowser
                background #08427b
                color #ffffff
            }
            element "Actor" {
                shape RoundedBox
                background #08427b
                color #ffffff
            }
        }
    }
}