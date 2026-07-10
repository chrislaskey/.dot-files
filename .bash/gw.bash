_gw_repo_root() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "gw: not inside a git repository" >&2
        return 1
    fi

    git worktree list --porcelain | sed -n '1s/^worktree //p'
}

_gw_ensure_worktrees_dir() {
    local repo_root="$1"

    mkdir -p "$repo_root/.worktrees"
}

_gw_ensure_gitignore() {
    local repo_root="$1"
    local gitignore="$repo_root/.gitignore"

    if [[ -f "$gitignore" ]] && grep -qxF '.worktrees/' "$gitignore"; then
        return
    fi

    echo '.worktrees/' >> "$gitignore"
}

_gw_ensure_fetched() {
    local git_branch="$1"

    if [[ "$git_branch" == */* ]]; then
        local remote="${git_branch%%/*}"
        local branch="${git_branch#*/}"
        git fetch "$remote" "$branch"
    fi
}

_gw_worktree_exists() {
    local repo_root="$1" name="$2"

    git -C "$repo_root" worktree list --porcelain | grep -qxF "worktree $repo_root/.worktrees/$name"
}

_gw_branch_exists() {
    local repo_root="$1" name="$2"

    git -C "$repo_root" show-ref --verify --quiet "refs/heads/$name"
}

_gw_ensure_worktree() {
    local repo_root="$1" name="$2" git_branch="$3"
    local path="$repo_root/.worktrees/$name"

    if _gw_worktree_exists "$repo_root" "$name"; then
        return
    fi

    if _gw_branch_exists "$repo_root" "$name"; then
        git -C "$repo_root" worktree add "$path" "$name"
    else
        git -C "$repo_root" worktree add -b "$name" "$path" "$git_branch"
    fi
}

_gw_open_session() {
    local session_name="$1" path="$2"

    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        tmux new-session -d -s "$session_name" -n agent -c "$path"
        tmux new-window -t "$session_name" -n code -c "$path"
        tmux select-window -t "$session_name:agent"
    fi

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

_gw_relative_time() {
    local then="$1"

    if [[ -z "$then" ]]; then
        echo "-"
        return
    fi

    local now diff
    now=$(date +%s)
    diff=$(( now - then ))

    if (( diff < 60 )); then
        echo "just now"
    elif (( diff < 3600 )); then
        local m=$(( diff / 60 ))
        echo "$m minute$([[ $m -ne 1 ]] && echo s) ago"
    elif (( diff < 86400 )); then
        local h=$(( diff / 3600 ))
        echo "$h hour$([[ $h -ne 1 ]] && echo s) ago"
    else
        local d=$(( diff / 86400 ))
        echo "$d day$([[ $d -ne 1 ]] && echo s) ago"
    fi
}

_gw_git_summary() {
    local path="$1"

    git -C "$path" status --porcelain=v2 --branch 2>/dev/null | awk '
        /^# branch\.head/ { branch = $3 }
        /^[12u]/ {
            split($2, xy, "")
            if (xy[1] != ".") staged++
            if (xy[2] != ".") unstaged++
        }
        /^\?/ { untracked++ }
        END { printf "%s|%d|%d|%d", branch, staged, unstaged, untracked }
    '
}

_gw_pad_field() {
    local str="$1" width="$2"
    local pad=$(( width - ${#str} ))
    (( pad < 0 )) && pad=0
    printf '%s%*s' "$str" "$pad" ""
}

_gw_format_git_summary() {
    local staged="$1" unstaged="$2" untracked="$3"

    if [[ "$staged" -eq 0 && "$unstaged" -eq 0 && "$untracked" -eq 0 ]]; then
        echo "clean"
        return
    fi

    local out=""
    [[ "$staged" -gt 0 ]] && out+="✔${staged} "
    [[ "$unstaged" -gt 0 ]] && out+="✘${unstaged} "
    [[ "$untracked" -gt 0 ]] && out+="✂${untracked} "
    echo "${out% }"
}

_gw_list() {
    local repo_root
    repo_root="$(_gw_repo_root)" || return 1

    local repo_name
    repo_name="$(basename "$repo_root")"

    # Last activity per session: the most recently active window in that
    # session, since an unattached session's own session_activity doesn't
    # update on pane output.
    local -A session_activity
    while read -r session activity; do
        session_activity["$session"]="$activity"
    done < <(tmux list-windows -a -F '#{session_name} #{window_activity}' 2>/dev/null \
        | awk '{ if ($2 > max[$1]) max[$1] = $2 } END { for (s in max) print s, max[s] }')

    echo "Active tmux sessions (all repos):"
    if [[ ${#session_activity[@]} -eq 0 ]]; then
        echo "  (none running)"
    else
        while IFS='|' read -r name windows attached; do
            local attached_label="-"
            [[ "$attached" == "1" ]] && attached_label="attached"
            printf "  %-30s windows=%-2s %-10s last activity: %s\n" \
                "$name" "$windows" "$attached_label" "$(_gw_relative_time "${session_activity[$name]}")"
        done < <(tmux list-sessions -F '#{session_name}|#{session_windows}|#{session_attached}' 2>/dev/null)
    fi

    echo
    echo "Worktrees in repo: $repo_name"

    local worktrees_dir="$repo_root/.worktrees"
    if [[ ! -d "$worktrees_dir" ]] || [[ -z "$(ls -A "$worktrees_dir" 2>/dev/null)" ]]; then
        echo "  (none)"
        return
    fi

    local dir name session git_summary staged unstaged untracked status_label
    for dir in "$worktrees_dir"/*/; do
        name="$(basename "$dir")"
        session="${repo_name}-${name}"

        IFS='|' read -r _ staged unstaged untracked <<< "$(_gw_git_summary "$dir")"
        status_label="$(_gw_format_git_summary "$staged" "$unstaged" "$untracked")"
        status_label="$(_gw_pad_field "$status_label" 15)"

        if [[ -n "${session_activity[$session]:-}" ]]; then
            printf "  %-20s %s session: running   last activity: %s\n" \
                "$name" "$status_label" "$(_gw_relative_time "${session_activity[$session]}")"
        else
            printf "  %-20s %s session: -\n" "$name" "$status_label"
        fi
    done
}

_gw_checkout() {
    local name="$1"
    local git_branch="${2:-origin/main}"

    if [[ -z "$name" ]]; then
        echo "gw: checkout requires a <name>" >&2
        return 1
    fi

    local repo_root
    repo_root="$(_gw_repo_root)" || return 1

    local session_name="$(basename "$repo_root")-$name"

    _gw_ensure_worktrees_dir "$repo_root" || return 1
    _gw_ensure_gitignore "$repo_root" || return 1
    _gw_ensure_fetched "$git_branch"
    _gw_ensure_worktree "$repo_root" "$name" "$git_branch" || return 1
    _gw_open_session "$session_name" "$repo_root/.worktrees/$name"
}

_gw_delete() {
    local name="$1" force=0

    if [[ "$2" == "-f" || "$2" == "--force" ]]; then
        force=1
    fi

    if [[ -z "$name" ]]; then
        echo "gw: delete requires a <name>" >&2
        return 1
    fi

    local repo_root
    repo_root="$(_gw_repo_root)" || return 1

    local path="$repo_root/.worktrees/$name"
    local session_name="$(basename "$repo_root")-$name"

    if [[ ! -d "$path" ]] && ! tmux has-session -t "$session_name" 2>/dev/null; then
        echo "gw: nothing to delete for '$name'" >&2
        return 1
    fi

    if [[ -d "$path" && "$force" -ne 1 ]]; then
        local staged unstaged untracked
        IFS='|' read -r _ staged unstaged untracked <<< "$(_gw_git_summary "$path")"

        if [[ "$staged" -gt 0 || "$unstaged" -gt 0 || "$untracked" -gt 0 ]]; then
            echo "gw: '$name' has uncommitted changes, refusing to delete (use --force)" >&2
            return 1
        fi

        local ahead
        ahead="$(git -C "$path" rev-list --count '@{u}..HEAD' 2>/dev/null)"

        if [[ -z "$ahead" ]]; then
            echo "gw: '$name' has no upstream to confirm it's pushed, refusing to delete (use --force)" >&2
            return 1
        elif [[ "$ahead" -gt 0 ]]; then
            echo "gw: '$name' has $ahead unpushed commit(s), refusing to delete (use --force)" >&2
            return 1
        fi
    fi

    tmux kill-session -t "$session_name" 2>/dev/null

    if [[ -d "$path" ]]; then
        if [[ "$force" -eq 1 ]]; then
            git -C "$repo_root" worktree remove --force "$path"
        else
            git -C "$repo_root" worktree remove "$path"
        fi
    fi

    echo "gw: deleted '$name'"
}

gw() {
    local cmd="$1"
    shift

    case "$cmd" in
        hello)
            echo "hello world"
            ;;
        checkout)
            _gw_checkout "$@"
            ;;
        list)
            _gw_list "$@"
            ;;
        delete)
            _gw_delete "$@"
            ;;
        *)
            echo "gw: unknown command '$cmd'" >&2
            return 1
            ;;
    esac
}
