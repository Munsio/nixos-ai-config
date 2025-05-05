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

  # Enable specific NixOS modules for this host
  nixModules = {
    # Enable feature modules (at root level)
    # example = true;

    # Enable bundle modules
    bundles = {
      # example = true;
    };

    # Enable service modules
    services = {
      # monitoring = true;
    };
  };

  # Home-manager configuration for all users on this host
  home-manager.sharedModules = [
    # This module will be imported for all users on this host
    ({ pkgs, homeModules, ... }: {
      # Enable specific home-manager modules for all users on this host
      homeModules = {
        # Enable feature modules (at root level)
        # example = true;

        # Enable bundle modules
        bundles = {
          # example = true;
        };

        # Enable service modules
        services = {
          # media = true;
        };
      };

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

    # Example: Enable OpenGL
    opengl.enable = true;
  };
}
