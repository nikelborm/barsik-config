{ pkgs }:
with pkgs;
import ./11_powertoys.nix { inherit pkgs; }
++ import ./12_python.nix { inherit pkgs; }
++ [
  #! other (specific cli tools)
  _7zz-rar
  gh
  gcc
  git-lfs
  file
  tlrc
  aria2
  sbctl # ? for systemd-boot (and lumine) secure boot
  unrar
  yq-go
  nodejs
  bun
  yt-dlp
  hadolint # ? Dockerfile
  pciutils # ? lspci
  usbutils # ? lssub
  qrencode
  ffmpeg-full
  #? files monitoring
  strace
  inotify-tools

  #! CLI db
  lazysql
  pgcli
  litecli

  #! GUI
  gimp3
  scrcpy
  obsidian
  transmission_4-gtk
]
