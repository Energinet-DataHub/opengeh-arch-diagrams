workspace extends https://raw.githubusercontent.com/Energinet-DataHub/opengeh-arch-diagrams/main/source/datahub3-model/model.dsl {
    model {
        !ref dh3 {
            dropZoneGrp = group "Drop Zone" {
                dropZoneC = container "Drop Zone" 
            }
            migration = group "DataMigration" {
                bronzeNotebook = container "Bronze Layer Notebook" "Extract migrated JSON files and load into bronze table" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                silverNotebook = container "Silver Layer Notebook" "Read bronze table data and transform to queryable dataframe" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                goldNotebook = container "Gold Layer Notebook" "Transform silver table data to conform to wholesale schemas" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                gold2Notebook = container "Gold2 Layer Notebook" "Transform silver table data to conform to wholesale schemas" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                bronzeBlob = container "Bronze Layer Storage" "" "Blob container" "Microsoft Azure - Storage Container"
                silverBlob = container "Silver Layer Storage" "" "Blob container" "Microsoft Azure - Storage Container"
                goldBlob = container "Gold Layer Storage" "" "Blob container" "Microsoft Azure - Storage Container"
                
            }
            wholesale = group "Wholesale" {
                wholesaleStorage = container "Gold Layer Storage (Wholesale)" "" "Blob container" "Microsoft Azure - Storage Container"
            }
            elOverblik = group "Eloverblik" {
                elOverblikStorage = container "Gold Layer Storage (Eloverblik)" "" "Blob container" "Microsoft Azure - Storage Container"
                timeSeriesAPI = container "Time Series API" ""
            }

            dh2 -> dropZoneC "Ingests"
            dropZoneC -> bronzeNotebook "Ingest"
            bronzeNotebook -> bronzeBlob "Store"
            silverNotebook -> bronzeBlob "Read"
            silverNotebook -> silverBlob "Store"
            goldNotebook -> silverBlob "Read"
            goldNotebook -> goldBlob "Deliver"
            gold2Notebook -> goldBlob "Read"
            gold2Notebook -> wholesaleStorage "Deliver"
            gold2Notebook -> elOverblikStorage "Deliver"          
            timeSeriesAPI -> elOverblikStorage "Read"
        }       
    }

    views {
        container dh3 "Migration" {
            title "[Container] DataHub 3.0 - Migration"
            description "Level 2"
            include *
            autolayout lr
        }
    }
}
