{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Wayland stuff
    fuzzel
    gammastep
    mako
    swaybg
    swayidle
    swaylock
    waybar
    wayland-utils
    wireplumber
    wl-clipboard
    wlsunset
    xwayland-satellite
  ];

  programs = {
    niri.enable = true;
    waybar.enable = false; # I'll launch it in Niri config
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.gnome = {
    gnome-keyring.enable = true; # secret service
    sushi.enable = true;
  };

  security.pam.services.swaylock = {};
}
