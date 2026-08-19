{
  lib,
  pkgs,
  config,
  inputs,
  username,
  ...
}:
{
  networking.hostName = "xiaomi-A35S-laptop-nixos";

  environment.systemPackages = builtins.concatLists (
    map (pkgsList: import pkgsList { inherit pkgs; }) [
      ../../shared/lists
      ../../shared/lists/10_extra.nix
      ../../shared/lists/99_test.nix
    ]
  );

  #! modules here are bound to specific hardware features (including disks)
  imports = [
    ../extra.nix
    ./hardware-configuration.nix

    inputs.disko.nixosModules.disko
    ./disko-config.nix

    ../../modules/systemd-boot.nix

    ../../modules/hardware/fingerprint.nix
  ];
  home-manager.users.${username} = ./home.nix;

  # TPM2 userland on the running system, needed to run the one-time
  # `systemd-cryptenroll --tpm2-device=auto ...` enrollment.
  security.tpm2.enable = true;

  services.libinput.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # environment.systemPackages = with pkgs; [
  #   bun
  #   nodejs
  #   deno
  #   tree
  #   micro-with-wl-clipboard
  #   wget
  #   anytype
  #   throne
  #   btrfs-assistant
  #   btrfs-progs
  #   gimp
  #   meld
  #   git
  #   curl
  #   zip
  #   unzip
  #   fd
  #   eza
  #   croc
  #   lsof
  #   mosh
  #   tmux
  #   rsync
  #   zellij
  #   starship
  #   fastfetch
  #   systemctl-tui
  #   lazygit
  #   lazydocker
  #   _7zz-rar
  #   gh
  #   gcc
  #   git-lfs
  #   isd
  #   file
  #   tlrc
  #   aria2
  #   unrar
  #   yq-go
  #   yt-dlp
  #   hadolint
  #   pciutils
  #   usbutils
  #   qrencode
  #   ffmpeg-full
  #   strace
  #   inotify-tools
  #   psmisc
  #   lazysql
  #   pgcli
  #   litecli
  #   scrcpy
  #   fsearch
  #   obsidian
  #   libffi
  #   jq
  #   bat
  #   duf
  #   gdu
  #   fzf
  #   btop
  #   zoxide
  #   ripgrep
  #   nmap
  #   iperf
  #   tcpdump
  #   shfmt
  #   iotop
  #   fatrace
  #   devenv
  #   devbox
  #   lazyjournal
  #   nurl
  #   nix-tree
  #   hydra-check
  #   nix-output-monitor
  #   nixd
  #   nixfmt
  #   ncurses
  #   net-tools
  #   gawk
  #   procps
  #   gnused
  #   gnugrep
  #   openssh
  #   iproute2
  #   iputils
  #   inetutils
  #   diffutils
  #   findutils
  #   netcat-openbsd
  #   gparted-full
  #   htop
  #   btop-rocm
  #   recordbox
  #   noctalia-shell
  #   fuzzel
  #   swaylock
  #   transmission-gtk
  #   niri
  #   imhex
  #   kitty
  # ];

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${config.programs.niri.package}/bin/niri-session";
  #       user = "evadev";
  #     };
  #   };
  # };

  # Ensures environment PATH variables pass cleanly to user systemd services
  # systemd.user.services.niri.enableDefaultPath = false;

  # services.gnome.gnome-keyring.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Force Electron apps to use Wayland

  # TODO enable only maybe for virtual machine?
  services.openssh.enable = true;

  # The NixOS release FIRST installed with; do not bump casually.
  system.stateVersion = "26.05";

  hardware = {
    amdgpu.opencl.enable = true;
    bluetooth.enable = false;
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "20s";
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "15s";

  # TODO: laptop specific
  #? default governor, same for the balanced profile
  powerManagement.cpuFreqGovernor = "schedutil";

  #? https://wiki.nixos.org/wiki/Linux_kernel#Enable_SysRq
  #? it have same security level as having force-reset power-button
  boot.kernel.sysctl."kernel.sysrq" = true;
}
