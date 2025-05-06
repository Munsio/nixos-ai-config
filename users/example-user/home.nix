{ pkgs, hostVars, ... }:

{
  # Home Manager configuration for example-user

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Home directory configuration
  home = {
    username = "example-user";
    homeDirectory = "/home/example-user";

    # Packages installed to user profile
    packages = with pkgs; [
      # User-specific packages
      firefox
      thunderbird
      vlc
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    stateVersion = hostVars.stateVersion;
  };

  # Enable homeModules
  homeModules = {
    # Enable features
    git = true;

    # Enable bundles
    bundles.development = true;

    # Enable services
    services.ssh = true;
  };

  # Additional user-specific configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch";
    };
  };
}
