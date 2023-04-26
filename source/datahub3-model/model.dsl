workspace "DataHub 3.0" {

    model {
        properties {
            # Enable nested groups, see https://github.com/structurizr/dsl/tree/master/docs/cookbook/groups#nested-groups
            "structurizr.groupSeparator" "/"
        }

        group "External organization (actor) e.g. Energy Supplier or Grid Access Provider" {
            extUser = person "User" {
                description "Person who interacts with DataHub"
                tags ""
            }

            extSoftwareSystem = softwareSystem "External software system" {
                description "External business transaction system. System-to-system communication (B2B)."
                tags "Actor"
            }
        }

        group "CGI Organization" {
            dh2 = softwareSystem "DataHub 2.0" {
                description "<add description>"
                tags "Out of focus"
            }
        }

        group "eSett Organization" {
            eSett = softwareSystem "eSett" {
                description "<add description>"
                tags "Out of focus"
            }
        }

        group "Energinet Organization" {
            btESett = softwareSystem "BizTalk eSett" {
                description "<add description>"
                tags "Out of focus"
            }

            group "DataHub Organization" {
                dhSystemAdmin = person "DataHub System Admin" {
                    description "Person who works within Energinet DataHub"
                    tags ""
                }

                elOverblik = softwareSystem "Eloverblik" {
                    description "<add description>"
                    tags "Out of focus"
                }
                dhESett = softwareSystem "DataHub eSett" {
                    description "<add description>"
                    tags ""
                }
                dh3 = softwareSystem "DataHub 3.0" {
                    # Containers and groups described in separate repos

                    description "Provides uniform communication and standardized processes for actors operating on the Danish electricity market."
                    tags ""
                }
            }
        }

        # Relationships to/from
        # DH eSett
        dhESett -> btESett "<add description>" "https"
        btESett -> eSett "<add description>" "<add technology>"
        # DH2
        dhESett -> dh2 "Requests <data>" "peek+dequeue/https"
        extSoftwareSystem -> dh2 "Requests <data> except calculations" "peek+dequeue/https"
        # DH3
        elOverblik -> dh2 "Requests <data>" "https"
        elOverblik -> dh3 "Requests <timeseries>" "https"
        dhSystemAdmin -> dh3 "Uses" "browser"
        extUser -> dh3 "Uses" "browser"
        extSoftwareSystem -> dh3 "Requests calculations" "peek+dequeue/https"
        dh2 -> dh3 "Transfers <data>" "AzCopy/https"
    }

    views {
        systemlandscape "SystemLandscape" {
            title "[System Landscape] DataHub (both versions)"
            description "'As-is' view of DataHub (both versions) and nearby software systems"
            include *
            autoLayout
        }

        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "'As-is' view of the DH 3.0 software system and dependencies"
            include *
            autoLayout
        }

        themes default https://static.structurizr.com/themes/microsoft-azure-2023.01.24/icons.json

        styles {
            element "Out of focus" {
                background #999999
                color #ffffff
            }
            element "Infrastructure Node" {
                background #dddddd
            }
            element "Data Storage" {
                shape Cylinder
            }
            # Disabled to test if its still relevant
            #element "Group" {
            #    color #444444
            #}
            element "Group:Energinet Organization/DataHub Organization" {
                color #0000ff
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
