{ lib, pkgs, hostVars, ... }:

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
  time.timeZone = lib.mkDefault hostVars.timezone;

  # Select internationalisation properties
  i18n.defaultLocale = lib.mkDefault hostVars.locale;

  # Configure console keymap
  console.keyMap = lib.mkDefault hostVars.keyboardLayout;

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
  system.stateVersion = lib.mkDefault hostVars.stateVersion;
}
