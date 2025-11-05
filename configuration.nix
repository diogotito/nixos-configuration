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
  # unstablePkgs,
  # config
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
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Use the LTS kernel because of Nvidia.
    # Alternatively: pkgs.linuxPackages_latest,  unstablePkgs.linuxPackages_zen

    # kernelPackages = # uses LTS by default
    # extraModulePackages = with config.boot.kernelPackages; [ ];

    kernel.sysctl."kernel.sysrq" = 1;
  };

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

  # Run non-NixOS executables more easily
  programs.nix-ld.enable = true;

  # Run AppImages out of the box
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diogo = {
    isNormalUser = true;
    description = "Diogo Marques";
    extraGroups = ["networkmanager" "wheel" "ddc" "docker"];
    shell = pkgs.fish;

    # -----------
    # My programs
    # -----------

    packages = with pkgs; [
      # Terminal utilities for using linux
      dialog
      ffmpeg-full
      microfetch
      ranger
      libqalculate

      # Terminal utilities for dev stuff
      delta
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
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  programs = {
    # Shell
    fish = {
      enable = true;
    };
    starship = {
      enable = false; # I'm finding that I prefer fish's default prompt as it is in NixOS
      transientPrompt = {
        enable = true;
        # left = "starship module character"
        # right = "starship module time"
      };
      settings = {};
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    yazi = {
      enable = true;
      settings = {};
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      prompt.enable = true;

      package = pkgs.git.override {withLibsecret = true;}; # !! Rebuilds Git from source !!
      config = {
        credential.helper = "libsecret";

        # Delta
        core.pager = "delta";
        interactive.diffFilter = "delta";
        delta = {
          navigate = true;
          light = false;
          side-by-side = false;
        };

        # Git forges
        user.name = "diogotito";
        user.email = "diogotitomarques@gmail.com";
        init.defaultBranch = "main";
        url."https://github.com/".insteadOf = ["gh:" "github:"];

        # QoL stuff
        # https://blog.gitbutler.com/how-git-core-devs-configure-git
        push.autoSetupRemote = true;
        pull = {
          ff = "only";
          # rebase = true;
        };
        fetch = {
          all = true;
          prune = true;
          pruneTags = true;
        };
        merge.conflictstyle = "zdiff3";
        rebase = {
          autosquash = true;
          autostash = true;
          updateRefs = true;
        };
        diff = {
          renames = true;
          colorMoved = "default";
          algorithm = "histogram";
          mnemonicPrefix = true; # "i/", "w/" or "c/" instead of "a/" and "b/"
          # colorMovedWS = "default";
          # wsErrorHighlight = "all";  # idk if this will conflict with git-delta
        };
        commit.verbose = true;
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        column.ui = "auto";
        branch.sort = "committerdate";
        tag.sort = "version:refname";
        color.ui = true;
        grep.patternType = "perl";

        # gui.fontdiff = "-family \"Inconsolata Nerd Font\" -size 12 -weight normal -slant roman -underline 0 -overstrike 0";
        alias = {
          st = "status";
          lga = "log --all --oneline --graph --decorate";
        };
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    source-sans-pro
    open-sans
    inter
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

  # Docker
  virtualisation.docker = {
    enable = true;
  };

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
    "pipe-operators" # handy in the REPL for now
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
