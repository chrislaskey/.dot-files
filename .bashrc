# ~/.bashrc

# Only run for interactive shells
[[ $- != *i* ]] && return

# ---------
# PATH
# ---------

# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Gnu-sed (gsed to sed)
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# sqlite
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"

# node
export COREPACK_ENABLE_AUTO_PIN=0

# ---------
# Editor
# ---------

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# ---------
# Homebrew
# ---------

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1

# ---------
# History
# ---------

HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups

# Append to history file instead of overwriting
shopt -s histappend

# Write history after each command (approximate equivalent of INC_APPEND_HISTORY)
# Also reload history so other sessions' commands are visible (approximate SHARE_HISTORY)
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a; history -n"

# ---------
# Shell options
# ---------

# vi mode
set -o vi

# Check window size after each command
shopt -s checkwinsize

# Allow cd into directories by typing the directory name alone
shopt -s autocd 2>/dev/null

# Correct minor spelling errors in cd
shopt -s cdspell 2>/dev/null

# Case-insensitive globbing
shopt -s nocaseglob 2>/dev/null

# ---------
# fzf
# ---------

eval "$(fzf --bash)"

# ---------
# Completions
# ---------

# Homebrew bash completions
if [ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]; then
    source "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

# Docker completions (if installed via Homebrew or Docker Desktop)
if [ -f "/opt/homebrew/etc/bash_completion.d/docker" ]; then
    source "/opt/homebrew/etc/bash_completion.d/docker"
fi

# ---------
# Aliases
# ---------

alias ack="rg"
alias rg="rg -L"
alias rga="rg -L -uuu"

alias tmuxn="tmux new-session -s"
alias tmuxa="tmux attach-session -t"
alias tmuxl="tmux list-sessions"
alias tmuxk="tmux kill-session -t"

alias mux="tmuxinator"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias claude="claude --add-dir /Users/chrislaskey/code/ws-common/apps/product-docs"

alias ~='cd ~'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias gu='git checkout main && git fetch origin && git rebase origin/main'
alias gp='git push origin $(git symbolic-ref --short HEAD)'
alias ga='git add -p'
alias gaa='git add -A'
alias gc='git commit'
alias gdc='git diff --cached'
alias gd='git diff'
alias gb='git bisect'
alias gs='git status'
alias gss='git status -sb'

alias vim='command -v nvim >/dev/null && nvim || vim'

# ---------
# Functions
# ---------

gco() {
    git checkout $(git branch | fzf | tr -d '[:space:]*')
}

# ---------
# Prompt
# ---------

_maybe_more_git_info() {
    # Display the git branch with status indicators for staged/unstaged/untracked files.

    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    local git_status=""
    local branch_name=""
    local is_dirty=false

    branch_name=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    local untracked_count=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    local unstaged_count=$(git diff --name-only --no-ext-diff 2>/dev/null | wc -l | tr -d ' ')
    local staged_count=$(git diff --cached --name-only --no-ext-diff 2>/dev/null | wc -l | tr -d ' ')

    if [[ $untracked_count -gt 0 || $unstaged_count -gt 0 || $staged_count -gt 0 ]]; then
        is_dirty=true
    fi

    # Branch name: yellow if dirty, green if clean
    if [[ $is_dirty == true ]]; then
        git_status="\[$(tput setaf 220)\]${branch_name}\[$(tput sgr0)\]"
    else
        git_status="\[$(tput setaf 34)\]${branch_name}\[$(tput sgr0)\]"
    fi

    # Staged files (green checkmark)
    if [[ $staged_count -gt 0 ]]; then
        if [[ $staged_count -eq 1 ]]; then
            git_status+=" \[$(tput setaf 34)\]✔\[$(tput sgr0)\]"
        else
            git_status+=" \[$(tput setaf 34)\]✔ ${staged_count}\[$(tput sgr0)\]"
        fi
    fi

    # Unstaged files (red X)
    if [[ $unstaged_count -gt 0 ]]; then
        if [[ $unstaged_count -eq 1 ]]; then
            git_status+=" \[$(tput setaf 124)\]✘\[$(tput sgr0)\]"
        else
            git_status+=" \[$(tput setaf 124)\]✘ ${unstaged_count}\[$(tput sgr0)\]"
        fi
    fi

    # Untracked files (purple scissors)
    if [[ $untracked_count -gt 0 ]]; then
        if [[ $untracked_count -eq 1 ]]; then
            git_status+=" \[$(tput setaf 127)\]✂\[$(tput sgr0)\]"
        else
            git_status+=" \[$(tput setaf 127)\]✂ ${untracked_count}\[$(tput sgr0)\]"
        fi
    fi

    echo -e " ${git_status}"
}

_current_dir() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local git_root=$(git rev-parse --show-toplevel)
        local rel_path="${PWD#$git_root}"

        if [[ -z "$rel_path" ]]; then
            echo " $(basename "$git_root")"
        else
            local repo_name=$(basename "$git_root")
            echo " ${repo_name}${rel_path}"
        fi
    elif [[ "$PWD" == "$HOME"* ]]; then
        local home_path="${PWD/#$HOME/\~}"
        echo " ${home_path}"
    else
        local dir_name=$(basename "$PWD")
        echo " ${dir_name}"
    fi
}

_set_prompt() {
    # Build the prompt fresh each time so git info is current.
    # \[ and \] wrap non-printing sequences to prevent line-wrapping issues.
    local user="\[$(tput setaf 162)\]\u\[$(tput sgr0)\]"
    local host="\[$(tput setaf 208)\]\h\[$(tput sgr0)\]"
    local dir="\[$(tput setaf 82)\]$(_current_dir)\[$(tput sgr0)\]"
    local git="$(_maybe_more_git_info)"

    PS1="${user} ${host}${dir}${git} \$ "
}

PROMPT_COMMAND="_set_prompt; ${PROMPT_COMMAND}"

# ---------
# Keybindings
# ---------

# Arrow keys: prefix-based history search (type beginning of command, then up/down)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ---------
# API keys
# ---------

# Recommended: move secrets to ~/.secrets (chmod 600) instead of keeping them here.
# See installation notes at the top of this file.
if [ -f "$HOME/.secrets" ]; then
    source "$HOME/.secrets"
fi

# ---------
# Worktrunk (worktrunk.dev)
# ---------

if command -v wt >/dev/null 2>&1; then
    eval "$(command wt config shell init bash)"
fi
