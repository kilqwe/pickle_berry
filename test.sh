#! /bin/bash

cleanup() {
    echo
    echo "Executing cleanup actions..."
    echo -e "\e[?1000;1006;1015l"
    echo "Cleanup complete."
    exit 0 # Exit the script after cleanup
}

trap cleanup SIGINT

echo -e "\e[?1000;1006;1015h"
while read -n 12 input; do 
    if [[ "$input" =~ $'\e\\[<([0-9]+);([0-9]+);([0-9]+)M' ]]; then
        column="${BASH_REMATCH[2]}"
        row="${BASH_REMATCH[3]}"
        button="${BASH_REMATCH[1]}"
        echo "$row,$column,$button"
    fi
done


