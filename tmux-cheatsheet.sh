#!/bin/sh
# Tmux Cheatsheet - hiển thị khi mở terminal
# Tắt: export TMUX_CHEATSHEET=off

_tmux_cheatsheet() {
  [ "$TMUX_CHEATSHEET" = "off" ] && return

  local b=$'\e[1m' c=$'\e[36m' y=$'\e[33m' r=$'\e[0m'

  echo "${c}${b}  ┌─────────────────────────────────────────────────────┐${r}"
  echo "${c}${b}  │                   TMUX CHEATSHEET                   │${r}"
  echo "${c}${b}  └─────────────────────────────────────────────────────┘${r}"
  echo
  echo "${y}${b}  SESSION            WINDOW              PANE${r}"
  printf '  %-20s%-20s%s\n' \
    'C-b d  detach'     'C-b c    new'        'C-b %  split |' \
    'C-b s  list'       'C-b n    next'       'C-b "  split -' \
    'C-b $  rename'     'C-b 1-9  jump'       'C-b z  zoom' \
    ''                  'C-b ,    rename'     'C-b x  close'
  echo
  echo "${y}${b}  NAVIGATE                  COPY${r}"
  printf '  %-28s%s\n' \
    'C-h/j/k/l  move panes'    'C-b Space  thumbs (quick)' \
    '(no prefix needed)'       'C-b y      copy line' \
    ''                         'C-b [      copy mode'
  echo
  echo "${y}${b}  SAVE/RESTORE              MENU${r}"
  printf '  %-28s%s\n' \
    'C-b C-s  save session'    'C-b \      main menu' \
    'C-b C-r  restore'         'right-click context menu'
  echo
}
_tmux_cheatsheet
unset -f _tmux_cheatsheet
