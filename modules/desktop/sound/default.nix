{ pkgs, username, ... }:
{
  #? rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
