{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Example User";
    userEmail = "user@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
