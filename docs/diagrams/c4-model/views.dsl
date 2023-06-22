# The 'views.dsl' file is intended as a mean for viewing and validating the model.
# It should
#   * Extend the base model workspace and ONLY add views
#
# The `dh-base-model.dsl` file must contain the actual base model, and is the piece
# that must be extendable in domain repositories.
# It should
#   * Include the model
#   * Include reusable themes and styles

workspace extends dh-base-model.dsl {

    views {
        systemlandscape "SystemLandscape" {
            title "[System Landscape] DataHub (Simplified)"
            description "'As-is' view of the DataHub company"
            include *
            exclude "relationship.tag==OAuth"
            exclude "element.tag==Out of focus"
        }

        systemlandscape "SystemLandscapeDetailed" {
            title "[System Landscape] DataHub (Detailed)"
            description "'As-is' view of the DataHub company and nearby software systems"
            include *
            exclude "relationship.tag==OAuth"
        }

        systemcontext dh3 "SystemContext" {
            title "[System Context] DataHub 3.0"
            description "'As-is' view of the DH 3.0 software system and dependencies"
            include *
            exclude "relationship.tag==OAuth"
        }
    }
}