{
  config,
  pkgs,
  ...
}: {
  # --- NIRI DESKTOP ENVIRONMENT PACKAGES ---
  # Packages that define the look and feel of the desktop
  home.packages = with pkgs; [
    # UI Components
    swww # Wallpaper daemon (supports GIFs/transitions)
    mako # Lightweight notification daemon
    fuzzel # Simple Wayland app launcher
    wl-clipboard # Copy/Paste support for Wayland
    swaylock-effects # Screen locker with blur effects

    # System Controls
    brightnessctl # Control screen brightness via terminal
    pavucontrol # PulseAudio Volume Control (GUI)
    libnotify # Library for sending notifications
    networkmanagerapplet # WiFi icon in the bar
    blueman # Bluetooth manager
  ];

  # --- CONFIGURATION FILE MANAGEMENT ---
  # Links the 'config.kdl' file from the current directory to ~/.config/niri/
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # --- WAYLAND ENVIRONMENT VARIABLES ---
  # Forces apps to use Wayland natively and fixes common graphical issues
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # For Electron apps (VSCode, Discord, Chrome)
    MOZ_ENABLE_WAYLAND = "1"; # For Firefox
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland"; # For Qt apps
  };
}
