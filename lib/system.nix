{ lib, inputs }:

{
  # Function to create a NixOS system configuration for a specific host
  mkSystem =
    { hostname, system ? "x86_64-linux", users ? [ ], extraModules ? [ ] }:
    lib.nixosSystem {
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
      ] ++ extraModules;
    };
}
