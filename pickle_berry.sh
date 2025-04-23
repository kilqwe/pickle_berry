#!/bin/bash
#--------------------Author:ekahPruthvi--------------------#

#-----------------init------------------------#
cd ~/

flag=1
win_size=$( tput lines )
max_rows=0

tput civis
printf '\033[2J\033[3J\033[1;1H'
printf "$color"

#-----------------backend---------------#
clear_win() {
    printf '\033[2J\033[3J\033[1;1H'
}

fnf() {
    local hide="$1"
    if [ "$hide" = 1 ]; then
        folders=$(find . -maxdepth 1 -type d -not -path '*/.*' | sed 's|^\./||')
        files=$(find . -maxdepth 1 -type f -not -name '.*' | sed 's|^\./||')
    else
        folders=$(ls -Ap | grep / | grep "^.")
        files=$(ls -Ap | grep -v / | grep "^.")
    fi
}

fnfind() {
    local fol="$1"
    if [ "$flag" = 1 ] && [ "$fol" = 1 ]; then
        echo $(find . -maxdepth 1 -type d -not -path '*/.*' | sed 's|^\./||'| fzf  --layout=reverse --border=bold --border=rounded --margin=10%)
    elif [ "$flag" = 1 ] && [ "$fol" = 0 ]; then
        echo $(find . -maxdepth 1 -not -path '*/.*' | sed 's|^\./||'| fzf  --layout=reverse --border=bold --border=rounded --margin=10%)
    elif [ "$flag" = 0 ] && [ "$fol" = 1 ]; then
        echo $(ls -Ap | grep / | grep "^." | fzf  --layout=reverse --border=bold --border=rounded --margin=10%)
    elif [ "$flag" = 0 ] && [ "$fol" = 0 ]; then
        echo $(ls -a| fzf  --layout=reverse --border=bold --border=rounded --margin=10%)
    else 
        echo 0
    fi
}

make_window() {
    tput cup 0 0 
    local COL=$( tput cols )
    local ROW=$( tput lines )
    #printf "$COL"
    printf "┌"
    for (( i=1 ; i<( $COL - 1 ) ; i++ )); do
        printf "─"
    done
    printf "┐\n"
    for (( i=1 ; i<( $ROW - 2 ); i++ )); do
         printf "│" 
         tput cup $i $COL
         printf "│\n"
    done
    printf "└"
    for (( i=1 ; i<( $COL - 1 ) ; i++ )); do
        printf "─"
    done
    printf "┘"
    tput cup 0 $(( $COL - 16 ))
    printf " pickle berry "
    tput cup 1 1
}

#taken from basil
Fillaform(){
    local ROW=$(tput lines)  
    local lineno="$#"
    local max=50
    for i in "$@"
    do      
        local temp="$i"
        local wc=${#temp}
        if [ "$wc" -gt "$max" ]
        then
            max="$wc"
        fi
    done
    max=$(($max+5))
    local fwidth=$(tput cols)
    local fpadding=$(( (fwidth - ${max}) / 2 ))
    local fendpad=$((( (fwidth - ${max}) / 2 )-1))
    local cont=0
    echo ""
    echo ""
    tput cup $(( (ROW / 2) - 7 ))
    local nline=$(( (ROW / 2) - 7 ))
    for i in "$@"
    do
        local finstartpadd=2
        local finendpadd=2
        temp="$i"
        local end="║"
        if [ "$cont" -eq 0 ]
        then
            end="╗"
            
        fi
        cont=$(($cont+1))
        wc=${#temp}
        finendpadd=$(( ($max-$wc)-5 ))
        tput cup $nline $fpadding
        printf " %${finstartpadd}s\033[7m %s%${finendpadd}s\033[0m" "" "$temp"
        echo "$end"
        ((nline++))
        local fline="╚"
        if [ "$cont" -eq "$lineno" ]
        then 
            tput cup $nline $(( $fpadding + 2))
            for f in $(seq 1 "$((max - 2 ))" )
            do
                if [ "$f" -eq "$(( max - 2 ))" ]
                then
                    fline="╝"
                fi
                printf "$fline"
                fline="═"
            done
        fi
    done
}

file_icon_exp(){
    local w=0
    local wc=$start_wc
    while [ $w -lt $files_in_line ] && [ $wc -lt $num ]; do
        printf  "  $1\t"
        ((w++))
        ((wc++))
    done
    echo
}

file_icon(){
    for word in "${file_array[@]}"; do
        printf  "  $1\t"
    done
    echo
}


show(){
    echo
    fnf "$flag"
    if [ "$1" = 1 ]; then
        readarray -t file_array <<<"$folders"


    else
       readarray -t file_array <<<"$files"


    fi

    local num=${#file_array[@]}
    local width=$(tput cols)
    local win_width=$(( width - 2 ))
    local max_lines=$(( (num / (win_width / 15)) + 1 ))
    local cur_num=$num
    local files_in_line=$(( (win_width / 15) - 1 ))
    max_rows=$(( $max_rows + $max_lines ))

    #printf "$win_width\n$max_lines\n$num\n" #testing
    if [ "$1" = 1 ]; then 
        echo "  [$PWD]"
        echo
        if [[ $(( win_width / 15 )) -gt "$num"  ]]; then 
            file_icon "╔▒▀▀▀▒▒▒"
            file_icon "║███████"
            file_icon "║███████"
            file_icon "╚══════╝"
            printf "  "
            for word in "${file_array[@]}"; do
                printf  "%-15.15s " "/$word"
            done
        else 
            start_wc=0
            local w=0
            local wc=0
            for (( i=1 ; i<=$max_lines ; i++ )); do
                file_icon_exp "╔▒▀▀▀▒▒▒"
                file_icon_exp "║███████"
                file_icon_exp "║███████"
                file_icon_exp "╚══════╝"
                w=0
                wc=$start_wc
                printf "  "
                while [ $w -lt $files_in_line ] && [ $wc -lt $num ]; do
                    printf  "%-15.15s " "/${file_array[$wc]}"
                    ((w++))
                    ((wc++))
                done
                #echo "$w $files_in_line $wc $num" #testing
                start_wc=$wc
                echo 
                echo
            done
        fi
    else
        if [[ $(( win_width / 15 )) -gt "$num"  ]]; then 
            file_icon "╔█▀▀▀▀▀▄"
            file_icon "║█     █"
            file_icon "║█#####█"
            file_icon "║█▄▄▄▄▄█"
            file_icon "╚══════╝"
            printf "  "
            local counter=0
            for word in "${file_array[@]}"; do
                printf  "%-15.15s " "$counter]$word"
                ((counter++))
            done
        else 
            start_wc=0
            local w=0
            local wc=0
            for (( i=1 ; i<=$max_lines ; i++ )); do
                file_icon_exp "╔█▀▀▀▀▀▄"
                file_icon_exp "║█     █"
                file_icon_exp "║█#####█"
                file_icon_exp "║█▄▄▄▄▄█"
                file_icon_exp "╚══════╝"
                w=0
                wc=$start_wc
                printf "  "
                while [ $w -lt $files_in_line ] && [ $wc -lt $num ]; do
                    printf  "%-15.15s " "$wc]${file_array[$wc]}"
                    ((w++))
                    ((wc++))
                done
                start_wc=$wc
                echo 
                echo
            done
        fi
    fi
}


display_seq(){
    clear_win
    show 1
    echo
    echo
    show 0
    if [[ $(( $max_rows * 8 )) -lt "$win_size" ]]; then
        make_window
    fi
}

moveanim(){
    local ROW=$(tput lines)
    clear_win
    local ctext="╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒"
    local cwidth=$(tput cols)
    local cpadding=$(( (cwidth - ${#ctext}) / 2 ))
    for ((i=0;i<1;i++)) do
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████ ▗▗▗      ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████   ▗▗▗    ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████     ▗▗▗  ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████      ▗▗▗ ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████      ▗▗▗ ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████    ▗▗▗   ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████  ▗▗▗     ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔▒▀▀▀▒▒▒          ╔▒▀▀▀▒▒▒\n"
        printf "%${cpadding}s║███████ ▗▗▗      ║███████\n"
        printf "%${cpadding}s║███████          ║███████\n"
        printf "%${cpadding}s╚══════╝          ╚══════╝\n"
        sleep 0.3
    done
}

copyanim(){
    local ROW=$(tput lines)
    clear_win
    local ctext="   █▀▀▀▀▀▄"
    local cwidth=$(tput cols)
    local cpadding=$(( (cwidth - ${#ctext}) / 2 ))
    for ((i=0;i<2;i++)) do
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█▀▀▀▀▀▄\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█#####█\n"
        printf "%${cpadding}s║█▄▄▄▄▄█\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l  █▀▀▀▀▀▄\n"
        printf "%${cpadding}s╔═█     █\n"
        printf "%${cpadding}s║ █#####█\n"
        printf "%${cpadding}s║ █▄▄▄▄▄█\n"
        printf "%${cpadding}s║      ║\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l   █▀▀▀▀▀▄\n"
        printf "%${cpadding}s╔═════─┐ █\n"
        printf "%${cpadding}s║  █###│#█\n"
        printf "%${cpadding}s║  █▄▄▄║▄█\n"
        printf "%${cpadding}s║      ║\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l  █▀▀▀▀▀▄\n"
        printf "%${cpadding}s╔═════─┐█\n"
        printf "%${cpadding}s║ █####│█\n"
        printf "%${cpadding}s║ █▄▄▄▄║█\n"
        printf "%${cpadding}s║      ║\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
    done
}

trashanim(){
    local ROW=$(tput lines)
    clear_win
    local ctext="   █▀▀▀▀▀▄"
    local cwidth=$(tput cols)
    local cpadding=$(( (cwidth - ${#ctext}) / 2 ))
    for ((i=0;i<1;i++)) do
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█▀▀▀▀▀▄\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█▄▄▄▄▄█\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█#▀▀▀▀▄\n"
        printf "%${cpadding}s║█ ##  █\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█▄▄▄▄▄█\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█##▀▀▀▄\n"
        printf "%${cpadding}s║█ ##  █\n"
        printf "%${cpadding}s║█   # █\n"
        printf "%${cpadding}s║█#▄▄▄▄█\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█##▀▀▀▄\n"
        printf "%${cpadding}s║█ ##  █\n"
        printf "%${cpadding}s########\n"
        printf "%${cpadding}s########\n"
        printf "%${cpadding}s########\n"
        printf "%${cpadding}s  ## #  \n"
        printf "%${cpadding}s  #     \n"
        sleep 0.3
    done
}

delanim(){
    local ROW=$(tput lines)
    clear_win
    local ctext="   █▀▀▀▀▀▄"
    local cwidth=$(tput cols)
    local cpadding=$(( (cwidth - ${#ctext}) / 2 ))
    for ((i=0;i<1;i++)) do
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█▀▀▀▀▀▄\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█#####█\n"
        printf "%${cpadding}s║█▄▄▄▄▄█\n"
        printf "%${cpadding}s╚══════╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█▀▀▀▀▀▄\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█#####█\n"
        printf "%${cpadding}s║█▄▄▄▄▄█\n"
        printf "%${cpadding}s╚═│═│═│╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█▀▀▀▀▀▄\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█│#│#│█\n"
        printf "%${cpadding}s║█│▄│▄│█\n"
        printf "%${cpadding}s╚═│═│═│╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█│▀│▀│▄\n"
        printf "%${cpadding}s║█│ │ │█\n"
        printf "%${cpadding}s║█│#│#│█\n"
        printf "%${cpadding}s║█│▄│▄│█\n"
        printf "%${cpadding}s╚═│═│═│╝\n"
        sleep 0.3
        clear
        tput cup $(( (ROW / 2) - 4 ))
        printf "%${cpadding}s\033[?25l╔█ ▀ ▀ ▄\n"
        printf "%${cpadding}s║█     █\n"
        printf "%${cpadding}s║█ # # █\n"
        printf "%${cpadding}s║█ ▄ ▄ █\n"
        printf "%${cpadding}s╚═ ═ ═ ╝\n"
        sleep 0.3
    done
}

#taken from basil
Line_sweep(){
    sleep 0.01
    [[ $LINES ]] || LINES=$(tput lines)
    [[ $COLUMNS ]] || COLUMNS=$(tput cols)
    tput civis
    for (( i=0; i<$LINES; i++ ))
    do
    clear
    if [ $i -gt 0 ]
    then
    n=$(($i-1))
    eval printf "$'\n%.0s'" {0..$n}
    fi
    eval printf %.1s '$((RANDOM & 1))'{1..$COLUMNS}
    sleep 0.01
    done
    clear
    tput cnorm
}

Flap-Travel(){
    fileanim=2
    if [ $# -lt 2 ]; then
        echo "penguin asks where to move to?" && sleep 2s
    else
        for i in $@; do
            if [ -e $i ]; then
                fileanim=0
                continue
            else
                echo "penguin don't think it exits : $i " && sleep 2s
                fileanim=1
                break
            fi
        done
        if [ "$fileanim" -eq 0 ]; then
            mv $@ 2> /dev/null
        fi
    fi
}

Waddle-Name(){
    local flag=2
    if [ $# -lt 2 ]; then
        echo "Enter the file/directory followed by the new name" && sleep 2s
    else
        if [ -e "$1" ]; then
            flag=0
            continue
        else
            echo "penguin don't think it exits : $1 " && sleep 2s
            flag=1
            break
        fi
        mv "$1" $2 2> /dev/null
    fi
}

Fish-Borrow(){
    local flag=1
    eval last=\${$#}
    if [ -f $last ] -a [ $last != " " ]; then
        max_rows=0
        display_seq
        tput cup $(( $ll - 2 )) 3
        printf " penguin asks if you want to rewrite (Y/n) : "
        read -rsn1 choice
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
    if [ -n $@ ]; then
        echo "penguin says invalid input," 
        echo "select souce file/directory and give destination file/directory" && sleep 2s
    elif [ "$flag" -eq 1 ]; then
        cp -a $@ 2> /dev/null
        copyanim
    fi
}

Snow-Sweep(){
    local inp
    undo="$1"
    undodir="$PWD"
    if [ $# -gt 1 ]; then
        echo "penguin will not delete mutiple files/folders (safety concerns ) use -t insted" && sleep 2s
    elif [ $# -eq 0 ]; then
        echo "penguin cannot delete nothing" && sleep 2s
    elif [ "$1" = "/" ] || [ "$1" = "//" ] ; then
        echo "penguin will not perform this action" && sleep 2s
    elif [ -e "$1" ]; then
        make_window
        tput cup $(( $ll - 2 )) 3
        printf " DELETE $1? (y/n) : "
        read -rsn1 inp
        if [ "$inp" = "y" ]; then
            mv "$1" ~/.local/share/Trash/files 2> /dev/null
            trash_file="$HOME/.local/share/Trash/files/$undo"
            printf "\nUSE -u TO UNDO CHANGES" && sleep 1s
            delanim
        fi
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi
}

Belly-Flop(){ 
    local brow
    local code
    local inp
    if [ $# -gt 1 ]; then
        echo "penguin can not open mutiple files/folders" && sleep 2s
    elif [ $# -lt 1 ]; then
        echo "penguin has to open somthing ??" && sleep 2s
    elif [ -e "$1" ]; then
        if [[ "$1" =~ \.html$ ]]; then 
            brow=$(grep -il "MimeType=.*text/html" /usr/share/applications/*.desktop | xargs -n 1 basename | sed 's/.desktop//')
            #code=$(xdg-mime query default text/plain | sed 's/.desktop//')
            make_window
            tput cup $(( $ll - 2 )) 3
            printf " penguin detects a html file, open with browser ? (y/n) : "
            read -rsn1 inp
            if [ "$inp" = "y" ]; then
                $brow "$1" 2> /dev/null
            else
                open "$1" 2> /dev/null
            fi
        elif [ -d "$1" ]; then
            code=$(xdg-mime query default text/plain | sed 's/.desktop//')
            make_window
            tput cup $(( $ll - 2 )) 3
            printf " penguin detects a Directory, open with code editor ? (y/n) : "
            read -rsn1 inp
            if [ "$inp" = "y" ]; then
                open "$1" 2> /dev/null
            else
                open "$1" 2> /dev/null
            fi
        else
            open "$1" 2> /dev/null
        fi
    else
        echo "penguin don't think $1 exits" && sleep 2s
    fi 
}

startup(){
    local ROW=$(tput lines)
    clear_win
    tput cup $(( (ROW / 2) - 4 ))
cat << "EOF"
    __        
 -=(o '.
    '.-.\
    /|  \\      █▀▄ █ ▄▀▀ █▄▀ █   ██▀   ██▄ ██▀ █▀▄ █▀▄ ▀▄▀
    '|  ||      █▀  █ ▀▄▄ █ █ █▄▄ █▄▄   █▄█ █▄▄ █▀▄ █▀▄  █ 
    _\_):,_     

EOF
    make_window
    sleep 1s 
    max_rows=0 
    display_seq 
    chk="no"
    undo="bob.penglin067"
}

#--------------------main--------------------#
startup
resize_trigger=0
trap 'resize_trigger=1' SIGWINCH
while true; do
    read -rsn1 -t 0.1 input
    if [ "$resize_trigger" -eq 1 ]; then
        input="a"
        resize_trigger=0
    fi

    if [ "$input" = "!" ] && [ "$chk" = "penglin" ] ; then
        input="a"
        chk="no"
    fi

    if [ "$input" = "a" ]; then
        max_rows=0
        display_seq
        
    elif [ "$input" = "h" ]; then
        clear_win
        if [[ "$flag" -eq 1 ]]; then
            echo "hide toggle off" && sleep 1s
            flag=0
            max_rows=0
            display_seq
        else
            echo "hide toggle on" && sleep 1s
            flag=1
            max_rows=0
            display_seq
        fi
    elif [ "$input" = "/" ]; then
        bob=$(fnfind 1)
        tput civis
        
        cd "$bob"
        max_rows=0
        display_seq
    elif [ "$input" = "<" ]; then
        
        cd ../
        max_rows=0
        display_seq
    elif [ "$input" = "[" ]; then
        ll=$(tput lines)
        tput cup $(( $ll - 2 )) 3
        printf " [ back - ] home - t trash - / type location "
        read -rsn1 bob
        if [ "$bob" = "]" ]; then
            cd ~/
        elif [ "$bob" = "[" ]; then
            cd -
        elif [ "$bob" = "t" ]; then
            cd ~/.local/share/Trash/files
        elif [ "$bob" = "/" ]; then
            make_window
            tput cup $(( $ll - 2 )) 3
            printf " type location : "
            read bob2
            cd "$bob2"
        else
            ll=$(tput lines)
            tput cup $(( $ll - 2 )) 3
            echo " invalid input " && sleep 1s
            max_rows=0
            display_seq
        fi
        max_rows=0
        display_seq
        if [[ "$PWD" = ~/.local/share/Trash/files ]]; then
            tput cup $(( $ll - 2 )) 3
            printf " -t TO EMPTY TRASH "
        fi
    elif [ "$input" = "m" ]; then
        ll=$(tput lines)
        if [ "$flag" = 1 ]; then
            bob=$(find . -maxdepth 1 -not -path '*/.*' | sed 's|^\./||'| fzf -m --layout=reverse --border=bold --border=rounded --margin=10%)
        elif [ "$flag" = 0 ]; then
            bob=$(ls -a| fzf -m --layout=reverse --border=bold --border=rounded --margin=10%)
        fi
        tput civis
        tput cup $(( $ll - 2 )) 3
        printf " enter destination folder  : "
        read bob2
        Flap-Travel $bob $bob2
        if [ $fileanim -eq 0 ]; then
            moveanim
        fi
        max_rows=0
        display_seq 
    elif [ "$input" = "r" ]; then
        ll=$(tput lines)
        tput cup $(( $ll - 2 )) 3
        bob=$(fnfind 0)
        tput civis
        printf " enter new name : "
        read bob2
        Waddle-Name "$bob" $bob2
        max_rows=0
        display_seq
    elif [ "$input" = "c" ]; then
        ll=$(tput lines)
        if [ "$flag" = 1 ]; then
            bob=$(find . -maxdepth 1 -not -path '*/.*' | sed 's|^\./||'| fzf -m --layout=reverse --border=bold --border=rounded --margin=10%)
        elif [ "$flag" = 0 ]; then
            bob=$(ls -a| fzf -m --layout=reverse --border=bold --border=rounded --margin=10%)
        fi
        tput civis
        tput cup $(( $ll - 2 )) 3
        printf " enter destination folder or coplied file name : "
        read bob2
        Fish-Borrow $bob $bob2
        max_rows=0
        display_seq
    elif [ "$input" = "." ]; then
        ll=$(tput lines)
        fzf -m --layout=reverse --border=bold --border=rounded --margin=10% | wl-copy
        tput civis
        tput cup $(( $ll - 2 )) 3
        printf " copied path "
        sleep 1s
        max_rows=0
        display_seq
    elif [ "$input" = "t" ] && [ "$bob" = "t" ]; then
        make_window
        ll=$(tput lines)
        tput cup $(( $ll - 2 )) 3
        printf " Empty TRASH (y/n) : "
        read -rsn1 bob
        if [ "$bob" = "y" ]; then
            rm -rf ~/.local/share/Trash/files/*
            trashanim
        fi
        max_rows=0
        display_seq
    elif [ "$input" = "t" ]; then
        make_window
        ll=$(tput lines)
        tput cup $(( ll - 2 )) 3
        printf " Execute command : "
        read bob
        clear_win
        echo "[user@pbfm]$ $bob"
        echo "------------"
        printf "\033[0;32m"
        bash -c "$bob"
        printf "\033[0m\n"
        read -n 1 -s -r -p "Press any key to return to the file manager ..."
        Line_sweep
        tput civis
        max_rows=0
        display_seq
    elif [ "$input" = "x" ]; then
        ll=$(tput lines)
        tput cup $(( $ll - 2 )) 3
        printf " DELETE FILE/FOLDER : "
        Snow-Sweep $(fnfind 0)
        tput civis
        max_rows=0
        display_seq
    elif [ "$input" = "u" ] && [ -e "$trash_file" ]; then
        mv "$trash_file" "$undodir"
        max_rows=0
        display_seq
    elif [ "$input" = "o" ]; then
        ll=$(tput lines)
        tput cup $(( $ll - 2 )) 3
        printf " Open Files ? : "
        if [ "$flag" = 1 ]; then
            Belly-Flop $(find . -maxdepth 1 -not -path '*/.*' | sed 's|^\./||'| fzf --layout=reverse --border=bold --border=rounded --margin=10% --preview 'file -b {} | grep -iq "text" && echo -e "Permissions: $(stat -f %Sp {})\nLinks: $(stat -f %l {})\nOwner: $(stat -f %Su {})\nGroup: $(stat -f %Sg {})\nSize: $(stat -f %z {}) bytes\nModified: $(stat -f %Sm {})\nFile: {}\n\n------ Separator Line ------\n$(cat {})" || echo -e "Permissions: $(stat -f %Sp {})\nLinks: $(stat -f %l {})\nOwner: $(stat -f %Su {})\nGroup: $(stat -f %Sg {})\nSize: $(stat -f %z {}) bytes\nModified: $(stat -f %Sm {})\nFile: {}\n\n------ Preview ------\nPenguin detects Binary file, cannot display content."')
        elif [ "$flag" = 0 ]; then
            Belly-Flop $(ls -a| fzf --layout=reverse --border=bold --border=rounded --margin=10% --preview 'file -b {} | grep -iq "text" && echo -e "Permissions: $(stat -f %Sp {})\nLinks: $(stat -f %l {})\nOwner: $(stat -f %Su {})\nGroup: $(stat -f %Sg {})\nSize: $(stat -f %z {}) bytes\nModified: $(stat -f %Sm {})\nFile: {}\n\n------ Separator Line ------\n$(cat {})" || echo -e "Permissions: $(stat -f %Sp {})\nLinks: $(stat -f %l {})\nOwner: $(stat -f %Su {})\nGroup: $(stat -f %Sg {})\nSize: $(stat -f %z {}) bytes\nModified: $(stat -f %Sm {})\nFile: {}\n\n------ Preview ------\nPenguin detects Binary file, cannot display content."')
        fi
        tput civis
        max_rows=0
        display_seq
    elif [ "$input" = "!" ]; then
        Fillaform "   " "█▀▄ █ ▄▀▀ █▄▀ █   ██▀   ██▄ ██▀ █▀▄ █▀▄ ▀▄▀" "█▀  █ ▀▄▄ █ █ █▄▄ █▄▄   █▄█ █▄▄ █▀▄ █▀▄  █" "The keyboard oriented file manager" "   " "<!> for this help message" "<a> to refresh display" "<h> toggle hidden files" "</> change directory" "<<> back" "<[> quick commands" "<m> to move files and folders" "<c> to copy files and folders" "<r> to rename file of folder" "<x> to delete (use <u> to undo)" "<o> to open file" "<q> to quit" "<.> to copy path" "   "
        chk="penglin"
    elif [ "$input" = "q" ]; then
        tput cnorm
        break
    fi
done

ascii_wave() {
  frames=(
    "⣾"
    "⣽"
    "⣻"
    "⢿"
    "⡿"
    "⣟"
    "⣯"
    "⣷"
  )
  for i in {1..16}; do
    printf "\r%s Disconnect matrix " "${frames[i % 8]}"
    sleep 0.1
  done
  echo ""
  for i in {1..16}; do
    printf "\r%s Running exit sequence " "${frames[i % 8]}"
    sleep 0.1
  done
  echo ""
  for i in {1..16}; do
    printf "\r%s Removing nodes " "${frames[i % 8]}"
    sleep 0.1
  done
  echo ""
  for i in {1..16}; do
    printf "\r%s Clearing temp variables " "${frames[i % 8]}"
    sleep 0.1
  done
  echo ""
}

clear_win
ascii_wave
clear_win
tput cnorm
