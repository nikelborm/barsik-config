{ pkgs, ... }:
{
  imports = [
    #! not a drop-in:
    #? it failed to build random container (C slipstream-server)
    #? it failed to interpret some instructions (https://github.com/containers/podman/issues/28293)
    #? it lacks of compose zsh completions
    ./podman.nix

    # (import ./docker.nix {
    #   inherit username;
    #   # rootless = true;
    # TODO: eva: research and set correct maybe like overlayfs2. And likely I would also need to repeat the same fixes it asks to do on arch linux like adding special kernel boot params
    #   storageDriver = "btrfs";
    # })
  ];

  environment.systemPackages = with pkgs; [
    distrobox

    lazydocker
    dive
    skopeo
  ];
}
