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

    # Desktop utilities
    hardinfo2

    # Gaming
    prismlauncher # Minecraft
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
