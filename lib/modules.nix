{ lib, pkgs, ... }:

let
  # Function to import all Nix files from a directory
  importDir = dir:
    let
      # Get all entries in the directory
      entries = builtins.readDir dir;

      # Filter out non-Nix files and directories
      nixFiles = lib.filterAttrs
        (name: type: type == "regular" && lib.hasSuffix ".nix" name) entries;

      # Filter directories
      dirs = lib.filterAttrs (name: type: type == "directory") entries;

      # Import each Nix file
      modules = lib.mapAttrs' (name: _:
        let
          # Remove .nix extension
          moduleName = lib.removeSuffix ".nix" name;
          # Import the module and call it with lib and pkgs if it's a function
          imported = import (dir + "/${name}");
          module = if builtins.isFunction imported then
            imported { inherit lib pkgs; }
          else
            imported;
        in lib.nameValuePair moduleName module) nixFiles;

      # Recursively import directories
      nestedModules = lib.mapAttrs'
        (name: _: lib.nameValuePair name (importDir (dir + "/${name}"))) dirs;
      # Merge modules and nested modules
    in modules // nestedModules;

  # Function to create a module with enable option
  mkModule = { name, description, module }:
    { config, lib, ... }: {
      options.nixModules.${name} = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = description;
      };

      config = lib.mkIf config.nixModules.${name} module;
    };

  # Function to create modules from a directory
  mkModulesFromDir = { dir, description }:
    let
      modules = importDir dir;

      # Convert each module to a proper NixOS module with enable option
      modulesList = lib.mapAttrsToList (name: module:
        mkModule {
          inherit name;
          inherit description;
          inherit module;
        }) modules;
    in modulesList;
in {
  # Function to create the nixModules system
  mkModuleSystem = { featuresDir, bundlesDir, servicesDir }:
    let
      # Import modules from each directory
      featureModules = mkModulesFromDir {
        dir = featuresDir;
        description = "Enable this feature";
      };

      bundleModules = mkModulesFromDir {
        dir = bundlesDir;
        description = "Enable this bundle";
      };

      serviceModules = mkModulesFromDir {
        dir = servicesDir;
        description = "Enable this service";
      };
      # Base module that sets up the nixModules option
    in { config, lib, ... }: {
      options.nixModules = {
        features = lib.mkOption {
          type = lib.types.attrsOf lib.types.bool;
          default = { };
          description = "Features to enable";
        };

        bundles = lib.mkOption {
          type = lib.types.attrsOf lib.types.bool;
          default = { };
          description = "Bundles to enable";
        };

        services = lib.mkOption {
          type = lib.types.attrsOf lib.types.bool;
          default = { };
          description = "Services to enable";
        };
      };

      # Import all modules
      imports = featureModules ++ bundleModules ++ serviceModules;
    };
}
