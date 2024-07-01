# Lex - A simple tool for serverless development

## Installation

```bash
chmod +x ./setup.sh
./setup.sh
```

## Usage

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

### Remove

```bash
lex remove <context> <service>
```

### Init

```bash
lex init
```

### Templates

```bash
lex templates --path <path>
```

### Contexts

```bash
lex contexts
```

### New Context

```bash
lex new <context> [--path <path>]
```

### New Service

```bash
lex <context> new <service> --template <template> [--path <path>]
```

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
│       ├── handlers
│       └── serverless.yml|ts
│       └── package.json
└── package.json
```

## Services

A service is a folder that contains the code for the service.