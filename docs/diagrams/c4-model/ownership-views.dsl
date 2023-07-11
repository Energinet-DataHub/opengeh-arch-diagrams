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
            !include https://raw.githubusercontent.com/Energinet-DataHub/opengeh-edi/krmoos/ownership-in-model/docs/diagrams/c4-model/model.dsl
            #https://raw.githubusercontent.com/Energinet-DataHub/opengeh-edi/main/docs/diagrams/c4-model/model.dsl

            # Include Wholesale model
            !include https://raw.githubusercontent.com/Energinet-DataHub/opengeh-wholesale/main/docs/diagrams/c4-model/model.dsl

            # Include Frontend model
            !include https://raw.githubusercontent.com/Energinet-DataHub/greenforce-frontend/main/docs/diagrams/c4-model/model.dsl

            # Include Migration model - requires a token because its located in a private repository
            !include https://raw.githubusercontent.com/Energinet-DataHub/opengeh-migration/main/docs/diagrams/c4-model/model.dsl?token=GHSAT0AAAAAACDNGUTL2FNXHADZMBT3RYVGZFNE32A

        }
    }

    views {
        container dh3 "Volt" {
            title "Owned by Volt"
            description ""
            include "element.tag==Volt"
            exclude "* -> *"
        }
        container dh3 "Mandalorian" {
            title "Owned by Mandalorian"
            description ""
            include "element.tag==Mandalorian"
            exclude "* -> *"
        }
        container dh3 "Phoenix" {
            title "Owned by Phoenix"
            description ""
            include "element.tag==Phoenix"
            exclude "* -> *"
        }
        container dh3 "Titans" {
            title "Owned by Titans"
            description ""
            include "element.tag==Titans"
            exclude "* -> *"
        }
        container dh3 "Outlaws" {
            title "Owned by Outlaws"
            description ""
            include "element.tag==Outlaws"
            exclude "* -> *"
        }
        container dh3 "UIUXGuild" {
            title "Owned by UI/UX Guild"
            description ""
            include "element.tag==UI/UX Guild"
            exclude "* -> *"
        }
    }
}