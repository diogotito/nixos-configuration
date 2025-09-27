#-----------------------------------------------------------------------------
# configuration.nix - The "entry point" for this flake's NixOS configuration.
#-----------------------------------------------------------------------------
# This module imports all others and configures:
#
#   - base linux system stuff
#       - kernel, bootloader, hostname, timezone, locale...
#
#   - base nix/nixpkgs stuff
#       - allowUnfree, repo pin, auto update and gc...
#
# Docs: nixos-help, configuration.nix(4)
#-----------------------------------------------------------------------------
{
  pkgs,
  /*
  config, inputs,
  */
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # My modules
    ./modules/hardware-desktop.nix
    ./modules/desktop
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # This machine's hostname
  # NOTE: If this matches what's in nixosConfigurations in flake.nix,
  # the command to rebuild this config becomes more convenient:
  #     # nixos-rebuild switch --flake .  # No #configName needed!
  # (Even more so if this flake can be found in /etc/nixos/)
  networking.hostName = "nixos-desktop";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diogo = {
    isNormalUser = true;
    description = "Diogo Marques";
    extraGroups = ["networkmanager" "wheel" "ddc"];
    shell = pkgs.fish;

    # -----------
    # My programs
    # -----------

    packages = with pkgs; [
      # Terminal utilities for using linux
      ffmpeg-full
      microfetch
      ranger

      # Terminal utilities for dev stuff
      fzf
      gh
      jq
      jqp # TUI playground to experiment with jq
      jujutsu
      mise
      watchexec
      zola

      # for specific projects
      # (to be moved to a nix file when I learn to write those)
      # sdcc

      # RIIR
      atuin
      bat
      bottom # htop in Rust
      delta
      dfc
      difftastic
      dust
      eza
      fd
      hexyl
      hyperfine
      igrep
      jless
      md-tui
      nushell
      procs
      ripgrep
      sd
      skim # fzf in Rust
      tealdeer
      tokei

      # More cool utilites
      mpv
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    tmux
    w3m
    htop
    nautilus
    killall

    # Nicer nix
    nix-output-monitor # nom - Processes output of Nix commands to show helpful and pretty information
    nox # Tools to make nix nicer to use
    alejandra # Uncompromising Nix Code Formatter
    nil # Yet another language server for Nix
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs = {
    niri.enable = true;
    waybar.enable = false; # I'll launch it in Niri config
    fish.enable = true;
    starship = {
      enable = true;
      transientPrompt = {
        enable = true;
        # left = "starship module character"
        # right = "starship module time"
      };
      settings = {};
    };
    yazi = {
      enable = true;
      settings = {};
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    source-code-pro
    nerd-fonts.iosevka
    nerd-fonts.terminess-ttf
    nerd-fonts.meslo-lg
    nerd-fonts.hack
    nerd-fonts.inconsolata
    nerd-fonts.fira-code
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # --------------------
  # Nix / NixOS settings
  # --------------------
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
