#-----------------------------------------------------------------------------
# modules/hardware-desktop.nix - All hardware related base configuration
#-----------------------------------------------------------------------------
#
# What's in here:
#
#   - Audio
#   - Graphics card
#   - Mouse
#   - Bluetooth
#   - DDC monitor control
#
# (This should probably be split into different files, one for each section.
# But I want to keep everything hardware-related co-located in this file.
# As a compromise, to enable multiple environment.systemPackages definitions
# and to ease splitting each section into a module file in the near future,
# I'm writing each part as a module-like function)
#
#-----------------------------------------------------------------------------
{...}: let
  #-------
  # Audio
  #-------
  audio = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.pasystray
      pkgs.pavucontrol
      pkgs.ncpamixer
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true; # If you want to use JACK applications, uncomment this
      # extraConfig = ...   # can be used to create drop-in configuration files, if needed
      # wireplumber.extraConfig...  # to configure WirePlumber directly
    };

    security.rtkit.enable = true; # recomended in PipeWire wiki page
  };

  #-----------------------------
  # The cursed graphics card...
  #-----------------------------

  nvidia = {
    pkgs,
    config,
    ...
  }: {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;

        powerManagement.enable = true; # Enable if applications keep crashing on resume. Sleep might fail though.
        powerManagement.finegrained = false;

        open = true; # open-source kernel MODULE, not to be confused with the independent noveau DRIVER. Should be true.

        nvidiaSettings = true;

        # package = config.boot.kernelPackages.nvidiaPackages.stable; # doesn't compile with open = true
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "580.65.06";
          sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
          openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
          settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
          usePersistenced = false;
        };
      };
    };
  };

  #----------------------------------
  # Logitech mouse with many buttons
  #----------------------------------

  mouse = {pkgs, ...}: {
    services.ratbagd.enable = true;

    environment.systemPackages = [
      pkgs.piper # UI to reprogram buttons in the onboard memory
    ];
  };

  #-----------
  # Bluetooth
  #-----------

  bluetooth = {pkgs, ...}: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # to show battery
          FastConnectable = true; # Devices can connect faster to us
        };
        Policy = {
          AutoEnable = true; # Enable all controllers when they are found
        };
      };
    };

    # TODO turn this into a module option "usingFancyDesktopManager"
    services.blueman.enable = false; # Reenable if switching out of KDE or Gnome 3

    environment.systemPackages = [
      pkgs.bluetuith
    ];
  };

  #--------------------------
  # Monitor control with DDC
  #--------------------------

  ddc = {pkgs, ...}: {
    services.ddccontrol.enable = true;

    # Install ddcutils
    environment.systemPackages = [
      pkgs.ddcutil
      pkgs.ddcui
    ];

    # Make ddcutils work without sudo
    services.udev.extraRules = builtins.concatStringsSep ", " [
      ''KERNEL=="i2c-[0-9]*"''
      ''GROUP="ddc"''
      ''MODE="0660"''
      ''PROGRAM="${pkgs.ddcutil}/bin/ddcutil --bus=%n getvcp 0x10"''
    ];
    users.groups.ddc = {};
  };
in {
  imports = [
    audio
    nvidia
    mouse
    bluetooth
    ddc
  ];
}
# https://discourse.nixos.org/t/several-environment-systempackages-in-configuration-nix/39226/3
# lib.mkMerge (map (moduleLike: moduleLike {inherit pkgs config;}) [
# This was unnecessary and is less maintainable.
# using { imports = } is a lot better for reasons.

