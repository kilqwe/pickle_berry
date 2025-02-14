#! /bin/bash

test(){
    local inp
    if [ $# -ne 1 ]; then
        echo "penguin can not delete mutiple files/folders" && sleep 2s
    elif [ "$1" = "/" ] || [ "$1" = "//" ] ; then
        echo "penguin will not perform this action" && sleep 2s
    elif [ -e $1 ]; then
        #tput cup $(( $ll - 2 )) 3
        printf " DELETE $1? (y/n) : "
        read inp
        if [ "$inp" = "y" ] && [ -f $1 ]; then
            mv $1 ~/.local/share/Trash/files 2> /dev/null
        fi
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi
}

read bob
test $bob 