{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./env.nix
  ];

  xdg.portal = let
    hyprland = config.wayland.windowManager.hyprland.package;
    xdph = pkgs.xdg-desktop-portal-hyprland.override {inherit hyprland;};
  in {
    extraPortals = [xdph];
    configPackages = [hyprland];
  };

  home.packages = with pkgs; [
    hyprpicker
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    swappy
  ];

  wayland.windowManager.hyprland = let
    browser = lib.getExe pkgs.brave;
    term = lib.getExe pkgs.kitty;
    nm-applet = lib.getExe pkgs.networkmanagerapplet;
    blueman-applet = lib.getExe' pkgs.blueman "blueman-applet";
    # auth-agent = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    auth-agent = lib.getExe' pkgs.kdePackages.polkit-kde-agent-1 "polkit-kde-authentication-agent-1";
  in {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };

    settings = let
      # active = "0xaa${lib.removePrefix "#" config.colorscheme.colors.primary}";
      # inactive = "0xaa${lib.removePrefix "#" config.colorscheme.colors.surface_bright}";
    in {
      monitor = [
        "eDP-2,2560x1600@165,0x0,1,vrr,1"
        "eDP-1,2560x1600@165,0x0,1,vrr,1"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        # "col.border_active" = active;
        # "col.border_inactive" = inactive;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        active_opacity = 0.97;
        inactive_opacity = 0.77;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
      };
      animations = {
        enabled = "yes";
      };
      dwindle = {
        preserve_split = "yes";
      };
      gestures = {
        workspace_swipe = "on";
      };
      misc = {
        vfr = true;
        vrr = 1;
        force_default_wallpaper = 0;
      };
      input = {
        kb_layout = "us";
        kb_options = "caps:swapescape";
        follow_mouse = 1;
        touchpad.natural_scroll = "yes";
        sensitivity = 0.2;
      };
      bind = let
        defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
        notify-send = lib.getExe' pkgs.libnotify "nofity-send";
        wpctl = lib.getExe' pkgs.wireplumber "wpctl";
        grimblast = lib.getExe inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;
        brightnessctl = lib.getExe pkgs.brightnessctl;
        screenshot-script = ./screenshot-script.sh;
      in
        [
          # Lauch Terminal
          "SUPER, T, exec, ${defaultApp "x-scheme-handler/terminal"}"

          # Launch Browser
          "SUPER, B, exec, ${lib.getExe pkgs.brave}"

          # Brightness Control
          ", XF86MonBrightnessUp, exec, ${brightnessctl} set 5%+"
          ", XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"

          # Volume Control
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Screenshotting
          "$mainMod,      P, exec, nix-shell ${screenshot-script} s # drag to snip an area / click on a window to print it"
          "$mainMod Ctrl, P, exec, nix-shell ${screenshot-script} sf # frozen screen, drag to snip an area / click on a window to print it"
          "$mainMod Alt,  P, exec, nix-shell ${screenshot-script} m # print focused monitor"
          ", Print, exec, nix-shell ${screenshot-script} p # print all monitor outputs"

          # Quit apps
          "SUPER, Q, killactive"
          "SUPERALTSHIFT, Q, exit"
        ]
        ++ (
          let
            playerctl = lib.getExe' config.services.playerctld.package "playerctl";
            playerctld = lib.getExe' config.services.playerctld.package "playerctld";
          in
            lib.optionals config.services.playerctld.enable [
              # Media control
              ",XF86AudioNext,exec,${playerctl} next"
              ",XF86AudioPrev,exec,${playerctl} previous"
              ",XF86AudioPlay,exec,${playerctl} play-pause"
              ",XF86AudioStop,exec,${playerctl} stop"
              "ALT,XF86AudioNext,exec,${playerctld} shift"
              "ALT,XF86AudioPrev,exec,${playerctld} unshift"
              "ALT,XF86AudioPlay,exec,systemctl --user restart playerctld"
            ]
        )
        ++
        # Notification manager
        (
          let
            makoctl = lib.getExe' config.services.mako.package "makoctl";
          in
            lib.optionals config.services.mako.enable [
              "SUPERSHIFT,w,exec,${makoctl} restore"
            ]
        )
        # App launcher
        ++ (
          let
            wofi = lib.getExe config.programs.wofi.package;
          in
            lib.optionals config.programs.wofi.enable [
              "SUPER,A,exec,${wofi} -S drun -W 25% -H 60%"
            ]
        );
    };

    extraConfig = ''
      exec-once = [workspace 1 silent] ${browser}
      exec-once = [workspace 2 silent] ${term} --hold sh -c "tmux -u"
      exec-once = ${nm-applet}
      exec-once = ${blueman-applet}
      exec-once = ${auth-agent}
    '';
  };
}
