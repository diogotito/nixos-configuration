{ config, pkgs, inputs, ... }:

{
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

  services.gnome = {
    gnome-keyring.enable = true; # secret service
    sushi.enable = true;
  };

  security.pam.services.swaylock = {};

}
