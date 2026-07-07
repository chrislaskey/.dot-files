### Language Plugins
#
asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add nodejs
asdf plugin-add python
asdf plugin-add ruby

### Language Plugin Setup
#
. ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

### Language Versions
#
# To see available versions use: `asdf list-all <language>`
#
asdf install erlang 24.0.5
asdf install elixir 1.12.2
asdf install nodejs 16.7.0
asdf install python 3.7.4
asdf install ruby 3.0.2

### Set Global Versions
#
# See: .tool-versions
#
# asdf global erlang 24.0.5
# asdf global elixir 1.12.2
# asdf global nodejs 16.7.0
# asdf global python 3.7.4
# asdf global ruby 3.0.2
