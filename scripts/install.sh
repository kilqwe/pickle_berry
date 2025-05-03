#!/bin/bash
# ekahPruthvi (SCU) <ekahpdp@gmail.com>

install_dir="/opt/pickle_Berry"
current_dir="$(dirname "$(readlink -f "$0")")"

echo "Starting install script." 
echo "fzf is required as a dependency, installing"
pacman -Sy fzf

mkdir $install_dir 
cp $current_dir/pbfm $install_dir/ 
cp $current_dir/pickleberry.png $install_dir/
cp -a $current_dir/src $install_dir/
cat > /usr/share/applications/pickleBerry.desktop << EOF 
[Desktop Entry]
Version=2.8.0
Type=Application
Name=pickleBerry
Comment=File manager for the TUIfreaks!!
Exec=bash $install_dir/pbfm
Icon=$install_dir/pickleberry.png
Terminal=true
StartupNotify=false
EOF

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
    printf "\r%s Moving Files " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
  for i in {1..12}; do
    printf "\r%s Running install sequence " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
  for i in {1..12}; do
    printf "\r%s Giving Permissions " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
  for i in {1..12}; do
    printf "\r%s Making a TUIfreak excited " "${frames[i % 6]}"
    sleep 0.05
  done
  echo ""
}

ascii_wave
chmod u+x /usr/share/applications/pickleBerry.desktop

echo "pickleBerry installed!!"