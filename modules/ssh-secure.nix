{ lib, username, ... }:
{
  users.users.${username}.openssh.authorizedKeys.keys = [
    (lib.strings.removeSuffix "\n" (
      builtins.readFile (
        builtins.fetchurl {
          url = "https://github.com/nikelborm.keys";
          sha256 = "sha256-Tnf/WxeYOikI9i5l4e0ABDk33I5z04BJFApJpUplNi0=";
        }
      )
    ))
  ];
  services.openssh = {
    enable = true;
    ports = lib.mkDefault [ 22 ];
    settings = {
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  #? https://wiki.nixos.org/wiki/SSH_public_key_authentication#KDE
  #? add option to save passwords in kwallet
  #environment.variables.SSH_ASKPASS_REQUIRE = "prefer";
  #programs.ssh = {
  #  enableAskPassword = true;

  #  #? fallback for non-KDE
  #  askPassword = with pkgs; lib.getExe kdePackages.ksshaskpass;
  #};
}
