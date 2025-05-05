{ config, lib, pkgs, cfg, ... }: {
  # This configuration will only be applied if homeModules.example = true

  # Example: Install specific packages
  home.packages = with pkgs; [ ripgrep fzf jq ];

  # Example: Configure a program
  programs.vscode = {
    enable = true;
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

  # Example: Add custom files
  home.file = {
    ".config/example-module/config.json".text = ''
      {
        "setting1": "value1",
        "setting2": "value2"
      }
    '';
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

  # Example: Set environment variables
  home.sessionVariables = {
    EXAMPLE_MODULE_PATH = "${config.home.homeDirectory}/.config/example-module";
  };
}
