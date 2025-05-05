{ lib, inputs, ... }:

let

in {
  # Function to create a NixOS system configuration for a specific host
  mkSystem =
    { hostname, system ? "x86_64-linux", users ? [ ], extraModules ? [ ] }:
    let
      # Import the module system
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      moduleLib = import ./modules.nix { inherit lib pkgs; };
      inherit (moduleLib) mkModuleSystem;
    in lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname;
        systemUsers = users;
      };
      modules = [
        # Base configuration for all hosts
        ../hosts/default.nix

        # Host-specific configuration
        ../hosts/${hostname}/default.nix

        # Module system
        (mkModuleSystem {
          featuresDir = ../modules/features;
          bundlesDir = ../modules/bundles;
          servicesDir = ../modules/services;
        })
      ] ++ extraModules;
    };
}
