workspace "DataHub 3.0" {

    model {
        group "External organization (actor) e.g. Energy Supplier or Grid Access Provider" {
            extUser = person "User" "A person who interacts with DataHub" ""
            extSoftSystem = softwareSystem "External software system" "External business transaction system. System-to-system communication (B2B)." "Actor"
        }
        dh2 = softwareSystem "DataHub 2.0" "Developed and maintained by CGI."
        eSett = softwareSystem "eSett" "Imbalance"
        
        dhOrganization = enterprise "DataHub Organization" {
            dhSysAdmin = person "DataHub System Admin" "Person that works within Energinet DataHub" ""
            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." {
                migration = group "Migration" {
                    migrationFlow = container "Data Migration " "Extract migrated JSON files. Load and transform data using Notebooks" "Azure Databricks" "Microsoft Azure - Azure Databricks"
                    migrationStorage = container "Data Lake (Migration)" "Store data using medalion architecture (bronze/silver/gold)" "Azure Data Lake" "Microsoft Azure - Data Lake Store Gen1"
                    migrationTimeSeriesApi = container "Time Series API" "" "Azure Web App" "Microsoft Azure - App Services"
                }
                wholesale = group "Wholesale" {
                    wholesaleLogic = container "Wholesale Logic" "Databricks + Azure functions" "Databricks" "Microsoft Azure - Azure Databricks"
                    wholesaleStorage = container "MigrationData - Gold (Delta Lake) " "Azure Data Lake" "" "Microsoft Azure - Data Lake Store Gen1"
                    wholesaleResultStorage = container "Calc. result (Landevej) (Delta Lake)" "Azure Data Lake" "Azure Data Lake" "Microsoft Azure - Data Lake Store Gen1"
                    wholesaleDb = container "Wholesale database" "" "MS SQL Server" "Data Storage, Microsoft Azure - SQL Database"
                }
                markpart = group "Market Participant" {
                    markpartC = container "Market Participant" "Multi-tenant API for managing actors, users and permissions + functions." "Asp.Net Core Web API"
                    markpartDb = container "Market Participant Database" "Stores data regarding actors, users and permissions." "SQL Database Schema" "Data Storage,Microsoft Azure - SQL Database"

                    markpartC -> markpartDb "Reads and writes actor/user data." "Entity Framework Core"
                }
                
                edi = group "EDI" {
                    ediC = container "EDI Peek/deque" "Handles peek/deque requests from actors" "C#, Azure function" "Microsoft Azure - Function Apps"
                    ediDb = container "EDI database" "Stores information related to business transactions and outgoing messages""" "SQL server database,Microsoft Azure - SQL Database,Data Storage"                    
                }
                eventQueue = container "ServiceBus Queue" "" "Azure service bus" "Microsoft Azure - Service Bus"
                
                dh3WebApp = group "Web App" {
                    frontend = container "UI" "Provides DH3 functionality to users via their web browser." "Angular"
                    bff = container "Backend for frontend" "Combines data for presentation on DataHub 3 UI" "Asp.Net Core Web API"
                    frontend -> bff "Uses" "JSON/HTTPS"
                }
                group "eSett integration" {
                    eSettIntegration = container "eSett integration" "Send calculation results - adapter" ""
                    eSettBiztalk = container "eSett Biztalk" "Owned by 'integrationsteamet'" "" "Microsoft Azure - Biz Talk"
                }
                
                
                
            }
            group "Eloverblik" {
                elOverblik = softwareSystem "Eloverblik" ""
            }
            powerBI = softwareSystem "Analysis tool (eg. PowerBI)" "Data and validation"
            
            
            
            
        }

        # Relationships to/from
        bff -> markpartC "Uses" "JSON/HTTPS"
        dh2 -> migrationFlow "ingest"      
        extSoftSystem -> ediC "Get calculations from" "https"
        ediC -> ediDb "Stores state of edi-trx"
        ediC -> eventQueue "Sending/receiving events"
        wholesaleLogic -> eventQueue "Sending/receiving events"
        wholesaleLogic -> wholesaleStorage "retrieves timeseries from"
        wholesaleLogic -> wholesaleResultStorage "stores results to"
        wholesaleLogic -> wholesaleDb "stores state of wholesale-trx"

        migrationFlow -> wholesaleStorage "Deliver"
        migrationFlow -> migrationStorage "Store"
        elOverblik -> migrationTimeSeriesApi "Fetch"
        migrationTimeSeriesApi -> migrationStorage "Read"


        extUser -> frontend "using"
        dhSysAdmin -> frontend "using"
        bff -> wholesaleLogic "uses" "JSON/HTTPS"
        powerBI -> wholesaleResultStorage "read results"

        eventQueue ->   eSettIntegration "sends calc. results"
        eSettIntegration -> eSettBiztalk "sends calc. results (nbs)"
        eSettBiztalk -> eSett "sends calc. results (nbs)"
        
        dh2 -> dh3 "Transferes data" "using AzCopy"
    }

    views {
        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "Level 1"
            include *
            autoLayout
        }
        container dh3 "ContainerDraft1" {
            title "DRAFT - FUTURE [Container] DataHub 3.0"
            description "Level 2"
            include *
        }

        dynamic dh3 "anmodninger" {
            title "DRAFT - Anmodninger"
            description "Level 2"
            extSoftSystem -> ediC "'anmod' - RSM016"
            ediC -> eventQueue "anmodning"
            eventQueue -> wholesaleLogic "anmodning"
            wholesaleLogic -> wholesaleResultStorage "fetch calc. result"
            wholesaleResultStorage -> wholesaleLogic 
            wholesaleLogic -> eventQueue "calcResult"
            eventQueue -> ediC "calcResult"
            ediC -> extSoftSystem "anmod respons - RSM014?"
            autoLayout
        }

        dynamic dh3 "platform" {
            title "Phase 1"
            description "Level 2"
            dh2 -> migrationFlow "Ingest"      
            migrationFlow -> wholesaleStorage "Deliver"
            extUser -> frontend "Using"
            frontend -> bff "Uses"
            bff -> markpartC "Uses"
            bff -> wholesaleLogic "Uses"
            wholesaleStorage -> wholesaleLogic "Timeseries"
            wholesaleLogic -> eventQueue "Sending calculations result"
            eventQueue -> ediC "Sending calculations result" 
            ediC -> extSoftSystem "Sending calculations results"
        
            autoLayout lr
        
        
        }
        themes https://raw.githubusercontent.com/Energinet-DataHub/opengeh-arch-diagrams/main/source/datahub3-model/theme.json

        styles {
            element "Data Storage" {
                shape Cylinder
            }
            element "Group" {
                color #444444
            }
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
        }
    }
}
