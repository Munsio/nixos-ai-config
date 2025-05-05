{
  description = "NixOS configuration with flakes and home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;

      # Import utility functions
      utils = import ./lib { inherit lib nixpkgs home-manager inputs; };

      # Extract the mkSystem function from utils
      inherit (utils) mkSystem;

      # Available systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Function to generate attributes for each supported system
      forAllSystems = lib.genAttrs supportedSystems;
    in {
      # NixOS configurations for different hosts
      nixosConfigurations = {
        # Example host configuration
        example = mkSystem {
          hostname = "example";
          users = [ "example-user" ];
        };

        # Add your actual hosts here
        # my-laptop = mkSystem {
        #   hostname = "my-laptop";
        #   users = [ "alice" "bob" ];
        # };
      };

      # Development shell for working with this flake
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default =
            pkgs.mkShell { buildInputs = with pkgs; [ nixpkgs-fmt nil ]; };
        });
    };
}
