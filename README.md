# opengeh-arch-diagrams

This repository contains C4 models and diagrams.

## Table of contents

1. [Folders structure](#folder-structure)
1. [DataHub 3 base model](#datahub-3-base-model)

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
│
├── .editorconfig
├── .gitignore
├── LICENSE
└── README.md
```

## DataHub 3 base model

The DataHub 3 base model is a C4 model that describes the big picture of the DataHub 3 project.

The `model` describes elements like organizations, software systems and actors. The `views` contains the System Landscape and System Context level, as well as the `themes` and `styles` we want to be able to use throughout all C4 models.

In domain repositories developers should `extend` on the base model to be able to add additional elements within e.g. software systems, to define relationships with elements, or to simply reuse `styles`.

The C4 model and rendered diagrams are located in the folder hierarchy [docs/diagrams/c4-model](./docs/diagrams/c4-model/) and consists of:

- `dh3-base-model.dsl`: Structurizr DSL describing the C4 model and views.
- `dh3-base-model.json`: Structurizr layout information for views.
- `/dh3-base-model/*.png`: A PNG file per view described in the Structurizr DSL.

Maintenance of the C4 model should be performed using VS Code and a local version of Structurizr Lite running in Docker.

### Prerequisites

- Docker
- VS Code extensions "C4 DSL Extension" and "Docker" as recommended in `.vscode\extensions.json`

### Open Structurizr Lite in workspace

It is possible to view a single diagram at a time in VS Code using the "C4 DSL Extension". But the support for viewing diagrams is better with [Structurizr Lite](https://structurizr.com/share/76352/documentation), which also allows us to **perform manual layout**.

To launch Structurizr Lite from within VS Code do the following:

1. Run the task "Structurizr Lite: Load 'dh3-base-model'"
    - Use "Quick Open" (CTRL + P)
    - Type 'task' and `Space` to see a list of available tasks defined in `tasks.json`
    - Select the "Structurizr Lite: Load 'dh3-base-model'" task

This will:

- If necessary: Pull the latest Structurizr Lite docker image
- Run the image in Docker
- Start Structurizr Lite pointing to the `dh3-base-model.dsl` workspace file

To view it in a browser, use the Docker extension pane and right-click the `structurizr/lite` container and select "Open in browser".

### Modeling

Use VS Code with the "C4 DSL Extension" to update the model file `dh3-base-model.dsl` as necessary.

It is possible to view a single diagram in VS Code using the "C4 DSL Extension", but it has its limitations, so its usage is primarily for the editing support.

After editing in the model, refresh the browser running Structurizr Lite to reload the model.

If `autolayout` is not enabled, it is possible to perform manual layout of elements in the model. Layout informations are saved in a `dh3-base-model.json` file. There are situations where the layout might be lost, or changed. See also [Structurizr - Troubleshooting](https://structurizr.com/share/76352/documentation#installation-2).
