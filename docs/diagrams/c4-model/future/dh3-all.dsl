# Extends the core DataHub 3 model to build a deployment diagram.
# showing how domain services (containers) are deployed onto infrastructure (deployment nodes).

workspace extends https://raw.githubusercontent.com/Energinet-DataHub/opengeh-arch-diagrams/main/docs/diagrams/c4-model/dh-base-model.dsl {

    model {
        #
        # DataHub 3.0 (extends)
        #
        !ref dh3 {

            # IMPORTANT:
            # The order by which models are included is important for how the domain-to-domain relationships are specified.
            # A domain-to-domain relationship should be specified in the "client" of a "client->server" dependency, and
            # hence domains that doesn't depend on others, should be listed first.

            # Include Market Participant model
            !include https://raw.githubusercontent.com/Energinet-DataHub/geh-market-participant/main/docs/diagrams/c4-model/model.dsl

            # Include EDI model
            !include https://raw.githubusercontent.com/Energinet-DataHub/opengeh-edi/main/docs/diagrams/c4-model/model.dsl

            # Include Wholesale model
            !include https://raw.githubusercontent.com/Energinet-DataHub/opengeh-wholesale/main/docs/diagrams/c4-model/model.dsl

            # Include Frontend model
            !include https://raw.githubusercontent.com/Energinet-DataHub/greenforce-frontend/main/docs/diagrams/c4-model/model.dsl

            # Include Migration model - requires a token because its located in a private repository
            !include https://raw.githubusercontent.com/Energinet-DataHub/opengeh-migration/main/docs/diagrams/c4-model/model.dsl?token=GHSAT0AAAAAACDNGUTKKRJDJ65AX26JPQDUZFGWZGQ

            eSettDomain = group "eSett Exchange" {
                esettExchange = container "eSett Exchange" {
                    description "Converts calculation messages, which contain aggregated energy time series, into a format eSett understands (nbs)."
                    technology ""
                    tags "Microsoft Azure - Function Apps" "epic4"
                    
                    # Relationships
                    this -> eSett "Sends calculations" "ECP - nbs/https"
                    dh3.sharedServiceBus -> this "Consumes events" "messages/amqp" "epic4"
                    wholesaleApi -> this "Sends calculations" {
                        tags "Simple View" "epic4"
                    }
                    markpartApi -> this "Sends <actor/gridarea details?> data" {
                        tags "Simple View" "epic4"
                    }
                    markpartApi -> dh3.sharedServiceBus "Sends <actor/gridarea details?>" "integration event/amqp" "epic4"
                    wholesaleApi -> dh3.sharedServiceBus "" "" "epic4"
                    ediApi -> dh3.sharedServiceBus "" "" "epic4"
                }
                dh2Bridge = container "DH2 Bridge" {
                    description "Get calculations from DH2."
                    technology "<add technology>"
                    tags "epic4"
                    
                    # Relationships
                    this -> dh2 "Pulls calculations" "peek+dequeue/https" "epic4"
                    this -> dh3.sharedServiceBus "Sends calculations" "point to point/amqp" "epic4"
                    this -> esettExchange "Sends calculations" {
                        tags "Simple View" "epic4"
                    }
                }
            }
        }
        biDomain = group "Data and Analytics" {
            bi = softwareSystem "Reports and Analytics" {
                description "BI reports"
                
                tags "epic4" "Out of focus"
                this -> wholesaleDataLake "Reads data" "Delta sharing/unity catalog" "epic4"
            }
        }
    }

    views {
        systemlandscape "SystemLandscape" {
            title "[System Landscape] DataHub (Simplified) [TO-BE]"
            description "'To-be' view of the DataHub company"
            include *
            exclude "relationship.tag==OAuth"
            exclude "element.tag==Out of focus"
        }

        systemlandscape "SystemLandscapeDetailed" {
            title "[System Landscape] DataHub (Detailed)"
            description "'To-be' view of the DataHub company and nearby software systems"
            include *
            exclude "relationship.tag==OAuth"
        }

        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "'To-be' view of the DH 3.0 software system and dependencies"
            include *
            exclude "relationship.tag==OAuth"
        }

        container dh3 "All_no_OAuth" {
            title "[Container] DataHub 3.0 (Detailed, no OAuth)"
            description "Detailed 'To-be' view of all domains, which includes 'Intermediate Technology' elements, but excludes 'OAuth' relationships"
            include *
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==OAuth"
            exclude "relationship.tag==Simple View"
        }

        container dh3 "All_simple" {
            title "[Container] DataHub 3.0 (Simplified, no OAuth)"
            description "Simplified 'as-is' view of all domains, which excludes both 'Intermediate Technology' elements and 'OAuth' relationships"
            include *
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==OAuth"
            exclude "element.tag==Intermediate Technology"
        }

        container dh3 "Frontend" {
            title "[Container] DataHub 3.0 - Frontend (Detailed with OAuth)"
            include ->frontendDomain->
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==Simple View"
        }

        container dh3 "Migration" {
            title "[Container] DataHub 3.0 - Migration (Detailed with OAuth)"
            include ->migrationDomain->
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==Simple View"
        }

        container dh3 "Wholesale" {
            title "[Container] DataHub 3.0 - Wholesale (Detailed with OAuth)"
            include ->wholesaleDomain->
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==Simple View"
        }

        container dh3 "Market_Participant" {
            title "[Container] DataHub 3.0 - Market Participant (Detailed with OAuth)"
            include ->markpartDomain->
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==Simple View"
        }

        container dh3 "EDI" {
            title "[Container] DataHub 3.0 - EDI (Detailed with OAuth)"
            include ->ediDomain->
            exclude "relationship.tag==Deployment Diagram"
            exclude "relationship.tag==Simple View"
        }
        container dh3 "future-eSettExchange" {
            title "[Future] [Container] DataHub 3.0 - eSett Exchange"
            include ->eSettDomain->
            exclude "relationship.tag==OAuth"
            exclude "element.tag==Intermediate Technology"
        }
        container dh3 "future-eSettExchangeDetailed" {
            title "[Future] [Container] DataHub 3.0 - eSett Exchange"
            include ->eSettDomain->
            exclude "relationship.tag==Simple View"
        }
    
    }
}
