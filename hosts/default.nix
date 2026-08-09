{ pkgs, ... }:
{
  imports = [
    ./minimal.nix
    ../modules/shell
  ];

  environment.systemPackages = builtins.concatLists (
    map (pkgsList: import pkgsList { inherit pkgs; }) [
      ../shared/lists/00_essential.nix
      ../shared/lists/01_base.nix
    ]
  );

  environment.variables.VISUAL = "micro";

  #? many tools (Python stdlib, uv) hardcode /etc/ssl/cert.pem
  environment.etc."ssl/cert.pem".source = "/etc/ssl/certs/ca-bundle.crt";
}
