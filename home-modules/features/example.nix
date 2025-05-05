{ config, pkgs, ... }: {
  # Example home-manager module configuration

  # Group all home attributes together
  home = {
    # Example: Install specific packages
    packages = with pkgs; [ ripgrep fzf jq ];

    # Example: Add custom files
    file = {
      ".config/example-module/config.json".text = ''
        {
          "setting1": "value1",
          "setting2": "value2"
        }
      '';
    };

    # Example: Set environment variables
    sessionVariables = {
      EXAMPLE_MODULE_PATH =
        "${config.home.homeDirectory}/.config/example-module";
    };
  };

  # Example: Configure a program
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions;
        [
          # Add extensions here
          # Example: vscodevim.vim
        ];
      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "Fira Code, monospace";
        "editor.formatOnSave" = true;
        "workbench.colorTheme" = "Default Dark+";
      };
    };
  };

  # Example: Add shell aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      gst = "git status";
      gl = "git log";
      gc = "git commit";
    };
  };
}
