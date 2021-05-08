# Linux Install

Originally written for Ubuntu Budgie 20.10.

## Packages Installed

```
sudo apt install ack git python
```

### Rebind caps lock to control key

Rebinding is done with `xmodmap`. This is included in `x11-server-utils`:

```
sudo apt install x11-server-utils
```

Using the `create-dotfile-symlinks.py` script will create a `~/.Xmodmap` configuration file.

The configuration can be manually loaded from bash:

```
xmodmap ~/.Xmodmap
```

To ensure this gets called automatically on login, the `/.xinitrc` file includes a call to the same command.

### Configure xclip to work like pbcopy

```
sudo apt install xclip
```

```
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
```
