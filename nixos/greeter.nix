{
  pkgs,
  config,
  ...
}: let
  dariusCfg = config.home-manager.users.darius;
in {
  # users.extraUsers.greeter = {
  #   home = "/tmp/greeter-home";
  #   createHome = true;
  # };
  #
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "Hyprland";
  #     };
  #     initial_session = {
  #       command = "Hyprland";
  #       user = "darius";
  #     };
  #   };
  # };
}