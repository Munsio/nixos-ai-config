{ lib, nixpkgs, home-manager, inputs }:

let
  # Import system utilities
  systemUtils =
    import ./system.nix { inherit lib nixpkgs home-manager inputs; };

  # Function to create a module with standard options and config pattern
  mkModule =
    { name, description ? "Enable the ${name} module", extraConfig ? { } }:
    { config, lib, pkgs, ... }:
    let
      # Parse the name to handle category.module format
      # If name contains a dot, it's a category.module format
      hasCategory = builtins.match "([^.]+).([^.]+)" name != null;

      # Extract category and module name
      parts = if hasCategory then
        builtins.match "([^.]+).([^.]+)" name
      else [
        ""
        name
      ];
      category = if hasCategory then builtins.elemAt parts 0 else "";
      moduleName = if hasCategory then builtins.elemAt parts 1 else name;

      # Get the configuration value based on whether it's a categorized module or not
      cfg = if hasCategory then
        config.nixModules.${category}.${moduleName}
      else
        config.nixModules.${name};
    in {
      # Define the option to enable this module
      options = if hasCategory then {
        nixModules.${category}.${moduleName} = lib.mkOption {
          type = lib.types.bool;
          default = false;
          inherit description;
        };
      } else {
        nixModules.${name} = lib.mkOption {
          type = lib.types.bool;
          default = false;
          inherit description;
        };
      };

      # Define the configuration for this module
      config = lib.mkIf cfg (extraConfig { inherit config lib pkgs cfg; });
    };

  # Function to create a home-manager module with standard options and config pattern
  mkHomeModule = { name, description ? "Enable the ${name} home-manager module"
    , extraConfig ? { } }:
    { config, lib, pkgs, ... }:
    let
      # Parse the name to handle category.module format
      # If name contains a dot, it's a category.module format
      hasCategory = builtins.match "([^.]+).([^.]+)" name != null;

      # Extract category and module name
      parts = if hasCategory then
        builtins.match "([^.]+).([^.]+)" name
      else [
        ""
        name
      ];
      category = if hasCategory then builtins.elemAt parts 0 else "";
      moduleName = if hasCategory then builtins.elemAt parts 1 else name;

      # Get the configuration value based on whether it's a categorized module or not
      cfg = if hasCategory then
        config.homeModules.${category}.${moduleName}
      else
        config.homeModules.${name};
    in {
      # Define the option to enable this module
      options = if hasCategory then {
        homeModules.${category}.${moduleName} = lib.mkOption {
          type = lib.types.bool;
          default = false;
          inherit description;
        };
      } else {
        homeModules.${name} = lib.mkOption {
          type = lib.types.bool;
          default = false;
          inherit description;
        };
      };

      # Define the configuration for this module
      config = lib.mkIf cfg (extraConfig { inherit config lib pkgs cfg; });
    };
in {
  inherit (systemUtils) mkSystem;
  inherit mkModule mkHomeModule;
}
