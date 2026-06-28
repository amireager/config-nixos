{
  config,
  pkgs,
  ...
}: {
  # ============================================================
  #  NIRI COMPOSITOR
  # ============================================================

  home.packages = with pkgs; [
    wl-clipboard
    networkmanagerapplet
    blueman
  ];

  # NOTE: These are now provided by Noctalia:
  # - fuzzel (launcher)
  # - mako (notifications)
  # - swaylock-effects (lock screen)
  # - brightnessctl (brightness UI)
  # - pavucontrol (volume UI)
  # - awww (wallpaper daemon)

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
}
