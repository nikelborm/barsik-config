{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  hmConfig = config.home-manager.users.${username};
in
{
  networking.networkmanager.enable = true;
  #? dns
  services.resolved.enable = true;
  # networking.nameservers = [
  #   "1.1.1.1"
  #   "9.9.9.9"
  #   "8.8.8.8"
  # ];
  networking.hosts = {
    "130.255.77.28" = [ "ntc.party" ];
    "95.182.120.241" = [
      "chatgpt.com"

      "videos.openai.com"

      #! pendos geo
      "sora.com"
      "sora.chatgpt.com"
    ];
  };
  networking.nftables.enable = true;

  environment.systemPackages = with pkgs; [ nixos-firewall-tool ];
  networking.firewall.enable = false;
}
