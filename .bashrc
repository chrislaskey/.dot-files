# === Startup ===

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# === Variables ===

UNAME=`uname`

# === Helper Functions ===

function package_exists() {
    return dpkg -l "$1" &> /dev/null
}

# === General behavior ===

# Turn on VI command line mode (as opposed to emacs default key bindings)
set -o vi

# Turn autocompletion on when using sudo
complete -cf sudo

# Prevent "You have mail in /var/mail/$USER/" message
unset MAILCHECK

# Prevent "zsh is the new default shell" message on OS X
export BASH_SILENCE_DEPRECATION_WARNING=1

# Make VIM the default editor
if [[ -n `which vim 2>/dev/null` ]]; then
    export EDITOR=`which vim | head -1`
fi

# Turn off ._ copy files when using tar in Mac OS X
case "$UNAME" in
    Darwin) export COPYFILE_DISABLE=true;;
esac

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
alias ......='cd ../../../../..'

alias h='history'

alias dirs='find . -maxdepth 1 -type d -print0 | xargs -0 du -skh'

if [[ `which terminal-notifier` ]]; then
  # Available in OS X via homebrew
  alias notify='terminal-notifier -sound default -title Command Finished -message Finished command'
fi

# Weather
alias weather='telnet rainmaker.wunderground.com'

# Use color on grep output
# alias grep='grep --color=always' # Disabled: can cause issues with scripts
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

# Use color on ls output
case "$UNAME" in
  Darwin) alias ls="ls -G";;
  *) alias ls="ls --color=always";;
esac

# List all files colorized in long format, including dot files
alias ll="ls -lha"

# List only files
alias lsf='ls -lha | grep "^\-"'

# List only links
alias lsl='ls -lha | grep "^l"'

# List only directories
alias lsd='ls -lha | grep "^d"'

# Make the more user readable flags default
alias du='du -kh'
alias df='df -kTh'

# Slightly more informative than a which call
alias whicht='type -a'

# Flush directory service cache
if [[ "$UNAME" == Darwin ]]; then
    alias flush="dscacheutil -flushcache"
elif [[ "$UNAME" == Linux && -f /etc/init.d/nscd ]]; then
    alias flush="/etc/init.d/nscd restart"
fi

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Linux aliases
if [[ "$UNAME" != Darwin ]]; then
    if ! package_exists xclip; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    fi
fi

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

if [[ -n `which strace 2>/dev/null` ]]; then

    # Visual copy bar using strace
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

# Debugging puppet calls
alias puppetprofile='puppet agent --{summarize,test,debug,evaltrace} | perl -pe "s/^/localtime().\": \"/e"'
# Note: to sort results add in a grep + awk + sort chain:
# 'puppet agent --{summarize,test,evaltrace} | grep "seconds" | perl -pe "s/^/localtime().\": \"/e" | awk '{print $(NF-1),$0}' | sort -g'

# === Outside files to source ===

# Don't put duplicate lines in the history. See bash(1) for more options
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=5000
HISTFILESIZE=10000

if package_exists shopt; then
  # append to the history file, don't overwrite it
  shopt -s histappend

  # check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  shopt -s checkwinsize
fi

# === Outside files to source ===

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
}

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

function _update_ps1() {
    ### Basic bash:
    # source ~/.bash/prompt.sh
    ### Python powerline:
    PS1="$(~/.bash/powerline-shell/powerline-shell.py --mode flat $? 2> /dev/null)"
}

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

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

# === Tmux ===

if [[ -f ~/.bin/tmuxinator.bash ]]; then
    source ~/.bin/tmuxinator.bash
fi

alias mux='tmuxinator'

# Alias tmux commands
alias tmuxn='tmux new-session -s'
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'
alias tmuxk='tmux kill-session -t'

# === Docker ===

alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
dsh(){ docker exec -i -t "${1}_${1}_1" /bin/bash; }

docker_init() {
  eval $(docker-machine env default)
  export DOCKER_IP=`docker-machine ip default`
}

# Create a container based on an image and get a bash prompt in it
#   docker run -ti boxpanel /bin/bash

# Remove unused images:
#   docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")"

# === Git ===

PATH="${PATH}:/home/chrislaskey/.asdf/installs/nodejs/16.7.0/.npm/lib/node_modules/diff-so-fancy"

alias gco='git checkout'
alias ga='git add -p'
alias gaa='git add -A'
alias gc='git commit'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git bisect'
alias gu='git checkout master && git fetch upstream && git rebase upstream/master && git push origin master'
alias gs='git status'
alias gss='git status -sb'

# Find commit on date
# git-date master "Jan 20 2017"
git-date() {
  git rev-list -1 --before="$2" $1 --format=medium
}

# === VIM ===

alias tag='ctags -R --languages=ruby,elixir --exclude=.git --exclude=log --exclude=deps .'
alias tagall='ctags -R --languages=ruby,elixir --exclude=.git --exclude=log . $(bundle list --paths)'

# === ASDF ===

if package_exists brew; then
  ASDF_DIR=$HOME && [[ $(brew --prefix asdf) ]] && ASDF_HOME=$(brew --prefix asdf)
  ASDF_HOME=$HOME && [[ $(brew --prefix asdf) ]] && ASDF_HOME=$(brew --prefix asdf)
else
  ASDF_DIR=$HOME/.asdf
  ASDF_HOME=$HOME/.asdf
fi

if [[ -f ${ASDF_HOME}/asdf.sh ]]; then
    . ${ASDF_HOME}/asdf.sh
fi

if [[ -f ${ASDF_HOME}/etc/bash_completion.d/asdf.bash ]]; then
    . ${ASDF_HOME}/etc/bash_completion.d/asdf.bash
fi

if [[ -f ${ASDF_HOME}/completions/asdf.bash ]]; then
    . ${ASDF_HOME}/completions/asdf.bash
fi

# See `asdf` compatibility issue thread when installed with brew
# https://github.com/asdf-vm/asdf/issues/785#issuecomment-800631331
if [ -d ${ASDF_HOME}/shims ]; then
  PATH="${ASDF_HOME}/shims:${PATH}"
fi

# === Brew ===

eval "$(/opt/homebrew/bin/brew shellenv)"

# === Ruby ===

alias be='bundle exec'

# === direnv ===

if [[ `which direnv` ]]; then
    eval "$(direnv hook bash)"
fi

# === RabbitMQ ===

PATH="${PATH}:/usr/local/sbin"

# if [[ `which rbenv` ]]; then
#     eval "$(rbenv init -)"
# fi

# === Elixir ===

# export ERL_AFLAGS="-kernel shell_history enabled"

# test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# === NodeJS ===
#
# PATH="${PATH}:/usr/local/share/npm/bin"

# === NVM ===

# export NVM_DIR=~/.nvm
#
# . ${NVM_DIR}/nvm.sh
#
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# === pyenv ===

# eval "$(pyenv init -)"

# === Local bash settings ===

[[ -s "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"

# === gnu sed ===

if package_exists brew; then
  PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:${PATH}"
fi

# === Ubuntu Budgie ===

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi

if [[ "$UNAME" == Linux && -f ~/.dot-files/bin/reset-keyboard ]]; then
  ~/.dot-files/bin/reset-keyboard
fi

# === IBM Cloud ===

alias ic='ibmcloud'

# === Path ===

PATH="/opt/local/bin:/opt/local/sbin:/usr/local/share:/usr/local/include:/usr/local/lib:${HOME}/.dot-files/bin:${HOME}:${PATH}"

export PATH
