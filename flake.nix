{
  description = "NixOS configuration with flakes and home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser-flake = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs"; # Assuming it might need nixpkgs
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      # Available systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Function to generate attributes for each supported system
      forAllSystems = lib.genAttrs supportedSystems;

      # Import the system builder function
      systemLib = import ./lib/system.nix {
        inherit lib inputs;
      }; # inputs here will include zen-browser-flake
      inherit (systemLib) mkSystem;

    in {
      # NixOS configurations for different hosts
      nixosConfigurations = {
        # Example host configuration using mkSystem
        example = mkSystem {
          hostname = "example";
          users = [ "example-user" ];
          extraHomeManagerModules =
            [ inputs.zen-browser-flake.homeModules.twilight ];
        };
      };

      # Development shell for working with this flake
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # Nix language server
              nil

              # Nix formatting and linting tools
              nixpkgs-fmt # Formatter
              statix # Linter for suggestions
              deadnix # Find unused code
              # nix-linter is currently marked as broken in nixpkgs
            ];
          };
        });
    };
}
