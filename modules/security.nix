{ self, pkgs, ... }:
{
  #? SSH agent is provided by the GnuPG agent (programs.gnupg.agent.enableSSHSupport)
  #? or the desktop keyring (gcr-ssh-agent); programs.ssh.startAgent conflicts
  #? with both in current nixpkgs.

  security.polkit = {
    enable = true;
    # debug = true;
    extraConfig = /* javascript */ ''
      /* Allow members of the wheel group to execute the defined actions
       * without password authentication, similar to "sudo NOPASSWD:"
       */
      polkit.addRule(function(action, subject) {
          if ((
              action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
              action.id == "org.freedesktop.udisks2.encrypted-unlock-system"
          ) && subject.isInGroup("wheel"))
          {
              return polkit.Result.YES;
          }
      });
    '';
  };

  environment.systemPackages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.keepassxc
  ];
}
