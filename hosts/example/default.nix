{ pkgs, hostname, ... }:

{
  # Host-specific configuration for 'example'
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Root filesystem configuration
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Enable NixOS modules using nixModules
  nixModules = {
    # Enable features
    cli-tools = false;
    systemd-boot = true;

    # Enable bundles
    bundles.development = false;
    bundles.automount = true;

    # Enable services
    services.ssh = false;
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
