{ lib, pkgs, ... }:

{
  # Common configuration for all hosts

  # Enable flakes and nix-command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Set your time zone
  time.timeZone = lib.mkDefault "UTC";

  # Select internationalisation properties
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # Configure console keymap
  console.keyMap = lib.mkDefault "us";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Basic packages for all systems
  environment.systemPackages = with pkgs; [ vim wget git curl ];

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software.
  system.stateVersion = lib.mkDefault "23.11";
}
