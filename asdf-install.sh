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
asdf install erlang 21.3
asdf install elixir 1.8.2
asdf install nodejs 10.16.3
asdf install python 3.7.4
asdf install ruby 2.6.4

### Set Global Versions
#
# See: .tool-versions
#
# asdf global erlang 21.3
# asdf global elixir 1.8.2
# asdf global nodejs 10.16.3
# asdf global python 3.7.4
# asdf global ruby 2.6.4
