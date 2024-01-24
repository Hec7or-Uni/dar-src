#!/usr/bin/env bash

# -------------------------------------------------------
# Args
# -------------------------------------------------------

NAME=$1

# -------------------------------------------------------
# Functions
# -------------------------------------------------------

# imprime un mensaje de saludo
function hello_world() {
    name=$1

    if [ -z "$name" ]; then
        echo "Hello World"
        return
    fi

    echo "Hello $name"
}

# -------------------------------------------------------
# Main
# -------------------------------------------------------

# ejecuta la funcion hello_world
hello_world $NAME