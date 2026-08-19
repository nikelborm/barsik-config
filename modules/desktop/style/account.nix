{ pkgs, username, ... }:
#? https://github.com/nix-community/nur-combined/blob/301a494ecb37bafb1a31d588844c7999b90c5821/repos/mich-adams/modules/user-icon.nix
let
  userIcon = pkgs.fetchurl {
    url = "https://github.com/nikelborm.png";
    sha256 = "sha256-5jRogm8nF3wGjfY7Wb652iAYLNUEggf4WTVAKcdpxS4=";
  };
in
{
  systemd.tmpfiles.rules = [
    #? notice the "\\n" we don't want nix to insert a new line in our string, just pass it as \n to systemd
    "f+ /var/lib/AccountsService/users/${username} - - - - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\n"
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${userIcon}"
    #? for noctalia
    "L+ /home/${username}/.face - ${username} users - ${userIcon}"
  ];
}
