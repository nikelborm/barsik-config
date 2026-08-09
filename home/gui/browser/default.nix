{ lib, ... }:
{
  imports = [
    ./chromium.nix
  ];

  #? handlr ships no .desktop file
  xdg.desktopEntries.handlr = {
    name = "handlr - URL Handler";
    exec = "handlr open %u";
    icon = "internet-web-browser";
    terminal = false;
    noDisplay = true;
    mimeType = [
      "x-scheme-handler/chrome"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };
  xdg.configFile."handlr/handlr.toml".text = lib.mkAfter /* toml */ ''
    [[handlers]]
    # TODO: eva: change to chrome properly?
    exec = "chrome %u"
    regexes = ['.*']
  '';

  xdg.mimeApps =
    let
      browsers = [
        # TODO: eva: change to chrome properly?
        "chrome.desktop"
      ];
      mappedDefaults =
        lib.genAttrs [
          # "x-scheme-handler/about"
          # "x-scheme-handler/unknown"
          "application/pdf"
          "application/x-extension-htm"
          "application/x-extension-html"
          "application/x-extension-shtml"
          "application/x-extension-xht"
          "application/x-extension-xhtml"
          "application/xhtml+xml"
          "text/html"
        ] (key: browsers)
        // lib.genAttrs [
          "x-scheme-handler/chrome"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ] (key: [ "handlr.desktop" ] ++ browsers);
    in
    {
      defaultApplications = mappedDefaults;
      associations.added = mappedDefaults;
    };
}
