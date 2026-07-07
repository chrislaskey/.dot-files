# ~/.bash_profile
#
# macOS Terminal.app (and most macOS terminals) open login shells, which
# source .bash_profile but NOT .bashrc. This file ensures .bashrc is
# always loaded for interactive sessions.

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi
