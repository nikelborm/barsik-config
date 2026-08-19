{
  lib,
  pkgs,
  flakePath,
  ...
}:
let
  terminalApps = [
    "kitty.desktop"
  ];
in
{
  xdg.mimeApps.associations.added."application/x-shellscript" = lib.mkBefore terminalApps;
  xdg.mimeApps.defaultApplications."application/x-shellscript" = lib.mkBefore terminalApps;
  xdg.terminal-exec.settings.default = "kitty.desktop";

  programs.kitty = {
    enable = true;
    font = {
      # JetBrains Mono NL is the no-ligatures version of JetBrains Mono font.
      # Useful command: kitty list-fonts
      # example of mono and propo: https://github.com/ryanoasis/nerd-fonts/issues/1703#issuecomment-2323803360
      # 1. Mono is truly mono and doesn't break the grid
      # 2. default without mono and propo visually still takes more than one cell, but doesn't break the grid, it just overlaps the character after them
      # 3. propo (proportional) (NO FUCKING T IN PROPO) takes as much space as it's rendered on. So characters following for example  shifted and grid broken
      # The best option is of course 1.
      # To show such best fonts execute `best_nerd_mono_fonts`
      name = "JetBrainsMono NFM SemiBold";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 18.0;
    };
    settings = {
      bold_font = "JetBrainsMono NFM ExtraBold";
      italic_font = "JetBrainsMono NFM SemiBold Italic";
      bold_italic_font = "JetBrainsMono NFM ExtraBold Italic";

      # font_family FiraCode Nerd Font Mono

      hide_window_decorations = "True";
      scrollback_lines = 100000;

      background_opacity = "1.0";
      # background_image /home/evadev/Pictures/Love_Wallpapers/black/4K-OLED-HD-Wallpaper.png
      background_image_layout = "scaled";
      background_tint = "0.7";

      enable_audio_bell = "no";
      touch_scroll_multiplier = "8.0";
      wheel_scroll_multiplier = "8.0";
      copy_on_select = "yes";

      # so that copiying in micro would work
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      single_instance = "yes";
    };
    # TODO:
    # keybindings = {
    #   "kitty_mod+f" = "launch --allow-remote-control kitty +kitten kitty_search/search.py @active-kitty-window-id";
    # };
  };

  home.sessionVariables.TERMINAL = "kitty";
}
