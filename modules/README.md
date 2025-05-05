# NixOS Module System

This directory contains the module system for NixOS configurations. The module system provides a way to organize and enable features, bundles, and services in a structured manner.

## Directory Structure

The module system is organized into three main directories:

- `features/`: Contains individual features that can be enabled independently.
- `bundles/`: Contains collections of features that are commonly used together.
- `services/`: Contains service configurations that can be enabled independently.

## Usage

To enable modules in your NixOS configuration, use the `nixModules` option in your host configuration:

```nix
# hosts/example/default.nix
{ pkgs, ... }:

{
  # Enable NixOS modules using nixModules
  nixModules = {
    # Enable features
    cli-tools = true;

    # Enable bundles
    bundles.development = true;

    # Enable services
    services.ssh = true;
  };
}
```

## Creating Modules

### Features

Features are individual modules that provide specific functionality. To create a new feature, add a new `.nix` file to the `features/` directory:

```nix
# modules/features/example.nix
{ pkgs, ... }:

{
  # Your feature configuration here
  environment.systemPackages = with pkgs; [ example-package ];
}
```

### Bundles

Bundles are collections of features that are commonly used together. To create a new bundle, add a new `.nix` file to the `bundles/` directory:

```nix
# modules/bundles/example.nix
{ ... }:

{
  # Enable features in this bundle
  nixModules = {
    feature1 = true;
    feature2 = true;
  };
}
```

### Services

Services are configurations for specific services. To create a new service, add a new `.nix` file to the `services/` directory:

```nix
# modules/services/example.nix
{ ... }:

{
  # Your service configuration here
  services.example = {
    enable = true;
    # Additional service configuration
  };
}
```

## Implementation Details

The module system is implemented in `lib/modules.nix`. It automatically loads all `.nix` files from the `features/`, `bundles/`, and `services/` directories and makes them available as options in the `nixModules` attribute set.

Each module is automatically wrapped with an `enable` option, so you can enable or disable it by setting the corresponding option to `true` or `false`.
