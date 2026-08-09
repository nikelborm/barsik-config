{
  lib,
  pkgs,
  self,
  config,
  ...
}:
{
  services.fprintd = {
    enable = false;
  };

  #? cause fprint is fucked up in greetd
  security.pam.services.greetd.fprintAuth = lib.mkIf config.services.greetd.enable false;
}
