{
  # =================================================================
  # LATER: SECURE BOOT (lanzaboote) - kept commented until you set it up.
  # Enabling this and enrolling Secure Boot keys CHANGES PCR 7, so you
  # must then RE-ENROLL the TPM2 slot against PCR 7 and RE-VERIFY the
  # unlock at reboot (see the "RE-ENROLL AGAINST PCR 7" command in
  # disko-config.nix). Requires adding the lanzaboote flake input.
  # =================================================================
  # boot.loader.systemd-boot.enable = lib.mkForce false; # lanzaboote replaces it
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  boot = {
    # --- REQUIRED for TPM2 auto-unlock -------------------------------
    # systemd stage-1 initrd is what actually talks to the TPM and honours
    # the `tpm2-device=auto` crypttab option that disko-config.nix sets on
    # the LUKS device. Without this, TPM unlock in initrd does NOT happen.
    initrd.systemd.enable = true;

    # The TPM kernel driver is normally auto-detected. Uncomment only if
    # early boot cannot find the chip.
    # initrd.availableKernelModules = [ "tpm_crb" "tpm_tis" ];

    #? NixOS param which enables root-shell when stage 1 fails
    kernelParams = [ "boot.shell_on_fail" ];

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };
}
