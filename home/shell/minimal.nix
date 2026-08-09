{
  lib,
  pkgs,
  config,
  flakePath,
  ...
}:
#! 90Mb
let
  aliases = import ./aliases.nix { inherit lib pkgs flakePath; };
  sharedAliases = aliases.sharedAliases // aliases.nixAliases;
in
{
  imports = [
    ./bat.nix
  ];

  programs.nix-your-shell = {
    enable = true;
    nix-output-monitor.enable = true;
  };

  xdg.configFile."shell/".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/.config/shell/";
  home.shellAliases = sharedAliases;
  programs.bun.enable = true;
  programs.bash = {
    enable = true;
    historySize = 100000;
    historyControl = [ "ignoreboth" ];
    initExtra = /* shell */ ''
      for file in "$XDG_CONFIG_HOME"/shell/*.sh; do
        source "$file"
      done
    '';
  };

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "simple";
    };
  };

  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
    '';
  };
  programs.zellij = {
    enable = true;
    settings = {
      scroll_buffer_size = 100000;
      default_mode = "locked";
      show_startup_tips = false;
    };
  };

  programs.starship = {
    enable = true;
    # settings = builtins.fromTOML (builtins.readFile ../../.config/starship.toml);
    settings = lib.mkForce { };
  };
  xdg.configFile."starship.toml".source = # TODO stylix conflict
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${flakePath}/.config/starship.toml");
  xdg.configFile."starship/starship.bash" = {
    source = ../../.config/starship/starship.bash;
    executable = true;
  };

  programs.lazygit.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      proc_tree = true;
    };
  };
}
