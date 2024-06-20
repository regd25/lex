#!/bin/bash

# Función para desplegar
deploy() {
    local context=$1
    local service=$2
    
    if [ -z "$context" ]; then
        echo "Usage: lex deploy <context> <service>"
        exit 1
    fi

    # Comprobar si el servicio está definido, si no, despliega el contexto
    if [ -z "$service" ]; then
        make -C "src/$context" deploy
    else
        make -C "src/$context/$service" deploy
    fi
}

# Función para invocar
invoke() {
    local context=$1
    local service=$2
    local function=$3 
    if [ -z "$context" ] || [ -z "$service" ]; then
        echo "Usage: lex invoke <context> <service>"
        exit 1
    fi
    make -C "src/$context/$service" invoke f=$function
}

# Función para test
test() {
    local context=$1
    local service=$2
    local scope=$3

    if [ -z "$context" ] || [ -z "$service" ]; then
        echo "Usage: lex test <context> <service> [scope]"
        exit 1
    fi

    make -C "src/$context/$service" scope="$scope" test
}

migrate() {
    make up -C src/migrations
}

init() {
    npm install
    npm install -g serverless
    lex migrate
}

# Procesar el comando
command=$1
shift

case "$command" in
    init)
        init
        ;;
    deploy)
        deploy "$@"
        ;;
    invoke)
        invoke "$@"
        ;;
    migrate)
        migrate
        ;;
    test)
        test "$@"
        ;;
    *)
        echo "Unknown command: $command"
        echo "Available commands: deploy, invoke, test"
        exit 1
        ;;
esac
