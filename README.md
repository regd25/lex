# Lex - A simple tool for serverless development

## Installation

```bash
chmod +x ./setup.sh
./setup.sh
```

## Usage

### Init

```bash
lex init
```

Initializes a new project setup, preparing the necessary files and configuration.

### Templates

```bash
lex templates --path <path>
```

Displays available templates. Optionally, a path can be provided to specify where to look for templates.

### Contexts

```bash
lex contexts
```

Lists all available contexts.

### New Context

```bash
lex new <context> [--path <path>]
```

Creates a new context at the specified path, if given.

### New Service

```bash
lex <context> new <service> --template <template> --template-path <template-path> [--path <path>]
```

Creates a new service within the specified context using a given template, template-path is required. Optionally, a path can be provided to specify where to create the service.

### Invoke

```bash
lex invoke <context> <service> <function>
```

Invokes a specific function within a provided service and context.

### Test

```bash
lex test <context> <service> [scope]
```

Runs tests for a specific service within a context. Optionally, a scope can be specified.

### Deploy

```bash
lex deploy <context> <service>?
```

Deploys the specified context and optionally a specific service within that context.

### Migrate

```bash
lex migrate
```

Applies migrations necessary for the services or infrastructure.

### Remove

```bash
lex remove <context> <service>
```

Removes the specified context or service within it.

## Git branching

We use the branch name to define the deployment environment.

## Contexts

A context is a folder that contains a set of services. Each service is a folder that contains the code for the service.

The structure of a context is:

```
src
├── context
│   ├── service1
│   │   ├── handlers
│   │   └── serverless.yml|ts
│   │   └── package.json
│   └── service2
│       ├── handlers|ts
│       └── serverless.yml|ts|js
│       └── package.json|ts|js
└── migrations
    └── migrations
```

## Services

A service is a folder that contains the code for the service.