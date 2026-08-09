{
  pkgs,
  self,
  username,
  ...
}:
{
  imports = [
    ./android-scrcpy-camera.nix
  ];

  users.users.${username}.extraGroups = [ "adbusers" ];

  environment.systemPackages = with pkgs; [
    android-tools
    android-file-transfer
  ];
}
