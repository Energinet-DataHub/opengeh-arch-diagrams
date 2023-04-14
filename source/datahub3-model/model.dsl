workspace "DataHub 3.0" {

    model {
        group "External organization (actor) e.g. Energy Supplier or Grid Access Provider" {
            extUser = person "User" "A person who interacts with DataHub" ""
            extSoftSystem = softwareSystem "External software system" "External business transaction system. System-to-system communication (B2B)." "Actor"
        }

        group "CGI Organization" {
            dh2 = softwareSystem "DataHub 2.0" "Developed and maintained by CGI."
        }

        dhOrganization = group "DataHub Organization" {
            dhSysAdmin = person "DataHub System Admin" "Person that works within Energinet DataHub" ""

            elOverblik = softwareSystem "Eloverblik"

            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." {
                # Containers and groups described in separate repos
            }
        }

        # Relationships to/from
        dhSysAdmin -> dh3 "Uses" "browser"
        extUser -> dh3 "Uses" "browser"
        extSoftSystem -> dh3 "Get calculations from" "https"
        dh2 -> dh3 "Transferes data" "using AzCopy"
        elOverblik -> dh3 "Get timeseries from" "https"
    }

    views {
        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "Level 1"
            include *
            autoLayout
        }

        themes default https://static.structurizr.com/themes/microsoft-azure-2023.01.24/icons.json

        styles {
            element "Infrastructure Node" {
                background #dddddd
            }
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
            element "Web Browser" {
                shape WebBrowser
            }
            element "Actor" {
                shape RoundedBox
                background #08427b
                color #ffffff
            }
        }
    }
}
