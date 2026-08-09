# [worst Nix/OS packages ever](../README.md)

```shell
# generic usage of autocompletion with your system nixpkgs
nix run --override-input nixpkgs nixpkgs github:nikelborm/barsik-config# <tab>
```

## coolvm example for non NixOS

user passwd is `0`

```shell
nix --extra-experimental-features "nix-command flakes" run --impure 'github:nix-community/nixGL' -- nix --extra-experimental-features "nix-command flakes pipe-operators" run --impure --override-input nixpkgs nixpkgs 'github:nikelborm/barsik-config'
```

- on WSL Ubuntu disable pipewire QEMU section and launch with pulseaudio
  - `-audiodev pa,id=snd0,server=/mnt/wslg/PulseServer -device intel-hda -device hda-output,audiodev=snd0`
