PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "suvash" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git vi-mode docker docker-compose asdf fzf zsh-autosuggestions mix)
plugins=(git vi-mode docker docker-compose asdf fzf mix)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --------------
# Customizations
# --------------

## Plugins

source <(fzf --zsh)

## Aliases

alias ack="rg"
alias rg="rg -L" # Follow symlinks by default 
alias rga="rg -L -uuu" # Follow symlinks by default and search all hidden files, including git ignored ones

alias wez='(){ LAUNCH_PROJECT=$1 wezterm start --always-new-process; }'
alias launch='(){ LAUNCH_PROJECT=$1 wezterm start --always-new-process; }'
alias start='(){ LAUNCH_PROJECT=$1 wezterm start --always-new-process; }'

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

unalias gco

gco() {
 git checkout $(git branch | fzf | tr -d ‘[:space:]*’)
}

## Keybindings

# For use with the `zsh-autosuggestions` plugin
# Press twice quickly to accept suggestion
# See: https://github.com/zsh-users/zsh-autosuggestions/issues/532#issuecomment-1527395751
bindkey ';;' autosuggest-accept

## Path

# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1 # Turn off autoupdate of homebrew packages
export HOMEBREW_NO_ANALYTICS=1

# Gnu-sed (gsed to sed)
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# psql
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# sqlite
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"

# java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# node
export COREPACK_ENABLE_AUTO_PIN=0

# API keys
export EXAMPLE_API_KEY=

## Prompt

function maybe_more_git_info() {
	# Display the git branch. Show status of untracked, unstaged, and staged
	# files with ✂ ✔ ✘ symbols and counts.

    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    local git_status=""
    local branch_name=""
    local is_dirty=false
    
    # Get branch name or commit hash for detached HEAD
    branch_name=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    
    # Count untracked files
    local untracked_count=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    
    # Count unstaged files
    local unstaged_count=$(git diff --name-only --no-ext-diff 2>/dev/null | wc -l | tr -d ' ')
    
    # Count staged files
    local staged_count=$(git diff --cached --name-only --no-ext-diff 2>/dev/null | wc -l | tr -d ' ')
    
    # Check if repo is dirty
    if [[ $untracked_count -gt 0 || $unstaged_count -gt 0 || $staged_count -gt 0 ]]; then
        is_dirty=true
    fi
    
    # Add branch name with appropriate color
    if [[ $is_dirty == true ]]; then
        git_status="%{$(tput setaf 220)%}${branch_name}"
    else
        git_status="%{$(tput setaf 34)%}${branch_name}"
    fi
    
    # Add staged files indicator
    if [[ $staged_count -gt 0 ]]; then
        if [[ $staged_count -eq 1 ]]; then
            git_status+=" %{$(tput setaf 34)%}✔"
        else
            git_status+=" %{$(tput setaf 34)%}✔ ${staged_count}"
        fi
    fi
    
    # Add unstaged files indicator
    if [[ $unstaged_count -gt 0 ]]; then
        if [[ $unstaged_count -eq 1 ]]; then
            git_status+=" %{$(tput setaf 124)%}✘"
        else
            git_status+=" %{$(tput setaf 124)%}✘ ${unstaged_count}"
        fi
    fi
    
    # Add untracked files indicator
    if [[ $untracked_count -gt 0 ]]; then
        if [[ $untracked_count -eq 1 ]]; then
            git_status+=" %{$(tput setaf 127)%}✂"
        else
            git_status+=" %{$(tput setaf 127)%}✂ ${untracked_count}"
        fi
    fi
    
    echo " ${git_status}%{$(tput sgr0)%}"
}

function current_dir() {
    # Check if we're in a git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then

        # Get the git repository root
        local git_root=$(git rev-parse --show-toplevel)

        # Get path relative to git root
        local rel_path="${PWD#$git_root}"

        # Handle the case when we're at the root of the repo
        if [[ -z "$rel_path" ]]; then
            # Don't add a trailing slash
            echo " $(basename "$git_root")"
        else
            local repo_name=$(basename "$git_root")
            echo " ${repo_name}${rel_path}"
        fi

    # Check if we're in a subdirectory of $HOME
    elif [[ "$PWD" == "$HOME"* ]]; then
    
        # Replace $HOME with ~
        local home_path="${PWD/#$HOME/~}"

        echo " ${home_path}"

    # Otherwise just show the current directory name
    else
        local dir_name=$(basename "$PWD")
        echo " ${dir_name}"
    fi
}

# Preview colors using: https://robotmoon.com/zsh-prompt-generator/
PS1='%{$(tput setaf 162)%}%n %{$(tput setaf 208)%}%m%{$(tput setaf 82)%}$(current_dir)$(maybe_more_git_info) %{$(tput sgr0)%}$ '

### Oh My ZSH overrides

# HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Enable sharing and appending history across multiple sessions (Bash default behavior)
setopt APPEND_HISTORY # Append history rather than overwrite the history file
setopt SHARE_HISTORY  # Share history between all sessions, so new commands are available immediately
setopt INC_APPEND_HISTORY # Append commands to the history file immediately, not just when the shell exits

# Revert arrow key behavior to cycle through full history (like default Bash)
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# See: https://unix.stackexchange.com/a/324658
# test -n "$terminfo[kcuu1]" && bindkey "$terminfo[kcuu1]" up-line-or-history
# test -n "$terminfo[kcud1]" && bindkey "$terminfo[kcud1]" down-line-or-history

# Worktrunk (worktrunk.dev)

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
