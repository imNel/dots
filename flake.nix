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
                      device = "/dev/disk/by-uuid/af010a4c-7cf4-4ae0-85b7-08944b727617";
                      fsType = "ext4";
                    };

                    fileSystems."/boot" = {
                      device = "/dev/disk/by-uuid/9E06-3295";
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
                    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
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
                  python39Full
                ];
              };
            # NixOS specific configuration
            linux =
              { pkgs, ... }:
              {
                boot = {
                  loader.systemd-boot.enable = true;
                  loader.efi.canTouchEfiVariables = true;
                };

                networking.networkmanager.enable = true;

                # locale
                time.timeZone = "Australia/Perth";
                i18n.defaultLocale = "en_AU.UTF-8";

                # Enable the sway window manager.
                programs.sway = {
                  enable = true;
                  package = pkgs.swayfx;
                  xwayland.enable = true;
                  wrapperFeatures.gtk = true;
                  extraPackages = with pkgs; [
                    mako
                    wl-clipboard
                    swaylock
                    swayidle
                    wmenu
                    swaybg
                  ];
                };
                security.polkit.enable = true;
                services.gnome.gnome-keyring.enable = true;

                # KDE
                services.xserver.enable = true;
                services.displayManager.sddm.enable = true;
                services.displayManager.sddm.wayland.enable = true;
                services.desktopManager.plasma6.enable = true;
                # services.displayManager.defaultSession = "sway";

                # Enable CUPS to print documents.
                services.printing.enable = true;

                hardware.firmware = [ pkgs.rtl8761b-firmware ];

                # Enable sound with pipewire.
                services.pipewire = {
                  enable = true;
                  alsa.enable = true;
                  pulse.enable = true;
                };

                users.users.${myUserName} = {
                  isNormalUser = true;
                  extraGroups = [
                    "networkmanager"
                    "wheel"
                    "audio"
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

                hardware.bluetooth = {
                  enable = true;
                };

                systemd.user.services.mpris-proxy = {
                  description = "Mpris proxy";
                  after = [
                    "network.target"
                    "sound.target"
                  ];
                  wantedBy = [ "default.target" ];
                  serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
                };

                environment.systemPackages = with pkgs; [
                  (import ./steam/switch-to-desktop.nix { inherit pkgs; })
                  pavucontrol
                  xfce.thunar
                  unzip
                  wdisplays
                ];

                # decky user
                users.users.decky = {
                  group = "decky";
                  home = "/var/lib/decky-loader";
                  isSystemUser = true;
                };
                users.groups.decky = { };
                # decky service
                systemd.services.decky-loader = {
                  description = "Steam Deck Plugin Loader";

                  wantedBy = [ "multi-user.target" ];
                  after = [ "network.target" ];

                  environment = {
                    UNPRIVILEGED_USER = "decky";
                    UNPRIVILEGED_PATH = "/var/lib/decky-loader";
                    PLUGIN_PATH = "/var/lib/decky-loader/plugins";
                  };

                  path = [ ];

                  preStart = ''
                    mkdir -p "/var/lib/decky-loader"
                    chown -R "decky:decky" "/var/lib/decky-loader"
                  '';

                  serviceConfig = {
                    ExecStart = "${(import ./steam/decky-loader.nix { inherit pkgs; })}/bin/decky-loader";
                    KillMode = "process";
                    TimeoutStopSec = 45;
                  };
                };
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
