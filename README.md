# config

### [packages](./packages/README.md)

## [Linux](./linux/README.md)

## cross-platform

[nix code to fill](home/default.nix#:~:text=%23%20%7D;-,userName):

```shell
mkdir -p ~/.config/git/
nix eval --impure --raw --expr '
  with import <nixpkgs> {};
  lib.generators.toGitINI
    ((builtins.getFlake "github:nikelborm/barsik-config")
      .nixosConfigurations.xiaomi-A35S-laptop-nixos.config.home-manager.users.evadev.programs.git.iniContent)
' > ~/.config/git/config
```


modular Nix configurations for desktops, servers, virtual machines, mobile devices, and custom packages

## [packages](./packages/README.md)

## [command cheatsheet](./cheatsheet.md)

## installation

```shell
cd
mkdir -p ~/projects
git clone --branch=cleanup https://github.com/nikelborm/barsik-config.git ./projects/barsik-config
cd ~/projects/barsik-config
sudo nixos-rebuild switch --flake .
home-manager switch --flake .
```

### nix itself

#### [Nix install](https://zero-to-nix.com/start/install/) speedrun on existing system

- TLDR
  - `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
    - enable systemd if wsl
    - alt installer `curl --proto '=https' --tlsv1.2 -sSf -L https://artifacts.nixos.org/experimental-installer | sh -s -- install`
  - [offline install](https://github.com/DeterminateSystems/nix-installer/releases/latest/download/nix-installer-x86_64-linux)

## config reference

### [vscode](.config/Code/User/)

- extensions manager script: `./nix/.config/Code/User/extensions-manager.sh`
  - shows diff between extensions in `code` and defined in `extensions.nix`

## imperative

- Throne (formerly known as nekoray/nekobox)
  - Routing -> Routing settings -> DNS -> Direct DNS: `8.8.8.8`
