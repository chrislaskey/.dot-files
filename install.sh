#!/bin/bash

# Install homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install modern bash (macOS ships with version from 2007)

brew install bash

# Add the new bash to allowed shells

echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells

# Set it as your default shell

chsh -s /opt/homebrew/bin/bash

# Symlink these dotfiles into place

ln -sf ./.bash_profile ~/.bash_profile
ln -sf ./.bashrc ~/.bashrc
ln -sf ./.config ~/.config
ln -sf ./.hammerspoon ~/.hammerspoon
ln -sf ./.tmux.conf ~/.tmux.conf
ln -sf ./.zshrc ~/.zshrc

# Create ~/.secrets for secret values in env vars (ex: API keys)

touch ~/.secrets
chmod 600 ~/.secrets

# Create new bash instance

/bin/bash

# Install the rest of the brew packages

brew bundle --file=./Brewfile

# Install asdf plugins

asdf plugin add python https://github.com/asdf-community/asdf-python.git
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin add dexter https://github.com/remoteoss/dexter.git && asdf install dexter latest && asdf set --home dexter latest
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
