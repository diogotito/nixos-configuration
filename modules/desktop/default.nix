{...}: {
  imports = [
    ./kde-plasma6-x11.nix
    ./apps.nix

    # Wayland is out for now...
    # ./wayland-compositor.nix
  ];

  # Base stuff
  security.polkit.enable = true; # polkit

  # Flatpak
  services.flatpak.enable = true;
}
