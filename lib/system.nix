{ lib, nixpkgs, home-manager, inputs }:

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
        # Include home-manager as a module
        home-manager.nixosModules.home-manager

        # Base configuration for all hosts
        ../hosts/default.nix

        # Host-specific configuration
        ../hosts/${hostname}/default.nix

        # Extra modules if needed
        extraModules

        # Home-manager configuration
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs hostname; };
            users = lib.genAttrs users (user:
              let
                userPath = ../users/${user};
                userDefault =
                  if builtins.pathExists (userPath + "/default.nix") then
                    userPath + "/default.nix"
                  else
                    ../users/${user}.nix;
              in import userDefault);
          };
        }
      ];
    };
}
