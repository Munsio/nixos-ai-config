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

  # Enable NixOS modules using nixModules
  nixModules = {
    # Enable features
    cli-tools = true;

    # Enable bundles
    bundles.development = true;

    # Enable services
    services.ssh = true;
  };

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
}
