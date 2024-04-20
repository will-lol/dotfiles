{pkgs, config, ...}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  security = {
    polkit.enable = true; # Required by Wayland
    sudo = {
      extraRules = [
        {
          users = [config.username];
          commands = [
            {
              command = "${pkgs.ydotool}/bin/";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };

  users.users.${config.username}.extraGroups = ["wheel"];
}
