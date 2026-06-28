# ============================================================
#  NOCTALIA — Desktop Shell
#
#  A complete Wayland desktop shell: bar, launcher, notifications,
#  control center, wallpaper, dock, OSD, lock screen, and more.
#
#  Docs: https://docs.noctalia.dev/v5/
# ============================================================
{inputs, ...}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      # --- SHELL ---
      shell = {
        font = "JetBrainsMono Nerd Font";
        settings_show_advanced = true;
        launch_apps_as_systemd_services = true;
      };

      # --- THEME ---
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      # --- WALLPAPER ---
      wallpaper = {
        enabled = true;
        # Set your wallpaper path here after first boot
        # default.path = "/home/amir/Pictures/wallpaper.png";
      };

      # --- BAR ---
      bar = {
        position = "top";
        margin_top = 8;
        margin_left = 12;
        margin_right = 12;
      };

      # --- NOTIFICATIONS ---
      notifications = {
        enabled = true;
        timeout = 5000;
      };

      # --- LAUNCHER ---
      launcher = {
        enable = true;
      };

      # --- CONTROL CENTER ---
      control_center = {
        enable = true;
      };

      # --- DOCK ---
      dock = {
        enabled = true;
        position = "bottom";
      };

      # --- Niri integration ---
      niri = {
        overview_type_to_launch_enabled = true;
      };
    };
  };
}
