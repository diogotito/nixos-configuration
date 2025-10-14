{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable KDE!
  services.xserver.enable = true;

  services.displayManager = {
    enable = true;

    # Avoid Wayland for now :(
    defaultSession = "plasmax11";

    # for KDE
    sddm = {
      enable = true;
      wayland.enable = false;
      autoNumlock = true;
    };

    # without KDE
    # ly.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    # KDE
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kclock
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    kdePackages.filelight
    kdePackages.kompare
    kdePackages.ghostwriter
    kdePackages.yakuake
    kdePackages.merkuro
    # kdiff3
    twilight-kde

    # Firefox integration
    kdePackages.plasma-browser-integration
  ];

  programs.firefox.nativeMessagingHosts.packages = [
    pkgs.kdePackages.plasma-browser-integration
  ];
}
