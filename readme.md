About
================================================================================

My collection of dot files, including configurations for bash shell, tmux, 
and vim.

create-dotfile-symlinks.py
--------------------------------------------------------------------------------

A simple python script for creating symlinks from this git repository to the
user's home directory. See the file for a longer description.

bash shell
--------------------------------------------------------------------------------

The shell is built on the powerline python project
The bash shell uses a custom variant of powerline. To install:

```bash
$ cd ~/.dot-files/.bash/powerline-shell
$ ./install.py
```

brew packages
--------------------------------------------------------------------------------

To install brew packages use:

```bash
$ ~/.dot-files/brew-install.sh
```

Review the log and do any follow up installation. For example, these steps are
required for configuring `puma-dev`:

```
Setup dev domains:
  sudo puma-dev -setup

Install puma-dev as a launchd agent (required for port 80 usage):
  puma-dev -install
```

asdf language runtime manager
--------------------------------------------------------------------------------

To install asdf language plugins and versions:

```bash
$ ~/.dot-files/asdf-install.sh
```

ruby gems
--------------------------------------------------------------------------------

To install ruby gems:

```bash
$ ~/.dot-files/gem-install.sh
```

npm packages
--------------------------------------------------------------------------------

To install npm packages:

```bash
$ ~/.dot-files/npm-install.sh
```

License
================================================================================

All code written by me is released under MIT license. See the attached
license.txt file for more information, including commentary on license choice.
