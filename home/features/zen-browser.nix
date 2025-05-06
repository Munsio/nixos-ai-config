{ pkgs, ... }:

{
  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = true;
    };
    # Assuming firefoxpwa is the desired package for native messaging.
    # This will require pkgs to be available in the module's scope.
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
  };
}
