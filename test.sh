#! /bin/bash

test(){
    local flag=1
    eval last=\${$#}
    if [ -f $last ]; then
        echo "penguin asks if you want to rewrite (Y/n)"
        read choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ] || [ "$choice" = "" ]; then
            echo "rewriting $last"
            flag=1
        else
            flag=0
            return 
        fi
    else 
        flag=1
    fi
    if [ $# -lt 2 ]; then
        echo "penguin says invalid input," 
        echo "give atleast souce file/directory and destination file/directory"
    else
        for i in $@; do
            if [ -e $i ] || [ "$i" = "$last" ]; then
                continue
            else
                echo "penguin don't think it exits : $i "
                break
            fi
        done
        if [ "$flag" -eq 1 ]; then
            cp $@ 2> /dev/null
        fi
    fi
}

read bob
test $bob 