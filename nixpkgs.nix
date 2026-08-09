{
  system,
  inputs,
  nixpkgs ? inputs.nixpkgs,
  overlays ? [ ],
}:
let
  #! харам, платные приложения
  paidApps = [
    "7zz"
    "uasm" # ? 7zz unfree dep
    "unrar"
    "corefonts"

    "vscode"
    "discord"
    "obsidian"
  ];
  lib = nixpkgs.lib;
in
import nixpkgs {
  inherit system;
  overlays = [
    (
      _: prev:
      builtins.mapAttrs
        (
          pkgsName: pkgsInput:
          import pkgsInput {
            inherit system;
            config.allowUnfreePredicate = pkg: builtins.elem (pkgsInput.lib.getName pkg) paidApps;
          }
        )
        (
          inputs
          |> nixpkgs.lib.attrsets.filterAttrs (inputName: _: inputName |> lib.strings.hasPrefix "nixpkgs-")
          |> lib.attrsets.mapAttrs' (
            inputName: input: {
              name = "${inputName |> lib.strings.removePrefix "nixpkgs-"}";
              value = input;
            }
          )
        )
    )
  ]
  ++ overlays;
  config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) paidApps;
}
