{ pkgs }:
with pkgs;
[
  jq
  fx
  bat
  dfrs
  micro-with-wl-clipboard
  gdu
  fzf
  btop
  zoxide
  ripgrep

  ncurses # tput for convinient colors in scripts
  net-tools # arp
]
