#!/usr/bin/env bash
# Claude Code status line
# Shows: model name | context window usage % | session cost (if provided)

input=$(cat)

# --- Colors (dim palette, since the status line renders dimmed) ---
RESET=$'\033[0m'
DIM=$'\033[2m'
CYAN=$'\033[2;36m'
YELLOW=$'\033[2;33m'
GREEN=$'\033[2;32m'
MAGENTA=$'\033[2;35m'

# --- Model name ---
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

# --- Context window usage percentage ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx_str=$(printf "%.0f%%" "$used_pct")
else
  ctx_str="n/a"
fi

# --- Session cost (field name not guaranteed across versions; try common paths) ---
cost=$(echo "$input" | jq -r '
  (.cost.total_cost_usd // .cost.total_cost // .total_cost_usd // empty)
')
if [ -n "$cost" ] && [ "$cost" != "null" ]; then
  cost_str=$(printf "\$%.4f" "$cost")
else
  cost_str=""
fi

# --- Assemble output ---
line="${CYAN}${model}${RESET} ${DIM}|${RESET} ${YELLOW}ctx: ${ctx_str}${RESET}"
if [ -n "$cost_str" ]; then
  line="${line} ${DIM}|${RESET} ${GREEN}${cost_str}${RESET}"
fi

printf "%s" "$line"
