workspace extends https://raw.githubusercontent.com/Energinet-DataHub/opengeh-arch-diagrams/main/source/datahub3-model/model.dsl {
    model {
        !ref dh3 {
            dropZoneGrp = group "Drop Zone" {
                dropZoneC = container "Drop Zone" ""
            }
            migration = group "Migration" {
                bronzeNotebook = container "Bronze Layer Notebook" "Extract migrated JSON files and load into bronze table" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                silverNotebook = container "Silver Layer Notebook" "Read bronze table data and transform to queryable dataframe" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                goldNotebook = container "Gold Layer Notebook" "Transform silver table data to conform to wholesale schemas" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                bronzeBlob = container "Bronze Layer Storage" "" "Blob container" "Microsoft Azure - Storage Container"
                silverBlob = container "Silver Layer Storage" "" "Blob container" "Microsoft Azure - Storage Container"
            }
            wholesale = group "Wholesale" {
                wholesaleStorage = container "Gold Layer Storage (Wholesale)" "" "Blob container" "Microsoft Azure - Storage Container"
            }
            elOverblik = group "Eloverblik" {
                elOverblikStorage = container "Gold Layer Storage (Eloverblik)" "" "Blob container" "Microsoft Azure - Storage Container"
            }

            dh2 -> dropZoneC "Ingests"
            dropZoneC -> bronzeNotebook "Ingest"

            bronzeNotebook -> bronzeBlob "Store"
            silverNotebook -> bronzeBlob "Read"
            silverNotebook -> silverBlob "Store"
            goldNotebook -> silverBlob "Read"
            goldNotebook -> wholesaleStorage "Deliver"
            goldNotebook -> elOverblikStorage "Deliver"
           
        }
        
    }

    views {
        container dh3 "Migration" {
            title "DataHub 3.0 - Migration"
            description "Level 2"
            include *
            autolayout lr
        }
    }
}
