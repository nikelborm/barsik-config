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
  htop
  zoxide
  ripgrep

  pass-wayland # unix password manager (pass) with wayland clipboard support

  ncurses # tput for convinient colors in scripts
  net-tools # arp
]
