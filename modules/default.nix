{ lib, ... }:

let
  utils = import ../lib {
    inherit lib;
    nixpkgs = null;
    home-manager = null;
    inputs = null;
  };

  # Function to import modules from a specific category directory
  importModulesFromCategory = category:
    let
      # Get all directories in the category directory
      categoryDir = ./. + "/${category}";

      # Check if the category directory exists
      categoryExists = builtins.pathExists categoryDir;

      # If the category exists, read its contents
      categoryContents =
        if categoryExists then builtins.readDir categoryDir else { };

      # Filter out non-directories
      moduleDirs =
        lib.filterAttrs (_: type: type == "directory") categoryContents;

      # Import each module directory and wrap it with utils.mkModule
      # For features, use the name directly
      # For bundles and services, use category.name
      modulesList = lib.mapAttrsToList (name: _:
        let
          modulePath = categoryDir + "/${name}";
          moduleConfig = import modulePath;

          # For features, the option will be nixModules.name
          # For bundles and services, the option will be nixModules.category.name
          isFeature = category == "features";
          moduleName = if isFeature then name else "${category}.${name}";
        in utils.mkModule {
          name = moduleName;
          description = "${name} ${category} module";
          extraConfig = moduleConfig;
        }) moduleDirs;
    in if categoryExists then modulesList else [ ];

  # Import modules from each category
  featureModules = importModulesFromCategory "features";
  bundleModules = importModulesFromCategory "bundles";
  serviceModules = importModulesFromCategory "services";

  # Combine all modules
  allModules = featureModules ++ bundleModules ++ serviceModules;

  # Create a merged module from all the imported modules
  modulesModule = {
    imports = allModules;

    # Add options structure for nixModules
    options.nixModules = lib.mkOption {
      type = lib.types.submodule {
        options = {
          # Bundles are in a separate subsection
          bundles = lib.mkOption {
            type = lib.types.submodule { };
            default = { };
            description = "Set of NixOS bundle modules to enable";
          };

          # Services are in a separate subsection
          services = lib.mkOption {
            type = lib.types.submodule { };
            default = { };
            description = "Set of NixOS service modules to enable";
          };
        };
      };
      default = { };
      description = "Set of NixOS modules to enable";
    };
  };
in modulesModule
