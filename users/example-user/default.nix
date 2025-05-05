{ pkgs, homeModules, ... }:

{
  # Import home-modules
  imports = [
    # You can import additional home-manager modules here if needed
  ];

  # Enable specific home-manager modules for this user
  homeModules = {
    # Enable feature modules (at root level), overriding host-level settings if necessary
    # example = true;

    # Enable bundle modules
    bundles = {
      # example = true;
    };

    # Enable service modules
    services = {
      # media = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = "example-user";
    homeDirectory = "/home/example-user";

    # User-specific packages
    packages = with pkgs; [
      # Development tools
      vscode
      git

      # Utilities
      htop
      bat
      fd

      # Applications
      thunderbird
    ];

    # Manage files in $HOME
    file = {
      # Example: Create a .gitconfig file
      ".gitconfig".text = ''
        [user]
          name = Example User
          email = example@example.com
        [core]
          editor = vim
      '';
    };

    # Manage environment variables
    sessionVariables = { EDITOR = "vim"; };
  };

  # Program-specific configurations
  programs = {
    # Let Home Manager manage itself
    home-manager.enable = true;

    # Configure bash
    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -la";
        update = "sudo nixos-rebuild switch";
      };
      initExtra = ''
        # Additional bash configuration
      '';
    };

    # Configure git
    git = {
      enable = true;
      userName = "Example User";
      userEmail = "example@example.com";
    };

    # Configure vim
    vim = {
      enable = true;
      extraConfig = ''
        syntax on
        set number
      '';
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "23.11";
}
