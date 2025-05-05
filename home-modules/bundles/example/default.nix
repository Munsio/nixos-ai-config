{ config, pkgs, ... }: {
  # Example home-manager bundle module configuration

  # Group all home attributes together
  home = {
    # Example: Install a bundle of related packages
    packages = with pkgs; [
      # Development tools bundle
      git
      vscode
      nodejs
      yarn
      python3
      python3Packages.pip
      python3Packages.virtualenv
    ];

    # Example: Add custom files for this bundle
    file = {
      # Project templates
      ".templates/react-app".source = pkgs.fetchFromGitHub {
        owner = "facebook";
        repo = "create-react-app";
        rev = "v5.0.0";
        sha256 = "sha256-vUJbf2Piuovy2BK4hycCU43EZtRSdbLGQmvU6D9vhTg=";
      };

      # Configuration files
      ".config/bundle-example/settings.json".text = ''
        {
          "editor": {
            "fontFamily": "Fira Code",
            "fontSize": 14,
            "tabSize": 2
          },
          "terminal": {
            "integrated": {
              "shell": {
                "linux": "/run/current-system/sw/bin/bash"
              }
            }
          }
        }
      '';
    };

    # Example: Set environment variables for this bundle
    sessionVariables = {
      EXAMPLE_BUNDLE_PATH =
        "${config.home.homeDirectory}/.config/bundle-example";
      NODE_OPTIONS = "--max-old-space-size=4096";
    };
  };

  # Example: Configure related programs for this bundle
  programs = {
    # Terminal
    alacritty = {
      enable = true;
      settings = {
        font.size = 12;
        window.opacity = 0.95;
      };
    };

    # Editor
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-fugitive
        vim-surround
        nerdtree
      ];
      extraConfig = ''
        set number
        set relativenumber
        set expandtab
        set tabstop=2
        set shiftwidth=2
      '';
    };

    # Version control
    git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      aliases = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
      };
    };
  };
}
