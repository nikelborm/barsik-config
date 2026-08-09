#!/usr/bin/env bash

mkcd() { mkdir -p "$@" && cd "$@" || exit; }

ssht() {
  (
    case "$1" in
      (-*) echo "Specify hostname first"; return 1 ;;
    esac
    ssh "$@" -t "zellij attach -c $1 options --default-mode locked --session-serialization false --theme blade-runner || tmux new -As$1 || bash || sh"
  )
}

a() {
  # shellcheck disable=SC2046
  print -z -- $(
    alias | awk -F= '{print $1}' |
    fzf --height 40% --border --prompt="Alias: " \
        --preview "zsh  -c 'source ~/.config/zsh/.zshrc && alias {} | cut --delimiter== --fields=2-' | tr --delete \' | bat --language sh --style=plain --color=always" \
        --preview-window 80%
  )
}

s () {
  #? https://dev.to/kaeruct/fzf-ssh-config-hosts-23dj
  (
    server=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | fzf --height 40%)
    if [[ -n $server ]]; then
      echo "Connecting to $server..."
      ssht "$server" "$@"
    fi
  )
}


type_colored() {
  type -afs "$@" | sed 's/is an alias for/is an alias for:\n/' | bat -l sh --style=plain --color=always
}
