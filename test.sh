#! /bin/bash

test(){
    local inp
    if [ $# -gt 1 ]; then
        echo "penguin can not open mutiple files/folders" && sleep 2s
    elif [ $# -lt 1 ]; then
        echo "penguin has to open somthing ??" && sleep 2s
    elif [ -e $1 ]; then
        #make_window
        #tput cup $(( $ll - 2 )) 3
        vim $1 && ./Documents/grime/test.sh
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi
}

read bob
test $bob 