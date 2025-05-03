#!/bin/bash
# ekahPruthvi (SCU) <ekahpdp@gmail.com>

install_dir="/opt/pickle_Berry"
desktop_file="/usr/share/applications/pickleBerry.desktop"

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
  for i in {1..12}; do
    printf "\r%s Removing binary files " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
  for i in {1..12}; do
    printf "\r%s Deleting desktop files " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
  for i in {1..12}; do
    printf "\r%s Dereferencing penguin " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
}

if [ -d "$install_dir" ] && [ -e "$desktop_file" ]; then
    printf "Uninstalling pickleBerry :("
else
    printf "\033[0;31m!pickleBerry not installed\033[0m\n"
    exit
fi

rm -r $install_dir
rm $desktop_file
ascii_wave
echo "pickleBerry uninstalled :(" | pv -qL 50
