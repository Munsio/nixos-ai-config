{ config, lib, pkgs, cfg, ... }: {
  # This configuration will only be applied if nixModules.example = true

  # Example: Install specific packages
  environment.systemPackages = with pkgs; [ htop neofetch ];

  # Example: Enable a service
  services.openssh.enable = true;

  # Example: Set up a systemd service
  systemd.services.example-service = {
    description = "Example Service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.bash}/bin/bash -c 'echo Example service started > /tmp/example-service.log'";
      Type = "oneshot";
    };
  };

  # Example: Add a user
  users.users.example-module-user = {
    isNormalUser = true;
    description = "User created by example module";
    extraGroups = [ "wheel" ];
    # Use a placeholder password hash or disable password authentication
    hashedPassword = null;
    openssh.authorizedKeys.keys = [
      # Add SSH keys here
    ];
  };
}
