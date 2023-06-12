workspace "DataHub 3.0" {

    # Enable hierarchical element identifier (relationship identifiers are unaffected).
    # See https://github.com/structurizr/dsl/blob/master/docs/language-reference.md#identifier-scope
    !identifiers hierarchical

    model {
        properties {
            # Enable nested groups.
            # See https://github.com/structurizr/dsl/tree/master/docs/cookbook/groups#nested-groups
            "structurizr.groupSeparator" "/"
        }

        group "Energy Supplier or Grid Access Provider" {
            extUser = person "User" {
                description "Person who interacts with DataHub"
                tags ""
            }

            actorB2BSystem = softwareSystem "Actor B2B System" {
                description "External business transaction system. System-to-system communication (B2B)."
                tags "Actor"
            }
        }
        group "Large power producers and consumers" {
            energyOriginUser = softwareSystem "Energy Origin User" {
                description "System at large power producers and consumers that interacts with Energy Origin."
                tags "Actor"
            }
        }
        group "Business or private person" {
            elOverblikUser = person "ElOverblik user" {
                description "Person who interacts with ElOverblik. Both private and business users."
                tags ""
            }
            elOverblikThirdPartyUser = softwareSystem "Eloverblik Third Party" {
                description "System that interacts with ElOverblik on behalf of a user."
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
            eds = softwareSystem "Energi Data Service" {
                description "<add description>"
                tags "Out of focus"
            }
            po = softwareSystem "Project Origin" {
                description "Public permissioned distributed ledger where everyone can validate the Guarantee of Origin for their electricity."
                tags "Out of focus"
            }

            group "DataHub Organization" {
                dhSystemAdmin = person "DataHub System Admin" {
                    description "Person who works within Energinet DataHub"
                    tags ""
                }

                elOverblik = softwareSystem "Eloverblik" {
                    description "The platform provides data on electricity consumption and production, allowing customers to have a comprehensive overview across grid areas and energy suppliers."
                }
                energyOrigin = softwareSystem "Energy Origin" {
                    description "Provides a way to issue and claim granular certificates"
                }
                dhESett = softwareSystem "DataHub eSett" {
                    description "<add description>"
                    tags ""
                }
                dh3 = softwareSystem "DataHub 3.0" {
                    description "Provides uniform communication and standardized processes for actors operating on the Danish electricity market."
                    tags ""

                    # Shared containers must be added in the base model
                    sharedServiceBus = container "Message broker" {
                        description "Message broker with message queues and publish-subscribe topics"
                        technology "Azure Service Bus"
                        tags "Intermediate Technology" "PaaS" "Microsoft Azure - Azure Service Bus"
                    }

                    # Extend with groups and containers in separate repos
                }
            }
        }

        # Relationships to/from
        # DH eSett
        dhESett -> btESett "<add description>" "https"
        btESett -> eSett "<add description>" "<add technology>"
        # DH2
        dhESett -> dh2 "Requests <data>" "peek+dequeue/https"
        # DH3
        elOverblik -> dh2 "Requests <data>" "https"
        dhSystemAdmin -> dh3 "Uses" "browser"
        extUser -> dh3 "Uses" "browser"
        actorB2BSystem -> dh3 "Requests calculations" "peek+dequeue/https"
        dh2 -> dh3 "Transfers <data>" "AzCopy/https"
        # ElOverblik
        elOverblikUser -> elOverblik "Requests <data>" "browser"
        elOverblik -> eds "Requests emission and residual mix data" "https"
        elOverblikThirdPartyUser -> elOverblik "Requests <data>" "https"
        # Energy Origin
        energyOrigin -> dh2 "Requests measurements" "https"
        energyOrigin -> po "Links to guarantees of origin" "https"
        energyOrigin -> eds "Requests emission and residual mix data" "https"
        energyOriginUser -> energyOrigin "Requests granular certificates" "https"
    }

    views {
        systemlandscape "SystemLandscape" {
            title "[System Landscape] DataHub (both versions)"
            description "'As-is' view of DataHub (both versions) and nearby software systems"
            include *
        }

        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "'As-is' view of the DH 3.0 software system and dependencies"
            include *
        }

        themes default https://static.structurizr.com/themes/microsoft-azure-2023.01.24/icons.json

        styles {
            # Use to mark an element that is somehow not compliant to the projects standards.
            element "Not Compliant" {
                background #ffbb55
                color #ffffff
            }
            # Use to mark an element that is acting as a mediator between other elements in focus.
            # E.g. an element that we would like to show for the overall picture, to be able to clearly communicate dependencies.
            # Typically this is an element that we configure, instead of develop.
            element "Intermediate Technology" {
                background #dddddd
                color #999999
            }
            # Use to mark an elements that is not an active part of the DataHub 3.0 project.
            # E.g. an software system to which the project has dependencies.
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
            # Style for the DataHub Organization group which should make it stand out compared to other groups.
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
