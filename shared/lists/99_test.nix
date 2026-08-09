{ pkgs }:
#? packages I want to test before adding
with pkgs;
[
  #! new base
  dive

  #! networking tools
  iperf
  tcpdump

  #! new other
  shfmt
  iotop
  fatrace # sudo fatrace . 2>&1 | grep firefox

  devenv
  devbox

  imhex

  lnav
  lazyjournal
]
