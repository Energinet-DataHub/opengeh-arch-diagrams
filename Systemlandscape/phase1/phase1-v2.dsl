workspace {

    model {
        actor = softwareSystem "Actor" "For example a grid company or electricity supplier (da: Aktør)" "Actor"
        extUser = person "External user" "Person that works with the DataHub 3 system"
        dh2 = softwareSystem "DH2" "DataHub 2 (developed and maintained by CGI)" 
        
        dh = enterprise "Datahub (part of Energinet)" {
            dh3User = person "Energinet user" "Person that works within Energinet (for example a FAS-user)" 
            
        

            dh3 = softwareSystem "DH3" "DataHub 3.0" {
                
                edi = container "EDI" "Message handling (EDI-parser)"
                lz = container "Landing Zone" "All data exports from DataHub2 are received here" "Azure Blob storage" "Microsoft Azure - Storage Container"
                migration = container "Migration" "Transform and prepares data for ingestion in other 'systems' (timeseries)" "" "Microsoft Azure - Azure Databricks"
                ws = container "Wholesale" "Calculates and performs aggregations" "" "Microsoft Azure - Azure Databricks"
                mp = container "Market Participants" "Contains organisation and actor information"
                bff = container "App (BFF)" "Backend for frontend - combines data for presentation on Frontend"
                front = container "Frontend" "GUI for users" "Angular" "Frontend"
            }
        
        }
         
        
        
        actor -> edi "Get calculated report about non-profiled consumption (RSM014)" "using HTTP (CIM) or SOAP (eBix)"
        dh2 -> lz "Transferes data for calculations" "using AzCopy to Azure Blob storage"
        migration -> lz "Loads data from landing zone" "using ??"
        ws -> migration "Loads migrated data" "using Delta tables"
        edi -> ws "Data exchange with actors"
        mp -> ws "Provides organisation and actor data"
        bff -> ws "Supports frontend"
        bff -> edi "Supports frontend with lookup for EDI messages"
        bff -> mp "Manage market participants"
        front -> bff "Start processes, see results, see basis data, see RSM messages" "using HTTP"
        dh3User -> front "Start processes, see results, see basis data, see RSM messages" "using HTTP"
        extUser -> front "See results, see basis data, see RSM messages" "using HTTP"
        
    }

    views {
        systemContext dh3 "SystemContext" {
            include *
            autoLayout
        }
        container dh3 "ContainerDiagram" {
            include *
            autoLayout
        }
        themes https://static.structurizr.com/themes/microsoft-azure-2021.01.26/theme.json
        //default
        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Frontend" {
                shape WebBrowser
                background #08427b
                color #ffffff
            }
        }
    }
    
}
