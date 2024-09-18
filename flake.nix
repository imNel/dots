{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      imports = [
        inputs.nixos-flake.flakeModule
        ./home.nix
      ];

      flake =
        let
          myUserName = "nel";
        in
        {
          # Configurations for Linux (NixOS) machines
          nixosConfigurations = {
            nixos = self.nixos-flake.lib.mkLinuxSystem {
              nixpkgs.hostPlatform = "x86_64-linux";
              nix = {
                settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                extraOptions = ''
                  warn-dirty = false
                '';
              };
              imports = [
                self.nixosModules.common # See below for "nixosModules"!
                self.nixosModules.linux
                # Your machine's configuration.nix goes here
                (
                  {
                    config,
                    lib,
                    pkgs,
                    modulesPath,
                    ...
                  }:
                  {

                    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

                    boot.initrd.availableKernelModules = [
                      "xhci_pci"
                      "ahci"
                      "usb_storage"
                      "usbhid"
                      "sd_mod"
                    ];
                    boot.initrd.kernelModules = [ ];
                    boot.kernelModules = [ "kvm-amd" ];
                    boot.extraModulePackages = [ ];

                    fileSystems."/" = {
                      device = "/dev/disk/by-uuid/fc5ff8d1-192e-4f56-b890-3ea5e7140400";
                      fsType = "ext4";
                    };

                    fileSystems."/boot" = {
                      device = "/dev/disk/by-uuid/205A-77CE";
                      fsType = "vfat";
                      options = [
                        "fmask=0077"
                        "dmask=0077"
                      ];
                    };

                    swapDevices = [ ];

                    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
                    # (the default) this is the recommended approach. When using systemd-networkd it's
                    # still possible to use this option, but it's recommended to use it in conjunction
                    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
                    networking.useDHCP = lib.mkDefault true;
                    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

                    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
                    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
                    system.stateVersion = "24.05";
                  }
                )
                # Your home-manager configuration
                self.nixosModules.home-manager
                {
                  home-manager.users.${myUserName} = {
                    imports = [
                      self.homeModules.common
                      self.homeModules.linux
                    ];
                    home.stateVersion = "22.11";
                  };
                }
              ];
            };
          };

          # Configurations for macOS machines
          darwinConfigurations = {
            "Nels-MacBook-Pro-2" = self.nixos-flake.lib.mkMacosSystem {
              nixpkgs.hostPlatform = "aarch64-darwin";
              nix.extraOptions = ''
                warn-dirty = false
              '';
              homebrew = {
                enable = true;
                casks = [ "nikitabobko/tap/aerospace" ];
              };
              imports = [
                self.nixosModules.common # See below for "nixosModules"!
                self.nixosModules.darwin
                # Your machine's configuration.nix goes here
                (
                  { pkgs, ... }:
                  {
                    # Used for backwards compatibility, please read the changelog before changing.
                    # $ darwin-rebuild changelog
                    system.stateVersion = 4;
                    users.users.${myUserName}.home = "/Users/${myUserName}";
                  }
                )
                # Your home-manager configuration
                self.darwinModules_.home-manager
                {
                  home-manager.backupFileExtension = "backup";
                  home-manager.users.${myUserName} = {
                    imports = [
                      self.homeModules.common
                      self.homeModules.darwin
                    ];
                    home.stateVersion = "22.11";
                  };
                }
              ];
            };
          };

          # All nixos/nix-darwin configurations are kept here.
          nixosModules = {
            # Common nixos/nix-darwin configuration shared between Linux and macOS.
            common =
              { pkgs, ... }:
              {
                nixpkgs.config.allowUnfree = true;
                environment.systemPackages = with pkgs; [
                  neovim
                  gnumake
                  git
                  nixfmt-rfc-style
                  nodejs
                  cargo
                  rustc
                  gcc
                ];
              };
            # NixOS specific configuration
            linux =
              { pkgs, ... }:
              {
                boot = {
                  loader.systemd-boot.enable = true;
                  loader.efi.canTouchEfiVariables = true;

                  # Hide the OS choice for bootloaders.
                  # It's still possible to open the bootloader list by pressing any key
                  # It will just not appear on screen unless a key is pressed
                  loader.timeout = 0;

                  # Enable "Silent Boot"
                  consoleLogLevel = 0;
                  initrd.verbose = false;
                  kernelParams = [
                    "quiet"
                    "splash"
                    "boot.shell_on_fail"
                    "loglevel=3"
                    "rd.systemd.show_status=false"
                    "rd.udev.log_level=3"
                    "udev.log_priority=3"
                  ];

                  plymouth = {
                    enable = true;
                    theme = "lone";
                    themePackages = with pkgs; [
                      # By default we would install all themes
                      (adi1090x-plymouth-themes.override { selected_themes = [ "lone" ]; })
                    ];
                  };
                };

                networking.hostName = "nixos"; # Define your hostname.
                networking.networkmanager.enable = true;

                # locale
                time.timeZone = "Australia/Perth";
                i18n.defaultLocale = "en_AU.UTF-8";
                i18n.extraLocaleSettings = {
                  LC_ADDRESS = "en_AU.UTF-8";
                  LC_IDENTIFICATION = "en_AU.UTF-8";
                  LC_MEASUREMENT = "en_AU.UTF-8";
                  LC_MONETARY = "en_AU.UTF-8";
                  LC_NAME = "en_AU.UTF-8";
                  LC_NUMERIC = "en_AU.UTF-8";
                  LC_PAPER = "en_AU.UTF-8";
                  LC_TELEPHONE = "en_AU.UTF-8";
                  LC_TIME = "en_AU.UTF-8";
                };

                # Enable the X11 windowing system.
                services.xserver.enable = true;
                services.xserver.displayManager.gdm.enable = true;
                services.xserver.displayManager.defaultSession = "sway";

                # Enable the sway window manager.
                programs.sway = {
                  enable = true;
                  xwayland.enable = true;
                  wrapperFeatures.gtk = true;
                  extraPackages = with pkgs; [
                    mako
                    wl-clipboard
                    swaylock
                    swayidle
                    dmenu
                    wmenu
                  ];
                };
                services.gnome.gnome-keyring.enable = true;

                # Configure keymap in X11
                services.xserver.xkb = {
                  layout = "au";
                  variant = "";
                };

                # Enable CUPS to print documents.
                services.printing.enable = true;

                # Enable sound with pipewire.
                hardware.pulseaudio.enable = false;
                security.rtkit.enable = true;
                services.pipewire = {
                  enable = true;
                  alsa.enable = true;
                  alsa.support32Bit = true;
                  pulse.enable = true;
                  # If you want to use JACK applications, uncomment this
                  #jack.enable = true;

                  # use the example session manager (no others are packaged yet so this is enabled by default,
                  # no need to redefine it in your config for now)
                  #media-session.enable = true;
                };

                users.users.${myUserName} = {
                  isNormalUser = true;
                  extraGroups = [
                    "networkmanager"
                    "wheel"
                  ];
                  shell = pkgs.zsh;
                };

                programs.firefox.enable = true;
                programs.zsh.enable = true;

                # Steam
                programs.gamescope = {
                  enable = true;
                  capSysNice = true;
                };
                programs.steam = {
                  enable = true;
                  gamescopeSession.enable = true;
                  remotePlay.openFirewall = true;
                  dedicatedServer.openFirewall = true;
                  localNetworkGameTransfers.openFirewall = true;
                };
                hardware.xone.enable = true;
              };
            # nix-darwin specific configuration
            darwin =
              { pkgs, ... }:
              {
                security.pam.enableSudoTouchIdAuth = true;
                services.nix-daemon.enable = true;
                services.sketchybar = {
                  enable = true;
                };

                system.defaults.universalaccess.reduceMotion = true;
              };
          };
        };
    };
}
