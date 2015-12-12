# Custom bash prompt

UNAME=`uname`

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
	# Note: 256 Colors use: \e[38;05;<NUMBER>m\]
	# Table: https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
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
	PS1=$PS1'\[\e[38;05;198m\]\u \[\e[37;40m\]at \[\e[38;05;208m\]\h \[\e[37;40m\]in \[\e[38;05;154m\]\w\[\e[37;40m\]$(git_branch_on)\[\e[32;40m\]$(git_branch_clean)\[\e[38;05;226m\]$(git_branch_stage_dirty)\[\e[31;40m\]$(git_branch_working_tree_dirty)\[\e[37;40m\]\$ '

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
