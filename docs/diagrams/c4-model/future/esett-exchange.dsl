# Extends the core DataHub 3 model to build a deployment diagram
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

            # Future models
            eSettDomain = group "eSett Exchange" {
                esettExchange = container "eSett Exchange" {
                    description "Converts calculation messages, which contain aggregated energy time series, into a format eSett understands (nbs)."
                    technology ""
                    tags "Microsoft Azure - Function Apps"
                    
                    # Relationships
                    this -> eSett "Sends calculations" "ECP - nbs/https"
                    dh3.sharedServiceBus -> this "Consumes events" "messages/amqp"
                    wholesaleApi -> this "Sends calculations" {
                        tags "Simple View"
                    }
                    markpartApi -> this "Sends <actor/gridarea details?> data" {
                        tags "Simple View"
                    }
                    markpartApi -> dh3.sharedServiceBus "Sends <actor/gridarea details?>" "integration event/amqp"
                }
                dh2Bridge = container "DH2 Bridge" {
                    description "Get calculations from DH2."
                    technology "<add technology>"
                    
                    # Relationships
                    this -> dh2 "Pulls calculations" "peek+dequeue/https"
                    this -> dh3.sharedServiceBus "Sends calculations" "point to point/amqp"
                    this -> esettExchange "Sends calculations" {
                        tags "Simple View"
                    }
                }
            }
        }
    }

    views {
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