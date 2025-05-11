<p align=center>
  <img src='https://github.com/user-attachments/assets/6c42021c-a554-4435-abbb-2c6f93d6e181' alt='banner'>
</p>

#
![image](https://github.com/user-attachments/assets/e50f7d43-dca9-4ef0-8253-1b8498911175)

**pickleBerry** is a TUI based file-manager which specifically built for keyboard driven usecase.
It is completly shell based and so is very light weight and still can perform all basic file operations.
It is still required to know basic bash/zsh commands for usage (eg: touch, mkdir, etc).
**pickleBerry** uses dynamic keybindings so to improve usage speed and for a genral better user experience, for example the keybinding `t` can mean diffrent
things under diffrent senarios.

# Dependencies
- bash
- fzf

# Installation

### 1] Get the latest Release from the [releases page](https://github.com/ekahPruthvi/pickle_berry/releases)
![image](https://github.com/user-attachments/assets/69baa6a9-ab70-4871-b715-485d26c99f39)

### 2] Download the `pickleBerry_vX.X.X.tar.gz file and extract it
![image](https://github.com/user-attachments/assets/7a80db2e-aa3e-4610-a2a4-8de69d71a70d)

### 3] Install pickleBerry
run in terminal from inside the folder
```bash
sudo ./install.sh
```

# Uninstallation 
```bash
curl -Ss https://raw.githubusercontent.com/ekahPruthvi/pickle_berry/refs/heads/main/scripts/uninstall.sh | sudo bash
```
# Usage

| Keybinding | Action |
|------------|--------|
|`!`| Show the keybindings cheatsheet|
|`a`| Refresh Display|
|`h`| Toggle Hidden FIles|
|`/`| Traverse through directories|
|`<`| Go back in path|
|`[`| Quick actions|
|`m`| Move files/folders|
|`c`| Copy files/folders|
|`r`| Rename file/folder|
|`x`| Delete file/folder|
|`t`| Run Terminal commands|
|`o`| Open file/folder|
|`.`| Select files/folders to drag and drop elsewhere|
|`q`| Quit pickleBerry|

- FileNames contaning spaces might not always work, rename them and use
- If folder in the same directory avoid giving "/" infront of it, `/directory` --> ❌
- Use tab in selection menu to select multiple

# Freature Tab
## todo in the future
[ ] Mount and unmount external drives support
[ ] Tarball support
[ ] quickLinks - shortcut support





