# Entire SystemLandscape in DataHub Organization
workspace "DataHub 3.0" {

    model {
        

        dh2 = softwareSystem "DataHub 2.0" "Developed and maintained by CGI" "ENE,ELO,ELO2,DH3"

        dhOrganization = enterprise "DataHub Organization" {
            dhSysAdmin = person "DataHub System Admin" "Person that works within Energinet" "DH3"
            
            dh3 = softwareSystem "DataHub 3.0" "Provides uniform communication and standardized processes for actors operating on the Danish electricity market." "DH3,ELO2" 
            elOverblik = softwareSystem "ElOverblik" "ElOverblik is a platform that is available to private individuals, businesses and third parties. The purpose of the platform is to provide data regarding electricity consumption and production." "ELO,ELO2"
            energiOprindelse = softwareSystem "EnergiOprindelse" "Full platform supporting creating a market for issuing and managing accounts, GC issuance, transfer and claims across european energy markets" "ENE"
        }
        # DH3 context
        group "External organization (actor) e.g. Energy Supplier or Grid Access Provider" {
            extUser = person "User" "A person who interacts with DataHub" ""
            extSoftSystem = softwareSystem "External software system" "External business transaction system. System-to-system communication (B2B)." "Actor"
        }

        # Eloverblik context 
        elOUsers = person "ElOverblik User" "Private / business - CPR/CVR-customer" "ELO,ELO2"
        elOThirdparty = softwareSystem "Third party" "Third party" "ELO,ELO2,Actor"
        
        # EnergiOprindelse context
        businessThirdparty = softwareSystem "Business or third party" "Large power producers, large power consumers, traders, and market players" "Actor,ELO,ELO2,ENE"
        goSystem = softwareSystem "GO, GC, Project Origin" "Project Origin, Granular Certificates (GCs), Guarantee of origin (GO)" "ENE"
        eds = softwareSystem "EnergiDataService" "Public service, grid data" "ENE"
        iam = softwareSystem "IAM Service" "The IAM Service is a software component that provides Identity and Access Management (IAM) functionality. Eg. MitId Erhverv"
        
        # Relationships to/from DH3
        dhSysAdmin -> dh3 "View and start jobs" "using browser" "DH3"
        extUser -> dh3 "View and start jobs" "using browser" "DH3"
        extSoftSystem -> dh3 "See results (RSM messages)" "HTTPS" "DH3"
        dh2 -> dh3 "Transferes data for calculations" "using AzCopy" "DH3,ELO2"


        # Relationships to/from ElOverblik
        elOUsers -> elOverblik  "Fetch own data" "" "ELO,ELO2"
        elOThirdparty -> elOverblik  "Fetch others data" "" "ELO,ELO2"
        dhSysAdmin -> elOverblik  "Administrate" "" "ELO,ELO2"
        elOverblik -> dh2  "Fetch data" "SOAP/HTTPS" "ELO,old"
        elOverblik -> eds "Fetch data"
        
        # Relationships to/from EnergiOprindelse
        businessThirdparty -> energiOprindelse "View consumption, emissions and granular-certificates" "" "ENE"
        energiOprindelse -> goSystem "Link to Guarantees of Origin" ""  "ENE"
        energiOprindelse -> eds "Gets emission and residual mix data" "REST/HTTPS"  "ENE"
        energiOprindelse -> dh2  "Fetch data" "SOAP/HTTPS" "ELO,old"
        energiOprindelse -> iam "Authenticate using"
        
    }

    views {
        systemlandscape SystemLandscape "System Landscape, filtered" {
            title "[System Landscape] DataHub"
            description "Level 0"
            include *
        }
        #filtered SystemLandscape include "ENE" 1-EnergiOprindelse "[1] The current system landscape for EnergiOprindelse."
        #filtered SystemLandscape include "ELO" 2-ElOverblik "[2] The current system landscape for ElOverblik."
        #filtered SystemLandscape include "ELO2" 3-ElOverblik2 "[3] The future system landscape for ElOverblik."
        #filtered SystemLandscape include "DH3" 4-DH3 "[4] The future system landscape for DH3."
        #filtered SystemLandscape include "ENE,ELO2,DH3" 5-All "[5] The future system landscape for DataHub Organization."



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
