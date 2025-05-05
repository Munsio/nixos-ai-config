{ lib, pkgs, ... }:

let
  # Define module types
  moduleTypes = {
    nix = "nixModules";
    home = "homeModules";
  };
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
  mkModule = { name, description, module, type ? moduleTypes.nix }:
    { config, lib, ... }: {
      options.${type}.${name} = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = description;
      };

      config = lib.mkIf config.${type}.${name} module;
    };

  # Function to create modules from a directory
  mkModulesFromDir = { dir, description, type ? moduleTypes.nix }:
    let
      modules = importDir dir;

      # Convert each module to a proper module with enable option
      modulesList = lib.mapAttrsToList (name: module:
        mkModule {
          inherit name;
          inherit description;
          inherit module;
          inherit type;
        }) modules;
    in modulesList;
in {
  inherit moduleTypes;

  # Function to create a module system (nixModules or homeModules)
  mkModuleSystem =
    { featuresDir, bundlesDir, servicesDir, type ? moduleTypes.nix }:
    let
      # Import modules from each directory
      featureModules = mkModulesFromDir {
        dir = featuresDir;
        description = "Enable this feature";
        inherit type;
      };

      bundleModules = mkModulesFromDir {
        dir = bundlesDir;
        description = "Enable this bundle";
        inherit type;
      };

      serviceModules = mkModulesFromDir {
        dir = servicesDir;
        description = "Enable this service";
        inherit type;
      };
      # Base module that sets up the module options
    in { config, lib, ... }: {
      options.${type} = {
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
