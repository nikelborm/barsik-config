{ pkgs }:
with pkgs;
[
  hyprpicker # --autocopy --notify # ? Color Picker
  lsof
  psmisc # (fuser)
]
