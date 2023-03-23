workspace extends ../model.dsl {
    model {
        !ref dh3 {
            dropZoneGrp = group "Drop Zone" {
                dropZoneC = container "Drop Zone" 
            }
            migration = group "DataMigration" {
                databricks = container "Databricks Notebook" "Extract migrated JSON files and load into bronze/silver/gold table" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
                blob = container "Bronze/Silver/Gold Layer Storage" "" "Blob container" "Microsoft Azure - Storage Container"
            }
            wholesale = group "Wholesale" {
                wholesaleStorage = container "Gold Layer Storage (Wholesale)" "" "Blob container" "Microsoft Azure - Storage Container"
            }
            elOverblik = group "Eloverblik" {
                elOverblikStorage = container "Gold Layer Storage (Eloverblik)" "" "Blob container" "Microsoft Azure - Storage Container"
                timeSeriesAPI = container "Time Series API" ""
            }

            dh2 -> dropZoneC "Ingests"
            dropZoneC -> databricks "Ingest"
            databricks -> blob "Store"
            databricks -> wholesaleStorage "Deliver"
            databricks -> elOverblikStorage "Deliver"          
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
