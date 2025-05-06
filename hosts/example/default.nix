{ pkgs, hostname, ... }:

{
  # Host-specific configuration for 'example'
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Replace this one with your hardware-configuration.nix, but it is required to build and test this configuraiton.
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
}
