{
  lib,
  pkgs,
  flakePath,
}:
{
  baseAliases = {
    #? https://askubuntu.com/a/22043
    #? https://superuser.com/a/1655578
    sudo = "sudo ";
    sudoe = "sudo env PATH=$PATH ";
    editor = "micro";
    grep = "grep --color=auto";
    grp = "grep -Fin -C 7";
    c = "clear";
    h = "history";
    hf = "h | grp";
    ls = "ls --group-directories-first --color=auto --hyperlink";
    lls = ''\command ls'';
    l = "ls -CFbh";
    ll = "ls -laFbgh";
    sshe = "editor ~/.ssh/config";
    cu = "cd ${flakePath} && git pull && cd -";
    diff = "diff --color";
    cpr = "rsync --verbose --archive --compress --partial --progress --mkpath";
    #? https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/
    open-ports = "sudo lsof -i -P -n | grep LISTEN";
    open-ports-netstat = "netstat --listening";
  };
  networkTestAliases = {
    "1ip" = "wget -qO - icanhazip.com";
    "2ip" = "curl 2ip.ru";
    "3ip" = "curl -so- ipinfo.io | jq";
    "4ip" = "curl -so- wtfismyip.com/json | jq";
    speedtest = "curl https://speedtest.selectel.ru/100MB --output /dev/null";
    speedtest-as-youtube = "curl --insecure --connect-to ::speedtest.selectel.ru https://www.youtube.com/100MB --output /dev/null";
  };
  dockerAliases = {
    lzd = "lazydocker";
    dsp = "docker system prune";
    dspa = "dsp --all";
    dc = "docker compose";
    dcu = "dc up -d";
    dcub = "dcu --build";
    dcuo = "dcu --remove-orphans";
    dcup = "dc -f compose.prod.yaml up -d";
    dcp = "dc ps";
    dcs = "dc stop";
    dcd = "dc down";
    dcl = "dc logs";
    dcr = "dc restart";
    dce = "dc exec -it";
  };
  # TODO: non ported
  pythonAliases = {
    pipi = "uv pip install -r requirements.txt || uv pip install -r pyproject.toml";
    pyvcr = "uv venv --allow-existing && source .venv/bin/activate && pipi";
    pyv = "source .venv/bin/activate || pyvcr";
    pyt = "ptpython";
    pyta = "pyt --asyncio";
  };
  otherAliases = {
    st = "systemctl-tui";
    sst = "sudo systemctl-tui";
    lzg = "lazygit";
    yt-dlpa = "yt-dlp --concurrent-fragments=16 --retries=inf";
    aria2ca = "aria2c --split=16 --max-connection-per-server=16 --continue";
  };
  ezaAliases = {
    l = "eza -F -bghM --smart-group --group-directories-first --color-scale --icons=always --no-quotes --hyperlink=auto";
    ll = "eza -F -labghM --smart-group --group-directories-first --color-scale --icons=always --no-quotes --hyperlink=auto";
    llt = "ll --tree";
  };
  journalCtlAliases = {
    jctl = "journalctl";
    jctlb = "jctl --boot=0";
    jctld = "jctlb --dmesg";
    jctlf = "jctl --follow";
  };
  nixAliases = {
    iusenixbtw = "fastfetch";
    nu = "nix flake update --flake ${flakePath}";
    nuu = "nix flake update nixpkgs --override-input nixpkgs nixpkgs/$(nixos-version --hash)";
    n = "nh home switch ${flakePath}";
    nn = "nh os switch ${flakePath} --keep-going";
    nd = "nh clean all";
    nr = "nix repl --file ${flakePath}/repl.nix";
    nrr = "nh home repl ${flakePath}";
    nrrr = "nixos-rebuild repl --flake ${flakePath}";
    ne = "editor ${flakePath}";
    ndiff = "${lib.getExe pkgs.nvd} diff ~/.local/state/nix/profiles/$(command ls -t ~/.local/state/nix/profiles | fzf) ~/.local/state/nix/profiles/home-manager";
    nndiff = "${lib.getExe pkgs.nvd} diff /nix/var/nix/profiles/$(command ls -t /nix/var/nix/profiles/ | fzf) /nix/var/nix/profiles/system";
    ns = "nix-shell -p";
    nss = "nix_shell_exec";
    ncode = "code --reuse-window $(nix eval --offline --file '<nixpkgs>' path)/pkgs/top-level/all-packages.nix";
  };
  sharedAliases = lib.attrsets.mergeAttrsList [
    baseAliases
    networkTestAliases
    dockerAliases
    pythonAliases
    otherAliases
    ezaAliases
    journalCtlAliases
  ];
  bashAliases = {
    "?" = "type_colored_and_nix_truncate";
    "??" = "type_colored";
    # TODO: eva: with micro properly
    history-cat = "micro -R +'set filetype=bash' ~/.config/bash/.bash_history";
    history-edit = "code --reuse-window ~/.config/bash/.bash_history";
  };
}
