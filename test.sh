#! /bin/bash

test(){
    local inp
    if [ $# -ne 1 ]; then
        echo "penguin can not delete on mutiple files/folders" && sleep 2s
    elif [ -f $1 ]; then
        printf " DELETE $1 ? (y/n)"
        read inp
        if [ "$inp" = "y" ]; then
            echo
        fi
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi
}

read bob
test $bob 