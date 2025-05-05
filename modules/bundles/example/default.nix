{ config, lib, pkgs, cfg, ... }: {
  # This configuration will only be applied if nixModules.bundles.example = true

  # Example: Install a bundle of related packages
  environment.systemPackages = with pkgs; [
    # Development tools bundle
    git
    vscode
    gcc
    gnumake
    nodejs
  ];

  # Example: Enable related services for this bundle
  services = {
    # Database service
    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      enableTCPIP = true;
      authentication = lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };

    # Web server
    nginx = {
      enable = true;
      virtualHosts."localhost" = { root = "/var/www/example"; };
    };
  };

  # Example: Create a system user for this bundle
  users.users.example-bundle-user = {
    isSystemUser = true;
    group = "example-bundle";
    description = "User for example bundle services";
  };

  # Create a group for the bundle user
  users.groups.example-bundle = { };

  # Create necessary directories
  system.activationScripts.exampleBundleSetup = ''
    mkdir -p /var/www/example
    echo "<html><body><h1>Example Bundle</h1></body></html>" > /var/www/example/index.html
    chown -R example-bundle-user:example-bundle /var/www/example
  '';
}
