# === Variables ===

UNAME=`uname`

# === General behavior ===

# Turn on VI command line mode (as opposed to emacs default key bindings)
set -o vi

# Turn autocompletion on when using sudo
complete -cf sudo

# Prevent "You have mail in /var/mail/$USER/" message
unset MAILCHECK

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
alias grep='grep --color=always'
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
    PS1="$(~/.bash/powerline-shell/powerline-shell.py --mode flat $? 2> /dev/null)"
}

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

# Alias tmux commands
alias tmuxn='tmux new-session -s'
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'
alias tmuxk='tmux kill-session -t'

# === Docker ===

alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
dsh(){ docker exec -i -t "${1}_${1}_1" /bin/bash; }

if [[ `which docker-machine` && `docker-machine status default` == "Running" ]]; then
    eval $(docker-machine env default)
    export DOCKER_IP=`docker-machine ip default`
fi

# === Git ===

alias co='git checkout'
alias ga='git add -p'
alias gaa='git add -A'
alias gc='git commit'
alias gb='git bisect'
alias gu='git checkout master && git fetch upstream && git rebase upstream/master && git push origin master'
alias gs='git status'

# === VIM ===

alias tag='ctags -R --languages=ruby,elixir --exclude=.git --exclude=log --exclude=deps .'
alias tagall='ctags -R --languages=ruby,elixir --exclude=.git --exclude=log . $(bundle list --paths)'

# === Ruby ===

alias be='bundle exec'

if [[ `which rbenv` ]]; then
    eval "$(rbenv init -)"
fi

# === NodeJS ===

PATH="${PATH}:/usr/local/share/npm/bin"

# === RabbitMQ ===

PATH="${PATH}:/usr/local/sbin"

# === BBSH ===
# Note: must have installed yama_rsa

bbsh='ssh -t -p 26943 -i ~/.ssh/yama_rsa claskey@yama.blueboxgrid.com /usr/local/bin/bbsh $1'

# === direnv ===

if [[ `which direnv` ]]; then
    eval "$(direnv hook bash)"
fi

# === Local bash settings ===

[[ -s "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"

# === Path ===

PATH="/opt/local/bin:/opt/local/sbin:${HOME}:${PATH}"

export PATH
