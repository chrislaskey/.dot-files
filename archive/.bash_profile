# Source .bashrc
# .bash_profile is used for login terminals
# .bashrc is used for non-login terminals
# In both cases most of the code will be the same,
# so it makes sense to put code in one (.bashrc) and
# have the other (.bash_profile) source it.
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [ -e /Users/claskey/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/claskey/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
