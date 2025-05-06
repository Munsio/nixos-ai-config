{ lib, inputs, ... }:

let
  # Import the module system
  moduleLib = import ./modules.nix {
    inherit lib;
    pkgs = null;
  };
  inherit (moduleLib) moduleTypes;
in {
  # Function to create a NixOS system configuration for a specific host
  mkSystem = { hostname, system ? "x86_64-linux", users ? [ ]
    , extraModules ? [ ], homeManagerConfig ? null }:
    let
      # Import the module system
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      moduleLib = import ./modules.nix { inherit lib pkgs; };
      inherit (moduleLib) mkModuleSystem;

      # Import host variables (mandatory)
      hostVars = import ../hosts/${hostname}/variables.nix;

      # Generate user modules
      userModules = lib.attrValues
        (lib.genAttrs users (user: ../users/${user}/default.nix));

      # Home Manager configuration
      homeManagerModule = inputs.home-manager.nixosModules.home-manager;

      # Default Home Manager configuration
      defaultHomeManagerConfig = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs hostname hostVars; };
          sharedModules = [
            (mkModuleSystem {
              featuresDir = ../home/features;
              bundlesDir = ../home/bundles;
              servicesDir = ../home/services;
              type = moduleTypes.home;
            })
          ];
          # Load user-specific home-manager configurations
          users = lib.genAttrs users (user: {
            imports =
              [ ../hosts/${hostname}/home.nix ../users/${user}/home.nix ];
          });
        };
      };

      # Use provided home-manager config or default
      finalHomeManagerConfig = if homeManagerConfig != null then
        homeManagerConfig
      else
        defaultHomeManagerConfig;
    in lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs hostname hostVars; };
      modules = [
        # Base configuration for all hosts
        ../hosts/default.nix

        # Host-specific configuration
        ../hosts/${hostname}/default.nix

        # NixOS Module system
        (mkModuleSystem {
          featuresDir = ../modules/features;
          bundlesDir = ../modules/bundles;
          servicesDir = ../modules/services;
          type = moduleTypes.nix;
        })

        # Home Manager module
        homeManagerModule
        finalHomeManagerConfig
      ] ++ userModules ++ extraModules;
    };
}
