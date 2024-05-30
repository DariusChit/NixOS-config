{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
        no_fade_in = false;
        hide_cursor = true;
      };

      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
      };

      input-field = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "JetBrains Mono Nerd Font Mono";
        placeholder_text = ''
          <i><span foreground="##cdd6f4">Password</span></i>
        '';
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };

      # TIME
      label = {
        monitor = "";
        text = ''
          cmd[update:1000] echo "$(date +"%H:%M")"
        '';
        color = "$foreground";
        font_size = 120;
        font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
        position = "0, -300";
        halign = "center";
        valign = "top";
      };
    };
  };
}
