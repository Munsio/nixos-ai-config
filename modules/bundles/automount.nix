{ pkgs, ... }:

{
  # Enable services for USB automounting
  services.devmon.enable = true; # Automounts removable devices
  services.gvfs.enable =
    true; # GNOME Virtual File System, provides backends for udisks2
  services.udisks2.enable = true; # Provides block device and storage management

  # Install common filesystem tools
  environment.systemPackages = with pkgs; [
    ntfs3g # For NTFS filesystem support
    exfatprogs # For exFAT filesystem support
    dosfstools # For FAT32/VFAT filesystem support
  ];
}
