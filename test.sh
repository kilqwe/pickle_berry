#! /bin/bash

test(){
    local inp
    if [ $# -ne 1 ]; then
        echo "penguin can not delete mutiple files/folders" && sleep 2s
    elif [ "$1" = "/" ] || [ "$1" = "//" ] ; then
        echo "penguin will not perform this action" && sleep 2s
    elif [ -e $1 ]; then
        #make_window
        #tput cup $(( $ll - 2 )) 3
        code $1 && ./Documents/grime/test.sh
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi
}

read bob
test $bob 