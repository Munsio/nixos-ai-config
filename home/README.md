# Home Manager Modules

This directory contains modules for Home Manager configurations. These modules are organized into three categories:

- **features**: Individual features that can be enabled in a home-manager configuration
- **bundles**: Collections of features and packages grouped together for specific use cases
- **services**: Service configurations for home-manager

## Usage

### In User Configuration

To use these modules in a user's home-manager configuration, enable them in the `homeModules` section:

```nix
# users/example-user/home.nix
{ pkgs, ... }:

{
  # Enable homeModules
  homeModules = {
    # Enable features
    git = true;

    # Enable bundles
    bundles.development = true;

    # Enable services
    services.ssh = true;
  };
}
```

### In Host Configuration

You can also enable home-manager modules for all users on a specific host, or override user-specific configurations:

```nix
# hosts/example/default.nix
{ pkgs, ... }:

{
  # Enable Home Manager modules for all users on this host
  homeModules = {
    # Enable features for all users
    git = true;
  };

  # Host-specific Home Manager configuration for a specific user
  home-manager.users.example-user = {
    # Override user's home-manager configuration
    homeModules.bundles.development = false;
    
    # Add host-specific packages
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
```

## Creating New Modules

### Features

Create a new file in `home/features/` with a descriptive name:

```nix
# home/features/example.nix
{ lib, pkgs, ... }:

{
  # Your home-manager configuration here
  programs.example = {
    enable = true;
    # Additional configuration...
  };
}
```

### Bundles

Create a new file in `home/bundles/` to group related features and packages:

```nix
# home/bundles/example.nix
{ lib, pkgs, ... }:

{
  # Enable related features
  homeModules.feature1 = true;
  homeModules.feature2 = true;

  # Add related packages
  home.packages = with pkgs; [
    package1
    package2
  ];
}
```

### Services

Create a new file in `home/services/` for service configurations:

```nix
# home/services/example.nix
{ lib, pkgs, ... }:

{
  # Service configuration
  services.example = {
    enable = true;
    # Additional configuration...
  };
}
