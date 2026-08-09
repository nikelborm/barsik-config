{
  dock = [
    # TODO: eva: set proper name here
    "org.nautilus"

    "firefox"
    # "brave"

    "code"
    # TODO: eva: put proper telegram here

    "discord"
    # "vesktop"
    # "dorion"

    "obsidian"
    "thunderbird"
  ];
  shortcuts = [
    #? name is alphanumeric and -
    {
      name = "Open Launcher";
      command = "vicinae toggle";
      keys = "Mod+S";
    }
    {
      name = "Open PID of Focused Window in btop";
      command = "inspect-window";
      keys = "Mod+Ctrl+Grave"; # ? `
    }

    #? powertoys
    {
      name = "Capture Screen Region then Extract Text with OCR";
      command = "ocr-screen-region";
      keys = "Mod+Shift+T";
    }
    {
      name = "Open Color Picker";
      command = "hyprpicker --autocopy --notify";
      keys = "Mod+Shift+C";
    }
  ];
}
