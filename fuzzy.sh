#! /bin/bash
cd ~/

# Use fzf to fuzzy search files and directories in the current directory
selected_item=$(find . -type f -o -type d 2>/dev/null | fzf --prompt="Search in PWD: " > /dev/null)

# Check if a selection was made
if [ -z "$selected_item" ]; then
    echo "No selection made."
else
    echo "You selected: $selected_item"
fi
