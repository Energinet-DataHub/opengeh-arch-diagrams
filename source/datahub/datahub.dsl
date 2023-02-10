workspace "DataHub 3.0" {

    model {
        group "Actor" {
            extUser = person "External user" "Person that works with the DataHub 3 system" "DH3"
            actor = softwareSystem "Actor" "For example a grid company or electricity supplier" "Actor,DH3"
        }
        
        dh2 = softwareSystem "DataHub 2" "Developed and maintained by CGI" "ENE,ELO,ELO2,DH3"

        dhOrganization = enterprise "DataHub Organization" {
            dh3User = person "DataHub system administrator" "Person that works within Energinet" "DH3"
            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." "DH3,ELO2" {
                # Containers and groups described in separate repos
            }
            elOverblik = softwareSystem "ElOverblik" "ElOverblik is a platform that is available to private individuals, businesses and third parties. The purpose of the platform is to provide data regarding electricity consumption and production." "ELO,ELO2"
            energiOprindelse = softwareSystem "EnergiOprindelse" "EnergiOprindelse is a platform which provides access to data about the origins of the energy and the corresponding emissions" "ENE"
        }
        
        # Eloverblik users
        persUser = person "Individual private user" "CPR-customer" "ELO,ELO2"
        businessThirdparty = softwareSystem "Business or third party" "Large power producers, large power consumers, traders, and market players" "Actor,ELO,ELO2,ENE"

        # EnergiOprindelse 
        goSystem = softwareSystem "GO, GC, Project Origin" "Project Origin, Granular Certificates (GCs), Guarantee of origin (GO)" "ENE"
        eds = softwareSystem "EnergiDataService" "Public service, grid data" "ENE"
        
        # Relationships to/from DH3
        dh3User -> dh3 "View and start jobs" "using browser" "DH3"
        extUser -> dh3 "View and start jobs" "using browser" "DH3"
        actor -> dh3 "See results (RSM messages)" "HTTPS" "DH3"
        dh2 -> dh3 "Transferes data for calculations" "using AzCopy" "DH3,ELO2"
        
        
        # Relationships to/from ElOverblik
        persUser -> elOverblik  "Fetch data" "" "ELO,ELO2"
        businessThirdparty -> elOverblik  "Fetch data" "" "ELO,ELO2"
        elOverblik -> dh2  "Fetch data" "SOAP/HTTPS" "ELO,old"
        elOverblik -> dh3  "Fetch data" "Deltatables" "ELO2"
        
        
        # Relationships to/from EnergiOprindelse
        businessThirdparty -> energiOprindelse "View consumption, emissions and granular-certificates" "" "ENE"
        energiOprindelse -> dh2 "Get meter masterdata" "SOAP/HTTPS"  "ENE"
        energiOprindelse -> goSystem "Manage Guarantees of Origin" ""  "ENE"
        energiOprindelse -> eds "Gets emission and residual mix data" "REST/HTTPS"  "ENE"
        
        #Future
        
        energiOprindelse -> dh3  "Fetch data" "" "ENE2"
    }

    views {
        systemlandscape SystemLandscape "System Landscape, filtered" {
            include *
            
        }


        
        filtered SystemLandscape include "ENE" 1-EnergiOprindelse "[1] The current system landscape for EnergiOprindelse."
        filtered SystemLandscape include "ELO" 2-ElOverblik "[2] The current system landscape for ElOverblik."
        filtered SystemLandscape include "ELO2" 3-ElOverblik2 "[3] The future system landscape for ElOverblik."
        filtered SystemLandscape include "DH3" 4-DH3 "[4] The future system landscape for DH3."
        filtered SystemLandscape include "ENE,ELO2,DH3" 5-All "[5] The future system landscape for DataHub Organization."
        
        
        
        themes https://static.structurizr.com/themes/microsoft-azure-2021.01.26/theme.json

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