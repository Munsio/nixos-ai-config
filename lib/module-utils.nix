{ lib }:

{
  # Function to create a module system (either for NixOS modules or Home Manager modules)
  # This function handles the common logic between modules/default.nix and home-modules/default.nix
  createModuleSystem = { moduleType, # "nix" or "home"
    modulesPath, # Path to the modules directory
    mkModuleFunc # The function to use for creating modules (mkModule or mkHomeModule)
    }:
    let
      # Function to import modules from a specific category directory
      importModulesFromCategory = category:
        let
          # Get all directories in the category directory
          categoryDir = modulesPath + "/${category}";

          # Check if the category directory exists
          categoryExists = builtins.pathExists categoryDir;

          # If the category exists, read its contents
          categoryContents =
            if categoryExists then builtins.readDir categoryDir else { };

          # Filter out non-directories and include .nix files
          moduleItems = lib.filterAttrs (name: type:
            type == "directory"
            || (type == "regular" && lib.hasSuffix ".nix" name))
            categoryContents;

          # Import each module and wrap it with the appropriate mkModule function
          modulesList = lib.mapAttrsToList (name: type:
            let
              # For .nix files, remove the .nix extension for the module name
              baseName = if lib.hasSuffix ".nix" name then
                lib.removeSuffix ".nix" name
              else
                name;

              # Path to the module (directory or file)
              modulePath = if type == "directory" then
                categoryDir + "/${name}"
              else
                categoryDir + "/${name}";

              # Import the module
              moduleConfig = import modulePath;

              # For features, the option will be nixModules/homeModules.name
              # For bundles and services, the option will be nixModules/homeModules.category.name
              isFeature = category == "features";
              moduleName =
                if isFeature then baseName else "${category}.${baseName}";
            in mkModuleFunc {
              name = moduleName;
              description = "${baseName} ${category} ${
                  if moduleType == "home" then "home-manager" else "NixOS"
                } module";
              extraConfig = moduleConfig;
            }) moduleItems;
        in if categoryExists then modulesList else [ ];

      # Import modules from each category
      featureModules = importModulesFromCategory "features";
      bundleModules = importModulesFromCategory "bundles";
      serviceModules = importModulesFromCategory "services";

      # Combine all modules
      allModules = featureModules ++ bundleModules ++ serviceModules;

      # The option name to use (nixModules or homeModules)
      optionName = if moduleType == "home" then "homeModules" else "nixModules";

      # Create a merged module from all the imported modules
      modulesModule = { lib, ... }: {
        imports = allModules;

        # Add options structure for nixModules/homeModules
        options.${optionName} = lib.mkOption {
          type = lib.types.submodule {
            options = {
              # Bundles are in a separate subsection
              bundles = lib.mkOption {
                type = lib.types.submodule { };
                default = { };
                description = "Set of ${
                    if moduleType == "home" then "home-manager" else "NixOS"
                  } bundle modules to enable";
              };

              # Services are in a separate subsection
              services = lib.mkOption {
                type = lib.types.submodule { };
                default = { };
                description = "Set of ${
                    if moduleType == "home" then "home-manager" else "NixOS"
                  } service modules to enable";
              };
            };
          };
          default = { };
          description = "Set of ${
              if moduleType == "home" then "home-manager" else "NixOS"
            } modules to enable";
        };
      };
    in modulesModule;
}
