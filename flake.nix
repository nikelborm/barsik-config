{
  inputs = {
    # nixpkgs-previous.url = "nixpkgs/commit_hash";
    # nixpkgs-fix-for-<smth>.url = "nixpkgs/pull/1488/head";
    #? smaller then github tarball, less api hits: https://discourse.nixos.org/t/use-channels-as-flake-inputs/75261
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    #? more secure: https://determinate.systems/blog/nixpkgs-cooldown/
    # nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
    # nixpkgs-master.url = "nixpkgs";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    erosanix = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dewclaw = {
      url = "github:MakiseKurisu/dewclaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    omp = {
      url = "github:can1357/oh-my-pi";
      #? use the same nixpkgs as the rest of the config
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: FUCK THIS NIXFMT INDENT: https://github.com/NixOS/nixfmt/issues/91
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import ./nixpkgs.nix { inherit system inputs; };

      mkSpecialArgs = username: {
        inherit
          self
          inputs
          username
          ;
        flakePath = "/home/${username}/config/nix";
      };

      mkHomeCfg = username: modules: {
        ${username} = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = mkSpecialArgs username;
          modules = modules ++ [
            ./home
          ];
        };
      };

      mkCoolVm =
        name: username: modules:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = mkSpecialArgs username;
          modules = modules ++ [
            # TODO: link current nixpkgs source to store to avoid refetching it withing guest
            ./hosts/vm
            (
              { username, ... }:
              {
                networking.hostName = "coolvm";

                virtualisation.vmVariant.virtualisation = {
                  diskImage = null;
                  memorySize = 8 * 1024;
                  cores = 8;
                  #! sharedDirectories
                  qemu.options = [
                    # "-full-screen"
                  ];
                };

                environment.systemPackages = builtins.concatLists (
                  map (pkgsList: import pkgsList { inherit pkgs; }) [
                    ./shared/lists/02_add.nix
                    ./shared/lists
                  ]
                );

                home-manager.users.${username} = {
                  imports = [
                    ./home
                    ./home/shell

                    ./home/gui/browser/chromium.nix
                  ];
                };

                users.users.${username}.initialPassword = "0";
              }
            )
          ];
        };
    in
    {
      nixosConfigurations."xiaomi-A35S-laptop-nixos" = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = mkSpecialArgs "evadev";
        modules = [
          ./hosts/xiaomi-A35S-laptop-nixos/configuration.nix

          ./modules/hardware/esp32.nix

          ./modules/nix-ld.nix
          ./modules/containers
          ./modules/silent-boot.nix
          ./modules/network.nix
          ./modules/swap.nix
          ./modules/java.nix
          ./modules/stylix.nix
          ./modules/security.nix
          ./modules/android.nix

          ./modules/desktop/manager/noctalia-niri.nix

          ./modules/gui/throne.nix

          ./modules/vm
          ./modules/vm/gui.nix

          {
            programs.nh.clean.enable = nixpkgs.lib.mkForce false;

            environment.systemPackages = with pkgs; [
              (callPackage ./packages/shdotenv.nix { })
            ];
          }
        ];
      };

      #? subsets of my desktop systems for testing purposes
      nixosConfigurations."coolvm-niri" = mkCoolVm "niri" "evadev" [
        ./hosts/vm/niri-paravirt.nix

        ./modules/desktop/manager/noctalia-niri.nix
      ];

      homeConfigurations = nixpkgs.lib.attrsets.mergeAttrsList [
        (mkHomeCfg "nixos" [
          ./shared/nix.nix
          ./shared/nh.nix

          ./home
          ./home/shell/minimal.nix
        ])
        (mkHomeCfg "nixd" [
          #! https://github.com/nix-community/nixd/issues/705#issuecomment-3103731843
          inputs.nixcord.homeModules.default
          inputs.niri.homeModules.niri
          inputs.noctalia.homeModules.default
        ])
      ];

      devShells.${system} = {
        python =
          let
            pythonPkg = pkgs.python313;
          in
          pkgs.mkShell {
            #? nix develop ~/config/nix#python
            packages = with pkgs; [
              (pythonPkg.withPackages (
                python-pkgs: with python-pkgs; [
                  uv
                  ruff
                ]
              ))
              hatch
            ];
            shellHook = ''
              echo "🐍 Welcome to the Python ${pythonPkg.version} devShell!"
              bash; exit
            '';
          };
        rust = pkgs.mkShell {
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          buildInputs = with pkgs; [
            cargo
            rustc
            rustfmt
            clippy
            rust-analyzer
          ];
          packages = with pkgs; [
            evcxr
          ];

          shellHook = ''
            echo "🦀 Welcome to the Rust ${with pkgs; rustc.version} devShell!"
            bash; exit
          '';
        };
      };
      packages.${system} =
        with pkgs;
        let
          flattenPkgs = lib.concatMapAttrs (
            name: v:
            if lib.isDerivation v then
              { ${name} = v; }
            else if lib.isAttrs v then
              flattenPkgs v
            else
              { }
          );
        in
        {
          #? nix {build,run} ./nix# <tab>

          default = self.packages.${system}.coolvm-niri;
          coolvm-niri = self.nixosConfigurations."coolvm-niri".config.system.build.vm;
        }
        // flattenPkgs (
          lib.filesystem.packagesFromDirectoryRecursive {
            inherit callPackage;
            directory = ./packages/auto;
          }
        );
      legacyPackages.${system} = with pkgs; {
        #! nix flake check: need to update patches everytime
        telegram-desktop-patched = callPackage ./packages/telegram-desktop-patched.nix { };
      };
      formatter.${system} = with pkgs; nixfmt-tree;
    };
}
