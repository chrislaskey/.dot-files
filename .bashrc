# === Variables ===

# May be used in multiple places, call once and cache it
UNAME=`uname`

# Prevent "You have mail in /var/mail/$USER/" message
unset MAILCHECK

# === General behavior ===

# Turn on VI command line mode (as opposed to emacs default key bindings)
set -o vi

# Make VIM the default editor
if [[ -n `which vim 2>/dev/null` ]]; then
	export EDITOR=`which vim | head -1`
fi

# Turn autocompletion on when using sudo
complete -cf sudo

# === Aliases ===

# Use VIM whenever possible
if [[ -n `which vim 2>/dev/null` ]]; then
	alias vi='vim'
fi

# Make sudo read aliases
# See: http://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '

# Alias make to use all available CPU threads.
alias make='nice make -j $(grep "processor" /proc/cpuinfo | wc -l)'

# Alias home
alias ~='cd ~'

# Alias home
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias h='history'

# Weather
alias weather='telnet rainmaker.wunderground.com'

# Set color prompt if available
case "$UNAME" in
	Darwin) alias ls="ls -G";;
	*) alias ls="ls --color=always";;
esac

# List all files colorized in long format, including dot files
alias lsa="ls -lha"

# List only files
alias lsf='ls -lha | grep "^\-"'

# List only links
alias lsl='ls -lha | grep "^l"'

# List only directories
alias lsd='ls -lha | grep "^d"'

# Grep colors
alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

# Make the more user readable flags default
alias du='du -kh'
alias df='df -kTh'

# Slightly more informative than a which call
alias whicht='type -a'

# Normalize ack call, Debian systems use ack-grep package name
alias ack='ack-grep'

# Alias tmux commands
alias tmuxn='tmux new-session -s'
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'
alias tmuxk='tmux kill-session -t'

# Flush directory service cache
if [[ "$UNAME" == Darwin ]]; then
	alias flush="dscacheutil -flushcache"
elif [[ "$UNAME" == Linux && -f /etc/init.d/nscd ]]; then
	alias flush="/etc/init.d/nscd restart"
fi

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# OS X aliases
if [[ "$UNAME" == Darwin ]]; then
	# Show/hide hidden files in Finder
	alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
	alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

	# Hide/show all desktop icons (useful when presenting)
	alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
	alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
fi

# Simplified alias for grep word-counting
grepc () {
	echo "$(grep -lr "$1" "$2" | xargs grep -c "$1")"
}

# Simple command wrappers for additional safety / functionality
# Alias + function used to prevent auto shell globbing (e.g. *).
# See http://blog.edwards-research.com/2011/05/preventing-globbing/
safer_rm () {
	if [[ -f "${HOME}/.bash/command-wrappers/rm" ]]; then
		"$HOME"/.bash/command-wrappers/rm "$@"
		set +f
	else
		set +f
		/bin/rm "$@"
	fi
}

alias rm="set -f; safer_rm"

if [[ -n `which strace 2>/dev/null` ]]; then
	
	# Visual copy bar utilizing strace
	# Will slow down regular copying. Aliases to an option below
	# http://chris-lamb.co.uk/2008/01/24/can-you-get-cp-to-give-a-progress-bar-like-wget/
	cp_bar(){
		strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
			| awk '{
				count += $NF
					if (count % 10 == 0) {
					percent = count / total_size * 100
					printf "%3d%% [", percent
					for (i=0;i<=percent;i++)
						printf "="
					printf ">"
					for (i=percent;i<100;i++)
						printf " "
					printf "]\r"
					}
				}
				END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
	}

	# Visual progress bar for copy
	alias cpb="cp_bar"

fi

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# sshuttle port-forwarding/vpn alias
if [[ -d ~/.bash/scripts/sshuttle/ ]]; then
	alias sshuttle="~/.bash/scripts/sshuttle/sshuttle"
	# Note: basic command: sshuttle -r username@sshserver 0/0 -vv
fi

# Custom scripts set to aliases
alias internet='sudo ~/.dot-files/scripts/internet/internet.py'

# Debugging puppet calls
alias puppetprofile='puppet agent --{summarize,test,debug,evaltrace} | perl -pe "s/^/localtime().\": \"/e"'
# Note: to sort results add in a grep + awk + sort chain:
# 'puppet agent --{summarize,test,evaltrace} | grep "seconds" | perl -pe "s/^/localtime().\": \"/e" | awk '{print $(NF-1),$0}' | sort -g'

# === Outside files to source ===

# Don't put duplicate lines in the history. See bash(1) for more options
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=2000
HISTFILESIZE=5000

# === Outside files to source ===

# Allows fuzzy /* */ path searching in bash
# Disabled because it causes issues with spaces in directories
# even when encapsulated with single or double quotes. Use Z jump
# around instead.
# if [[ -n `whereis ruby` && -d ~/.bash/scripts/fuzzycd ]]; then
#	PATH="~/.bash/scripts/fuzzycd/:${PATH}"
#	source ~/.bash/scripts/fuzzycd/fuzzycd_bash_wrapper.sh
# fi

# Z jump around script (https://github.com/rupa/z)
if [[ -d ~/.bash/scripts/z ]]; then
	_Z_CMD=j
	_Z_DATA=~/.bash/scripts/z/z.db
	source ~/.bash/scripts/z/z.sh
fi

# Bash autocomplete scripts
if [[ -d ~/.bash/auto-complete/ ]]; then
	while read line; do
		source $line
	done < <(find ~/.bash/auto-complete -type f)
	# For an explanation of < <() syntax see:
	# http://stackoverflow.com/questions/7039130/bash-iterate-over-list-of-files-with-spaces
fi

# Bash Completion
# Must be installed separately. Look for 'bash-completion' package
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]; then
	source /opt/local/etc/bash_completion
fi

# Autocompletion for Python nose testing
# copied from newer versions of bash
__ltrim_colon_completions() {
	# If word-to-complete contains a colon,
	# and bash-version < 4,
	# or bash-version >= 4 and COMP_WORDBREAKS contains a colon
	if [[
		"$1" == *:* && (
			${BASH_VERSINFO[0]} -lt 4 ||
			(${BASH_VERSINFO[0]} -ge 4 && "$COMP_WORDBREAKS" == *:*)
		)
	]]; then
		# Remove colon-word prefix from COMPREPLY items
		local colon_word=${1%${1##*:}}
		local i=${#COMPREPLY[*]}
		while [ $((--i)) -ge 0 ]; do
			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
		done
	fi
} # __ltrim_colon_completions()

_nosetests() {
	cur=${COMP_WORDS[COMP_CWORD]}
	if [[
			${BASH_VERSINFO[0]} -lt 4 ||
			(${BASH_VERSINFO[0]} -ge 4 && "$COMP_WORDBREAKS" == *:*)
	]]; then
		local i=$COMP_CWORD
		while [ $i -ge 0 ]; do
			[ ${COMP_WORDS[$((i--))]} == ":" ] && break
		done
		if [ $i -gt 0 ]; then
			cur=$(printf "%s" ${COMP_WORDS[@]:$i})
		fi
	fi
	COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
	__ltrim_colon_completions "$cur"
}
complete -o nospace -F _nosetests nosetests

# === Prompt ===

# Set color prompt if available
case "$TERM" in
	xterm-color) COLOR_PROMPT=yes;;
	xterm-256color) COLOR_PROMPT=yes;;
	screen-256color) COLOR_PROMPT=yes;;
	screen-color) COLOR_PROMPT=yes;;
esac

# Always force color prompt
case "$UNAME" in
	Darwin) FORCE_COLOR_PROMPT=yes;;
	Linux) FORCE_COLOR_PROMPT=yes;;
	*) FORCE_COLOR_PROMPT=no;;
esac

# Some simple functions to put git branch in bash prompt.
# Redundant functions needed to get around a Mac OS X terminal color display
# bug. The only way to avoid wrapping issues is to use escape codes directly in
# PS1="". The many functions are the work around, for now at least.
#
# TODO: Cleanup this entire section. Check out Stack Overflow post for
# improvements:
# See http://stackoverflow.com/a/2659808/657661
function git_branch () { git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }

function git_branch_on() {

	if [[ -n $(git_branch) ]]; then
		echo " on "
	else
		echo ' '
	fi

}

function git_branch_diff () {

	# Checks both stage and working tree for uncommitted changes
	git diff-index --quiet --cached HEAD  2> /dev/null && git diff-files --quiet 2> /dev/null

}

function git_branch_clean() {

	if $(git_branch_diff); then
		echo $(git_branch)' '
	fi

}

function git_branch_working_tree_dirty() {

	git diff --quiet 2> /dev/null
	if [[ $? == 1 ]]; then
		echo $(git_branch)' '
	fi

}

function git_branch_stage_dirty() {

	# Check whether a working tree has changes that could be staged
	git diff-files --quiet 2> /dev/null
	if [[ $? == 1 ]]; then
		return 1
	fi

	# Check whether a repository has staged changes (not yet committed)
	git diff-index --quiet --cached HEAD 2> /dev/null
	if [[ $? == 1 ]]; then
		echo $(git_branch)' '
	fi

}

function git_branch_untracked() {

	# Check whether there are untracked files
	# ls-files --others returns untracked and ignored files.
	# --exclude-standard flag excludes ignored files
	#
	# TODO: implement. Double check return values
	if [[ -n "$(git ls-files --exclude-standard --others)" ]]
	then
		return 1
	else
		return 0
	fi

}

# Create prompt depending on whether color is available/forced on
if [[ "$COLOR_PROMPT" = yes || "$FORCE_COLOR_PROMPT" = yes ]]; then

	# Slightly modified versions of 
	# Steve Losh's colors (http://stevelosh.com/blog/2009/03/candy-colored-terminal/)
	#
	# Black: 0, 0, 0
	# Red: 229, 34, 34
	# Green: 166, 227, 45
	# Yellow: 252, 149, 30
	# Blue: 30, 67, 252
	# Magenta: 250, 37, 115
	# Cyan: 103, 217, 240
	# White: 242, 242, 242
	#
	# Color map (red, green, blue)
	# 0,229,166,252,30,250,103,242,0,229,166,252,30,250,103,242
	# 0,32,227,149,67,37,217,242,0,32,227,149,67,37,217,242
	# 0,34,45,30,252,115,240,242,0,34,45,30,252,115,240,242
	#
	# D=$'\e[37;40m'
	# MAGENTA=$'\e[35;40m'
	# GREEN=$'\e[32;40m'
	# ORANGE=$'\e[33;40m'
	# CYAN=$'\e[36;40m'
	# RED=$'\e[31;40m'
	# BLUE=$'\e[34;40m'
	#
	# Unfortunately color codes do not work correctly when used in variables.
	# They appear to work at first, but subtle linebreak problems will pop up.
	# Develop new prompts with them, but convert to actual values before using,
	# as seen below
	#
	# The prompt below is the same as this:
	# PS1='${MAGENTA}\u ${D}at ${ORANGE}\h ${D}in ${GREEN}\w ${D}on ${GREEN}$(git_branch_clean) ${ORANGE}$(git_branch_stage_dirty) ${RED}$(git_branch_working_tree_dirty) ${D}\$ '

	# Add last command exit code if non-zero to prompt
	# Note: disabled due to display errors in Mac OS X 10.6 on errors.
	# PS1='`EXIT_CODE=$?; if [[ $EXIT_CODE != 0 ]]; then echo "\nlast exit \e[31;40m$EXIT_CODE\e[37;40m on "; fi;`'
	PS1=''

	# Add the rest of prompt elements
	PS1=$PS1'\[\e[35;40m\]\u \[\e[37;40m\]at \[\e[33;40m\]\h \[\e[37;40m\]in \[\e[32;40m\]\w\[\e[37;40m\]$(git_branch_on)\[\e[32;40m\]$(git_branch_clean)\[\e[33;40m\]$(git_branch_stage_dirty)\[\e[31;40m\]$(git_branch_working_tree_dirty)\[\e[37;40m\]\$ '

	if [[ "$UNAME" == Darwin ]]; then

		# For an explanation see
		# http://it.toolbox.com/blogs/lim/how-to-fix-colors-on-mac-osx-terminal-37214
		#
		# a black
		# b red
		# c green
		# d brown
		# e blue
		# f magenta
		# g cyan
		# h light grey
		# A bold black, usually shows up as dark grey
		# B bold red
		# C bold green
		# D bold brown, usually shows up as yellow
		# E bold blue
		# F bold magenta
		# G bold cyan
		# H bold light grey; looks like bright white
		# x default foreground or background
		#
		# 1. directory
		# 2. symbolic link
		# 3. socket
		# 4. pipe
		# 5. executable
		# 6. block special
		# 7. character special
		# 8. executable with setuid bit set
		# 9. executable with setgid bit set
		# 10. directory writable to others, with sticky bit
		# 11. directory writable to others, without sticky bit
		#
		# The default is "exfxcxdxbxegedabagacad", i.e. blue fore-
		# ground and default background for regular directories,
		# black foreground and red background for setuid executa-
		# bles, etc.

		# Change Mac OS X dark blue to easier to read Cyan
		# export LSCOLORS=gxfxcxdxbxegedabagacad

		# Turn on color
		export CLICOLOR=1

		# Match colors with Debian
		export LSCOLORS=exgxcxdxcxegedabagacad

	fi

else

	PS1='\u at \h in \w \$ '

fi

# Remove any dangling variables
unset COLOR_PROMPT FORCE_COLOR_PROMPT

# === Man Pages ===

# Add colors to man pages in less
# See: http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

# === Path ===

# MacPorts Python binary folder
MACPORT_PY27_BIN="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/"
if [[ -d "${MACPORT_PY27_BIN}" ]]; then
	PATH="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/:${PATH}"
fi

# General additional bin paths
PATH="/opt/local/bin:/opt/local/sbin:${HOME}:${PATH}"

# Export PATH
export PATH
