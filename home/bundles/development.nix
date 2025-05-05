{ lib, pkgs, ... }:

{
  # Enable git configuration
  homeModules.git = true;

  # Install development tools
  home.packages = with pkgs;
    [
      # Development tools
      dolphin
    ];
}
