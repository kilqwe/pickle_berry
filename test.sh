#! /bin/bash

test(){
    local brow
    local code
    if [ $# -gt 1 ]; then
        echo "penguin can not open mutiple files/folders" && sleep 2s
    elif [ $# -lt 1 ]; then
        echo "penguin has to open somthing ??" && sleep 2s
    elif [ -e $1 ]; then
        if [[ $file == \.html$ ]]; then
            brow=$(grep -il "MimeType=.*text/html" /usr/share/applications/*.desktop | xargs -n 1 basename | sed 's/.desktop//')
            code=$(xdg-mime query default text/plain | sed 's/.desktop//')
        else
            xdg-open $1
        fi
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi
}

read bob
test $bob 