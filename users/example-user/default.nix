{ pkgs, ... }:

{
  # User-specific configuration for 'example-user'

  # Create the user account
  users.users.example-user = {
    isNormalUser = true;
    description = "Example User";
    extraGroups = [ "wheel" "networkmanager" ];
    # For a real system, use hashedPassword or passwordFile instead
    # This is just for demonstration
    initialPassword = "changeme";

    # User-specific packages
    packages = with pkgs; [ firefox git vscode ];
  };
}
