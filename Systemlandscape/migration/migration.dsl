workspace extends ../architectualRunway.dsl {
    model {
        !ref migration {
            bronzeNotebook = component "Bronze Layer Notebook" "Extract migrated JSON files and load into bronze table" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
            silverNotebook = component "Silver Layer Notebook" "Read bronze table data and transform to queryable dataframe" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
            goldNotebook = component "Gold Layer Notebook" "Transform silver table data to conform to wholesale schemas" "Databricks Notebook" "Microsoft Azure - Azure Databricks"
            bronzeBlob = component "Bronze Layer Storage" "" "Blob container"
            silverBlob = component "Silver Layer Storage" "" "Blob container"
            goldBlob = component "Gold Layer Storage" "" "Blob container"
        }
        #Migration
        lz -> bronzeNotebook "Ingests"
        bronzeNotebook -> bronzeBlob "Store"
        silverNotebook -> bronzeBlob "Read"
        silverNotebook -> silverBlob "Store"
        goldNotebook -> silverBlob "Read"
        goldNotebook -> goldBlob "Store"
        goldNotebook -> ws "Deliver"
    }
    views {
        component migration "Phase1-Migration" {
            title "DataHub 3.0 - Migration"
            description "Component View"
            include *
            autoLayout lr
        }
    }
}
