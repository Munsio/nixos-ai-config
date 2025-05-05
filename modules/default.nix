{ lib, ... }:

let
  # Import module utilities
  moduleUtils = import ../lib/module-utils.nix { inherit lib; };
  inherit (moduleUtils) createModuleSystem;

  # Import module creation function
  libFunctions = import ../lib/default.nix { inherit lib; };
  inherit (libFunctions) mkModule;
in createModuleSystem {
  moduleType = "nix";
  modulesPath = ./.;
  mkModuleFunc = mkModule;
}
