#!/bin/bash

get_lex_path() {
    current_dir=$(pwd)
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/.lex" ]; then
            echo $current_dir
            return
        fi
        current_dir=$(dirname "$current_dir")
    done
    echo "."
}

deploy() {
    local context=$1
    local service=$2
    local path=$(get_lex_path)

    if [ -z "$service" ]; then
        shift
    else
        shift 2
    fi

    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    if [ -z "$context" ]; then
        echo "Usage: lex deploy <context> <service> [--path <path>]"
        exit 1
    fi

    if [ -z "$service" ]; then
        make -C "${path}/src/$context" deploy
    else
        make -C "${path}/src/$context/$service" deploy
    fi
}

invoke() {
    local context=$1
    local service=$2
    local function=$3
    local path=$(get_lex_path)
    shift 3

    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    if [ -z "$context" ] || [ -z "$service" ]; then
        echo "Usage: lex invoke <context> <service> <function> [--path <path>]"
        exit 1
    fi

    make -C "${path}/src/$context/$service" invoke f=$function
}

remove() {
    local context=$1
    local service=$2
    local path=$(get_lex_path)
    shift 2

    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    if [ -z "$context" ] || [ -z "$service" ]; then
        echo "Usage: lex remove <context> <service> [--path <path>]"
        exit 1
    fi

    make -C "${path}/src/$context/$service" remove
}

test() {
    local context=$1
    local service=$2
    local scope=$3
    local path=$(get_lex_path)
    local watch_flag=""
    if [ -z "$scope" ] || [ "$scope" = "--watch" ]; then
        shift 2
    else
        shift 3
    fi

    while (( "$#" )); do
        case "$1" in
            --watch)
                watch_flag="--watch"
                shift
                ;;
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    if [ -z "$context" ] || [ -z "$service" ]; then
        echo "Usage: lex test <context> <service> <scope> [--watch] [--path <path>]"
        exit 1
    fi
    echo "$watch_flag"
    make -C "${path}/src/$context/$service" scope="$scope" WATCH_FLAG="$watch_flag" test
}

migrate() {
    local path=$(get_lex_path)
    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    make up -C "${path}/src/migrations"
}

init() {
    local path=$(get_lex_path)
    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    if [ -f "$path/.lex" ]; then
        echo "Lex is already initialized."
        exit 1
    else
        touch "$path/.lex"
        echo "Lex initialized."
    fi
}

templates() {
    local path=""
    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done
    if [ -z "$path" ]; then
        echo "Usage: lex templates --path <path>"
        exit 1
    fi

    if [ ! -d "$path/templates" ]; then
        echo "Error: Templates folder not found."
        exit 1
    fi

    echo "Available templates in $path:"
    find "$path/templates" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

contexts() {
    local path=$(get_lex_path)

    if [ -z "$path" ]; then
        path="src/"
    else
        path="${path}/src/"
    fi

    echo "Available contexts in ${path}:"
    find "${path}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

new() {
    local new_context=$1
    local path=$(get_lex_path)
    shift

    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                exit 1
                ;;
        esac
    done

    if [ -z "$new_context" ]; then
        echo "Usage: lex new <context> [--path <path>]"
        exit 1
    fi

    mkdir -p "${path}/src/$new_context"
    cp -r "${path}templates/default_template/"* "${path}/src/$new_context/"
}

new_service() {
    local context=$1
    local service=$2
    local path=$(get_lex_path)
    local template_path=""
    local template=""
    shift 2

    while (( "$#" )); do
        case "$1" in
            --path)
                path=$2
                shift 2
                ;;
            --template-path)
                template_path=$2
                shift 2
                ;;
            --template)
                template=$2
                shift 2
                ;;
            *)
                if [ -z "$context_command" ]; then
                    echo "Unknown parameter: $1"
                    exit 1
                fi
                ;;
        esac
    done

    if [ -z "$context" ] || [ -z "$service" ] || [ -z "$template" ]; then
        echo "Usage: lex <context> create <service> --template <template> [--path <path> --template-path <template-path>]"
        exit 1
    fi

    if [ ! -d "src/$context" ]; then
        echo "Error: Context $context does not exist."
        exit 1
    fi

    if [ -d "src/$context/$service" ]; then
        echo "Error: Service $service already exists in $context."
        exit 1
    fi

    if [ -d "$template_path/templates/$template" ]; then
        template_path="${template_path}/templates/$template/"
    else
        echo "Error: Template $template does not exist."
        exit 1
    fi

    mkdir -p "${path}/src/$context/$service"
    cp -r "$template_path"* "${path}/src/$context/$service/"

    echo "Service $service created in $context."
}

# Procesar el comando
command=$1
shift

case "$command" in
    init)
        init "$@"
        ;;
    deploy)
        deploy "$@"
        ;;
    invoke)
        invoke "$@"
        ;;
    migrate)
        migrate "$@"
        ;;
    remove)
        remove "$@"
        ;;
    test)
        test "$@"
        ;;
    templates)
        templates "$@"
        ;;
    new)
        new "$@"
        ;;
    contexts)
        contexts
        ;;
    *)
    path=$(get_lex_path)
    if [ -d "$path/src/$command" ]; then
        context_command=$command
        subcommand=$1
        shift
        case "$subcommand" in
            new)
                new_service "$context_command" "$@"
                ;;
            *)
                echo "Unknown command: $context_command $subcommand"
                echo "Available commands for context: new"
                exit 1
                ;;
        esac
    else
        echo "Unknown command: $command"
        echo "Available commands: deploy, invoke, test, new, migrate, templates, list"
        echo ""
        contexts
        exit 1
    fi
esac