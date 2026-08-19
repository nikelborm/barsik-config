{
  lib,
  config,
  flakePath,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      alias = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      user.name = "nikelborm";
      user.email = "evadev@duck.com";
      core.autocrlf = "input";
      core.ignoreCase = "false";

      init.defaultBranch = "master";

      push.default = "current";

      pull.rebase = "true";

      merge.autoStash = "true";

      rebase.autoStash = "true";

      gpg.format = "ssh";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    signing.key = "key::${
      lib.strings.removeSuffix "\n" (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://github.com/nikelborm.keys";
            sha256 = "sha256-BYYaWKaZjNI0XxWXnthsfS/WxrGEs60awBFH3lNxvvE=";
          }
        )
      )
    }";
    signing.signByDefault = true;
  };
  xdg.configFile."git/ignore".source =
    config.lib.file.mkOutOfStoreSymlink "${flakePath}/.config/git/ignore";
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
}
