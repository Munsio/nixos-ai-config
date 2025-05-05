{ pkgs, hostname, ... }:

{
  # Host-specific configuration for 'example'
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Hardware configuration
  boot = {
    # Example boot loader configuration
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Example kernel parameters
    kernelParams = [ "quiet" ];
  };

  # Set console keymap
  console.keyMap = "us";

  # Root filesystem configuration
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Import NixOS modules
  imports = [
    ../../modules/features/example.nix
    ../../modules/bundles/example/default.nix
  ];

  # Home-manager configuration for all users on this host
  home-manager.sharedModules = [
    # This module will be imported for all users on this host
    ({ pkgs, ... }: {
      # Import home-manager modules
      imports = [
        ../../home-modules/features/example.nix
        ../../home-modules/bundles/example/default.nix
      ];

      # Common home-manager configuration for all users on this host
      home.packages = with pkgs; [ firefox ripgrep ];
    })
  ];

  # System-specific packages
  environment.systemPackages = with pkgs;
    [
      # Add host-specific packages here
    ];

  # Enable specific services for this host
  services = {
    # Example: Enable CUPS for printing
    printing.enable = true;

    # Example: Enable sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  # Hardware-specific settings
  hardware = {
    # Example: Enable bluetooth
    bluetooth.enable = true;

    # Example: Enable graphics
    graphics.enable = true;
  };

  # User configuration
  users.users.example-user = {
    isNormalUser = true;
    description = "Example User";
    extraGroups = [ "wheel" "networkmanager" ];
    group = "example-user";
  };

  # Create a group for the user
  users.groups.example-user = { };
}
