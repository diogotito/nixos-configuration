{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Terminals
    alacritty
    ghostty
    wezterm

    # Chat
    discord
    telegram-desktop

    # Code editors
    vscodium.fhs # vscode.fhs

    # Art / Game dev
    aseprite
    blender
    gimp3 # -with-plugins ??
    krita
    krita-plugin-gmic
    godotPackages_4_5.export-templates-bin
    godotPackages_4_5.godot

    # Multimedia stuff
    mpv
    yt-dlp

    # Desktop utilities
    hardinfo2

    # Productivity
    calligra
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_PT

    # Password manager
    bitwarden-desktop
    bitwarden-cli

    # Gaming
    prismlauncher # Minecraft
    vintagestory
  ];

  # Firefox
  programs.firefox = {
    enable = true;
    # package = ...
    # preferences = { ... }
    # preferencesStatus = "user"
    # ...
  };
}
