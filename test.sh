#! /bin/bash

test(){
    if [ $# -lt 2 ]; then
        echo "penguin asks where to move to?"
        exit
    else
        for i in $@; do
            if [ -e $i ]; then
                continue
            else
                echo "penguin don't think it exits : $i "
                break
            fi
        done
        mv $@ 2> /dev/null
    fi
}

read bob
test $bob 