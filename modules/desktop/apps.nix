{
  pkgs,
  unstablePkgs,
  ...
}: {
  environment.systemPackages = with unstablePkgs; [
    # Terminals
    alacritty
    ghostty
    wezterm

    # Desktop terminal utilities
    zenity
    libnotify

    # Chat
    discord
    telegram-desktop

    # Code editors
    vscodium.fhs # vscode.fhs
    unstablePkgs.sublime4

    # Dev tools
    gg-jj

    # Art / Game dev
    aseprite
    blender
    gimp3 # -with-plugins ??
    pinta
    krita
    krita-plugin-gmic
    godotPackages_4_5.export-templates-bin
    godotPackages_4_5.godot

    # Multimedia stuff
    audacity
    mpv
    yt-dlp

    # Desktop utilities
    hardinfo2
    qalculate-qt  # Maybe prefer qalculate-gtk if I'm on Gnome or something?

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
    protonup # to install proton GE with `protonup`
    mangohud # An overlay to monitor FPS, GPU load, etc.
    lutris
    vulkan-tools
    # heroic - frontend for Epic and GOG
    # bottles - Wine prefix manager

    # Games
    prismlauncher # Minecraft
    vintagestory
  ];

  # With this, I can prepend `gamemoderun/mangohud/gamescope %command%` to the LAUNCH OPTIONS on Steam
  programs.gamemode.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.sessionVariables = {
    # protonup -d "~/.steam/root/compatibilitytools.d/"
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/diogo/.steam/root/compatibilitytools.d";
  };

  # Firefox
  programs.firefox = {
    enable = true;
    # package = ...
    # preferences = { ... }
    # preferencesStatus = "user"
    # ...
  };

  # OBS Studio
  programs.obs-studio = {
    enable = true;

    # Nvidia hardware acceleration
    package = pkgs.obs-studio.override {cudaSupport = true;};

    # Configure v4l2loopback kernel module
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
      droidcam-obs
    ];
  };
}
