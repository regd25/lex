# Lex - A simple tool for serverless development

## Installation

```bash
chmod +x ./setup.sh
./setup.sh
```

## Usage

## Git branching

We use the branch name to define the deployment environment.

### Deploy

```bash
lex deploy <context> <service>?
```

### Invoke

```bash
lex invoke <context> <service> <function>
```

### Test

```bash
lex test <context> <service> [scope]
```

### Migrate

```bash
lex migrate
```

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
│       ├── handlers
│       └── serverless.yml|ts
│       └── package.json
└── package.json
```

## Services

A service is a folder that contains the code for the service.