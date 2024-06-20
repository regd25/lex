#!/bin/bash

LEX_SCRIPT="lex"
DEST_DIR="/usr/local/bin"

if [ ! -f "$LEX_SCRIPT" ]; then
    echo "Error: el script $LEX_SCRIPT no se encuentra en el directorio actual."
    exit 1
fi

echo "Moviendo $LEX_SCRIPT a $DEST_DIR..."
sudo cp "$LEX_SCRIPT" "$DEST_DIR"

echo "Otorgando permisos de ejecución a $DEST_DIR/$LEX_SCRIPT..."
sudo chmod +x "$DEST_DIR/$LEX_SCRIPT"

if [[ ":$PATH:" != *":$DEST_DIR:"* ]]; then
    echo "Agregando $DEST_DIR al PATH..."
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        bash)
            CONFIG_FILE="$HOME/.bashrc"
            ;;
        zsh)
            CONFIG_FILE="$HOME/.zshrc"
            ;;
        *)
            echo "No se pudo detectar el shell. Agrega $DEST_DIR al PATH manualmente."
            exit 1
            ;;
    esac

    echo "export PATH=\$PATH:$DEST_DIR" >> "$CONFIG_FILE"
    echo "Recargando configuración del shell..."
    source "$CONFIG_FILE"
else
    echo "$DEST_DIR ya está en el PATH."
fi

echo "Configuración completa. Ahora puedes usar 'lex' desde cualquier lugar."

exit 0
