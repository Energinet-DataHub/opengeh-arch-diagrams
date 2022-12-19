workspace "DH3 Architectual Runway"{

    model {
        actor = softwareSystem "Actor" "For example a grid company or electricity supplier" "phase1,phase2,phase3,Actor,epic1"
        extUser = person "External user" "Person that works with the DataHub 3 system" "phase1,phase2,phase3"
        dh2 = softwareSystem "DH2" "DataHub 2 (developed and maintained by CGI)" "phase1,phase2,temp,epic1"
        
        dh = enterprise "Datahub (part of Energinet)" {
            dh3User = person "Energinet user" "Person that works within Energinet (for example a FAS-user)" "phase1,phase2,phase3,epic1"
            dh3 = softwareSystem "DH3" "DataHub 3.0" "phase1,phase2,phase3,epic1" {
                edi = container "EDI" "Message handling (EDI-parser)" "" "phase1,phase2,phase3,epic1"
                ws = container "Wholesale" "Calculates and performs aggregations" "" "Microsoft Azure - Azure Databricks,phase1,phase2,phase3,epic1"
                mp = container "Market Participants" "Contains organisation and actor information" "" "phase1,phase2,phase3,epic1"
                bff = container "App (BFF)" "Backend for frontend - combines data for presentation on Frontend" "" "phase1,phase2,phase3,epic1"
                front = container "Frontend" "GUI for users" "Angular" "phase1,phase2,phase3,epic1" 

                #Migration
                lz = container "Landing Zone" "All data exports from DataHub2 are received here" "Azure Blob storage" "Microsoft Azure - Storage Container,phase1,phase2,temp,epic1"
                migration = container "Migration" "Transform and prepares data for ingestion in wholesale" "" "Microsoft Azure - Azure Databricks,phase1,phase2,temp,epic1"

                #Phase 2
                ts = container "Timeseries" "Transform and prepares timeseries data for ingestion in other 'systems'" "" "Microsoft Azure - Azure Databricks,phase2,phase3" 

                #Phase 3
                masterData = container "Master Data" "Transform and prepares charges, meteringpoint, ... data for ingestion in other 'systems'" "" "phase3"
            }  
        }
        
        actor -> edi "Get calculated report (RSM014)" "using HTTP (CIM)"
        actor -> dh2 "Current integration to DataHub 2.0"

        dh2 -> lz "Transferes data for calculations" "using AzCopy to Azure Blob storage"
        lz -> migration "Sends data from landing zone" ""
        migration -> ws "Sends migrated data" "using Delta tables"

        edi -> ws "Data exchange with actors" ""
        edi -> mp "Handle user access"

        bff -> ws "Start batch, see results, basis data"
        bff -> edi "Supports frontend with lookup for EDI messages"
        bff -> mp "See gridareas, actors and user-administration" "using HTTP"
        front -> bff "Front - BFF integration" "using HTTP"

        dh3User -> front "Start batch, see results, basis data, gridareas, actors, user-admin" "using browser"
        extUser -> front "See results, see basis data, see RSM messages" "using browser"

        #Phase 2
        edi -> ts "Transferes timeseries data" "using message broker" "phase2"
        ts -> ws "Transferes timeseries data" "using message broker/Delta Tables" "phase2"

        #Phase 3
        edi -> masterData "Transferes master data" "using message broker" "phase3"
        masterData -> ws "Transferes master data" "using message broker/Delta Tables" "phase3"
        
    }   

    views {
        systemContext dh3 "SystemContext" {
            title "DataHub 3.0 - Architectural Runway"
            description "System Context View"
            include *
            autoLayout
        }
        container dh3 "Phase1-all" {
            title "DataHub 3.0 - Architectural Runway - Phase 1"
            description "Container View"
            include "element.tag==phase1"
            autoLayout 
        }
        container dh3 "Phase1-epic1" {
            title "DataHub 3.0 - Architectural Runway - Phase 1 - Epic 1"
            description "Container View"
            include "element.tag==epic1"
            autoLayout lr
        }
        container dh3 "Phase1-core" {
            title "DataHub 3.0 - Architectural Runway - Phase 1 - core"
            description "Container View"
            include "element.tag==phase1"
            exclude extUser dh3User bff front 
            autoLayout lr
        }
        container dh3 "Phase2-core" {
            title "DataHub 3.0 - Architectural Runway - Phase 2 - core"
            description "Container View"
            include "element.tag==phase2"
            exclude extUser dh3User bff front
            autoLayout lr
        }
        container dh3 "Phase3-core" {
            title "DataHub 3.0 - Architectural Runway - Phase 3 - core"
            description "Container View"
            include "element.tag==phase3"
            exclude extUser dh3User bff front 
            autoLayout lr
        }
        container dh3 "Phase3-all" {
            title "DataHub 3.0 - Architectural Runway - Phase 3"
            description "Container View"
            include "element.tag==phase3"
            autoLayout lr
        }
        
        themes https://static.structurizr.com/themes/microsoft-azure-2021.01.26/theme.json
        
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
            element "Actor" {
                shape RoundedBox
                background #08427b
                color #ffffff
            }
            element "temp" {
                background #08737B
                color #ffffff
            }
        }
    }
    
}
