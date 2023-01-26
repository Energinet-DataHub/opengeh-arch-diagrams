workspace extends ../model.dsl {
    model {
        !ref dh3 {
            dh3WebApp = group "Web App" {
                frontend = container "UI" "Provides DH3 functionality to users via their web browser." "Angular"
                bff = container "Backend for frontend" "Combines data for presentation on DataHub 3 UI" "Asp.Net Core Web API"

                frontend -> bff "Uses" "JSON/HTTPS"
            }

            wholesale = group "Wholesale" {
                wholesaleApi = container "Wholesale API" "" "Asp.Net Core Web API"
                wholesaleDb = container "Database" "Stores batch processing state" "SQL Database Schema" "Data Storage,Microsoft Azure - SQL Database" 

                wholesaleProcessManager = container "Process Manager" "Handles batch processing" "Azure Function App" "Microsoft Azure - Function Apps"

                wholesaleStorage = container "Storage" "Stores batch results" "JSON and CSV files" "Data Storage"
                wholesaleCalculator = container "Calculator" "" "Python wheel" "Microsoft Azure - Azure Databricks"

                wholesaleApi -> wholesaleDb "Reads from and writes to"
                wholesaleApi -> wholesaleStorage "Reads from"

                wholesaleProcessManager -> wholesaleDb "Reads from"
                wholesaleProcessManager -> wholesaleCalculator "Triggers"
                wholesaleCalculator -> wholesaleStorage "Write to"
            }
        }
        # Relationships to/from containers
        dh3User -> frontend "View and start jobs using"
        bff -> wholesaleApi "Uses" "JSON/HTTPS"
        
    }

    views {
        container dh3 {
            include *
            autolayout lr
        }

        container dh3 "WebApp" {
            title "DataHub 3.0 - Wholesale - WebApp"
            description "Level 2"
            include dh3WebApp wholesaleApi
            autolayout
        }

        container dh3 "Wholesale" {
            title "DataHub 3.0 - Wholesale"
            description "Level 2"
            include wholesale
            autolayout
        }
    }
}
