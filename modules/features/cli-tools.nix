{ pkgs, ... }:

{
  # Install jq and vim as system packages
  environment.systemPackages = with pkgs; [ jq vim ];
}
