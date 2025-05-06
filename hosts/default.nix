{ lib, pkgs, hostVars, ... }:

{
  # Common configuration for all hosts

  # Enable NixOS modules
  nixModules = {
    # Enable features
    nixos = true;
  };

  # Set your time zone
  time.timeZone = lib.mkDefault hostVars.timezone;

  # Select internationalisation properties
  i18n.defaultLocale = lib.mkDefault hostVars.locale;

  # Configure console keymap
  console.keyMap = lib.mkDefault hostVars.keyboardLayout;

  # Basic packages for all systems
  environment.systemPackages = with pkgs; [ vim wget git curl ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software.
  system.stateVersion = lib.mkDefault hostVars.stateVersion;
}
