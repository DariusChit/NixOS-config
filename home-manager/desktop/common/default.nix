{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./cursor.nix
    ./kitty.nix
    ./font.nix
    ./playerctl.nix
    ./mako.nix
    ./wofi.nix
    ./waybar.nix
    ./gtk.nix
    ./qt.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./swww.nix
    # ./extraBluetooth.nix
  ];

  home.packages = with pkgs; [
    libnotify
    wl-clipboard
    grim
    slurp
    xdg-utils
    brightnessctl
  ];

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  xdg = {
    portal.enable = true;
    mimeApps.enable = true;
    configFile."mimeapps.list".force = true;
  };
}
