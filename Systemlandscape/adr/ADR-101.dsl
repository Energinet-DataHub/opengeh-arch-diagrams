
workspace extends ../architectualRunway.dsl {
    model {
        !ref dh3 {
            balanceresponsible = container "Balanceresponsible" "(Owned by Mandalorian) " "" ""
            dataRefining = container "Data refining" "Prepare data for wholesale (Former Migration) (Owned by Volt) " "" "Microsoft Azure - Azure Databricks,permanent"
            eloverblik = container "Eloverblik"
        }
    }
    views {
        dynamic dh3 "AS-IS" {
            title "ADR-101 - AS-IS"
            description "Dataflow - actors, gridareas and balanceresponsible"
            dh2 -> lz ""
            lz -> migration "All data"
            migration -> ws "Send data in the current data contract format" 
            ws -> edi "Result"
            autoLayout lr
        }
        dynamic dh3 "TO-BE-A" {
            title "ADR-101 - TO-BE-A"
            description "Dataflow - actors, gridareas and balanceresponsible"
            dh2 -> lz ""
            mp -> dataRefining "Sends actors and gridareas"
            balanceresponsible -> dataRefining "Sends balanceresponsible"
            lz -> dataRefining "Sends rest of data e.g. time series"
            dataRefining -> ws "Send data in the current data contract format" 
            ws -> edi "Result"
            autoLayout lr
        }

        dynamic dh3 "TO-BE-B" {
            title "ADR-101 - TO-BE-B"
            description "Dataflow - actors, gridareas and balanceresponsible"
            dh2 -> lz ""
            mp -> ws "Sends actors and gridareas" "using message broker/Delta Tables"
            balanceresponsible -> ws "Sends balanceresponsible" "using message broker/Delta Tables"
            lz -> migration "Sends rest of data e.g. time series" 
            migration -> ws "Send data in the current data contract format" 
            ws -> edi "Result"
            autoLayout lr      
        }
    }
}