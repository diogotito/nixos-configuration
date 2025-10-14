{pkgs, ...}: {
  imports = [
    ./kde-plasma6-x11.nix
    ./apps.nix

    # Wayland is out for now...
    # ./wayland-compositor.nix
  ];

  # Base stuff
  security.polkit.enable = true; # polkit

  # Fallback icons?
  environment.systemPackages = [
    pkgs.adwaita-icon-theme
  ];

  # Flatpak
  services.flatpak.enable = true;
}
