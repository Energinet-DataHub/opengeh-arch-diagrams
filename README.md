# opengeh-arch-diagrams

This repository contains C4 models and diagrams.

## Table of contents

1. [Folders structure](#folder-structure)
1. [DataHub base model](#datahub-base-model)

## Folder structure

This repository is structured according to the following sketch:

```txt
.
├── .github/
│   ├── actions/
│   ├── workflows/
│   └── CODEOWNERS
│
├── .vscode/
│
├── docs/
│   └── diagrams/
│      └── c4-model/
│         ├── views/
│         ├── dh-base-model.dsl
│         ├── views.dsl
│         └── views.json
│
├── .editorconfig
├── .gitignore
├── LICENSE
└── README.md
```

## DataHub base model

The DataHub base model is a C4 model that describes the big picture of systems in the DataHub company.

> This is a public repository so be conscious of any information that is added to the model.

The `dh-base-model.dsl` file contains the following:

- `model`: Describes elements like organizations, software systems and actors. Any person or software system that we want to use in any of our C4 models must be defined here.
- `views`: Contains `themes` and `styles` we want to be able to use throughout all C4 models.

The `views.dsl` file contains the following:

- `views`: Contains the System Landscape and System Context level.

In domain repositories developers should `extend` on the `workspace` in `dh-base-model.dsl` to be able to add additional elements within e.g. software systems, to define relationships with elements, or to simply reuse `styles`.

The C4 model and rendered diagrams are located in the folder hierarchy [docs/diagrams/c4-model](./docs/diagrams/c4-model/) and consists of:

- `dh-base-model.dsl`: Structurizr DSL describing the C4 model and reusable `themes` and `styles`.
- `views.dsl`: Structurizr DSL extending the `workspace` and describing the views.
- `views.json`: Structurizr layout information for views.
- `/views/*.png`: A PNG file per view described in the Structurizr DSL.

Maintenance of the C4 model should be performed using VS Code and a local version of Structurizr Lite running in Docker.

### Prerequisites

- Docker
- VS Code extensions "C4 DSL Extension" and "Docker" as recommended in `.vscode\extensions.json`

### Open Structurizr Lite in workspace

It is possible to view a single diagram at a time in VS Code using the "C4 DSL Extension". But the support for viewing diagrams is better with [Structurizr Lite](https://structurizr.com/share/76352/documentation), which also allows us to **perform manual layout**.

To launch Structurizr Lite from within VS Code do the following:

- MacOS
    - Run the task "Structurizr Lite: Load 'views'"
        - Use "Quick Open" (Shift + Cmd + P)
        - Select `Tasks: Run Task`
        - Select the "Structurizr Lite: Load 'views'" task

- Windows OS
    - Run the task "Structurizr Lite: Load 'views'"
        - Use "Quick Open" (CTRL + P)
        - Type 'task' and `Space` to see a list of available tasks defined in `tasks.json`
        - Select the "Structurizr Lite: Load 'views'" task

This will:

- If necessary: Pull the latest Structurizr Lite docker image
- Run the image in Docker
- Start Structurizr Lite pointing to the `views.dsl` workspace file

To view it in a browser, use the Docker extension pane and right-click the `structurizr/lite` container and select "Open in browser".

### Modeling

Use VS Code with the "C4 DSL Extension" to update the model file `dh-base-model.dsl` or views file `views.dsl` as necessary.

It is possible to view a single diagram in VS Code using the "C4 DSL Extension", but it has its limitations, so its usage is primarily for the editing support.

After editing in the model or views, refresh the browser running Structurizr Lite to reload the views. Note that unfortunately added boxes may be hidden behind existing ones, in that case you can drag boxes manually to fix the layout.

If `autolayout` is not enabled, it is possible to perform manual layout of elements in the model. Layout informations are saved in a `views.json` file. There are situations where the layout might be lost, or changed. See also [Structurizr - Troubleshooting](https://structurizr.com/share/76352/documentation#installation-2).
