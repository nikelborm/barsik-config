#!/usr/bin/env bash

confirm() {
  printf "%s [Y/n] " "$1"
  read -r resp < /dev/tty
  if [ "$resp" = "" ] || [ "$resp" = "Y" ] || [ "$resp" = "y" ] || [ "$resp" = "yes" ]; then
    return 0
  fi
  if [ "$2" = "abort" ]; then
    echo "Abort."
    echo
    exit 0
  fi
  return 1
}


#? ls replacement
alias ezal='eza -F -bghM --smart-group --group-directories-first --color=auto --color-scale --icons=always --no-quotes --hyperlink'
alias ezall='eza -F -labghM --smart-group --group-directories-first --color=auto --color-scale --icons=always --no-quotes --hyperlink'
alias exal='exa -laFbgh --group-directories-first --color=auto --icons --color-scale'
alias exall='exa -laFbgh --group-directories-first --color=auto --icons --color-scale'

llalias() {
  if hash eza &> /dev/null; then
    alias ll=ezall
    alias l=ezal
  elif hash exa &> /dev/null; then
    alias ll=exall
    alias l=exal
  else
    alias ll='ls -laFbgh'
    alias l='ls -CFbh'
  fi
}

lllazy() {
  llalias
  alias ll
  eval ll "$@"
}

llazy() {
  llalias
  alias l
  eval l "$@"
}
