# `.dot-files`

## Installation

### Dock

Unpin applications from Dock. Move to the right. Set autohide.

```
defaults write com.apple.dock autohide -bool true
```

### Display

Turn off "Automatically adjust brightness"

### Lock screen

Change durations

### Keyboard

Go to settings and change:
- Key repeat rate to `Fast`
- Delay until repeat to `Short`
- Keyboard Shortcuts > Modifier Keys > Caps Lock to ^Control

### Terminal

Download [ghostty](https://ghostty.org)

### Dot files git repo

Open https://github.com/chrislaskey/.dot-files and download zip

```
cp ~/Downloads/dot-files-main/.dot-files ~/.dot-files
cp -r ~/.dot-files-main/.* ~/
bash
```

Accept prompt to install xcode command line tools. If it doesn't come up automatically:

```
xcode-select --install
```

### Installation

```
cd ~/dot-files-main && ./install.sh
```

### Apps

Start and Configure:
- Ghostty
  - Install `ghostty.txt` config file
- Hammerspoon
  - Enable accessibility, start on login
  - Open ~/.hammerspoon/init.lua and update config as needed
- Firefox Developer Edition
  - Set new tab behaviour to blank page (use edit button in lower right)
  - Set always private browser window
    - Settings > Privacy & Security > History section > Select "Use custom settings for history". Check "Always use private browsing mode and restart the browser"
- Orbstack
  - Choose `docker`
  - Enable extensions via password
- Claude code
  - Log in
  - Set vim mode by using `/config` and then searching for vim
- Obsidian
  - Set vault
  - Turn on vim mode

### GitHub

General new fine-grained PAT token for specific repositories:
- Add `Contents > Read & Write` permission (if using `git push` flow)
- And/or add `Pull requests > Read and write` permission (if using `gh pr` flow)

Copy over personal access token, then log in using `gh` and the token:

```
gh auth login
```
