workspace "DataHub 3.0" {

    model {
        group "External organization (e.g. Energy Supplier or Grid Access Provider)" {
            actorGUI = person "Actor (GUI)" "For example a person who works at an electricity supplier or grid company" ""
            actorB2B = softwareSystem "Actor (B2B)" "For example a grid company or electricity supplier." "Actor"
        }
        dh2 = softwareSystem "DataHub 2" "Developed and maintained by CGI."

        dhOrganization = enterprise "DataHub Organization" {
            dhSysAdmin = person "DataHub System Admin" "Person that works within Energinet DataHub" ""
            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." {
                # Containers and groups described in separate repos
            }
        }

        # Relationships to/from
        dhSysAdmin -> dh3 "Uses" "browser"
        actorGUI -> dh3 "Uses" "browser"
        actorB2B -> dh3 "Get calculations from" "https"
        dh2 -> dh3 "Transferes data" "using AzCopy"
    }

    views {
        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "Level 1"
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
