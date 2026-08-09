{ pkgs, ... }:
{
  imports = [
    ./.
    ../modules/locale.nix
  ];

  fonts.packages = with pkgs; [
    # TODO: eva: jetbrains mono
    cascadia-code
  ];
  fonts.fontconfig.defaultFonts.monospace = [
    # TODO: eva: jetbrains mono
    "Cascadia Code NF"
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
