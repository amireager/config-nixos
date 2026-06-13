{ config, pkgs, inputs, ... }:

{
  # --- MODULE IMPORTS ---
  imports = [
    # Desktop environment
    ../modules/desktop/niri/default.nix
    ../modules/desktop/waybar.nix
    ../modules/desktop/theme.nix

    # Editor
    ../modules/editor/nvim

    # Terminal
    ../modules/terminal/kitty.nix
    ../modules/terminal/fish.nix
  ];

  # --- USER ENVIRONMENT ---
  home.username = "amir";
  home.homeDirectory = "/home/amir";
  home.stateVersion = "25.11";

  # --- STANDARD USER DIRECTORIES ---
  # Creates & registers ~/Downloads, ~/Documents, ... like any normal OS
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # --- DEFAULT APPLICATIONS (double-click behavior) ---
  # NOTE: verify desktop file names with:
  #   ls ~/.nix-profile/share/applications /run/current-system/sw/share/applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web
      "text/html" = [ "zen-beta.desktop" ];
      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];

      # Images
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];

      # Video & Audio
      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];

      # Documents
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];

      # File manager
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  # --- DAILY-DRIVER APPLICATIONS ---
  home.packages = with pkgs; [
    home-manager

    # Browsers & Communication
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    telegram-desktop
    qutebrowser
    tor-browser

    # Multimedia (view & play)
    imv # Image viewer (Wayland native)
    mpv # Video/audio player
    vlc # Heavy-duty fallback player
    playerctl # Media keys control (play/pause from keyboard)

    # Documents
    zathura # Lightweight vim-style PDF viewer
    poppler-utils # PDF CLI tools (pdftotext, ...)

    # Archives (thunar-archive-plugin NEEDS a real archive tool!)
    xarchiver
    zip
    unzip
    p7zip
    unrar

    # Removable media helper (tray icon + automount, works with gvfs)
    udiskie

    # Thumbnails backend for videos (used by system-level tumbler)
    ffmpegthumbnailer

    # System monitoring & CLI comfort
    btop
    bottom
    fastfetch
    eza
    zoxide
    lazygit
    direnv

    # Terminal multiplexers (TODO: pick one in the fish/terminal step)
    tmux
    zellij
    broot
  ];

  # --- SHARED PROGRAM CONFIGS ---
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };

  # Firefox as a stable fallback browser (managed as a program, not a package)
  programs.firefox.enable = true;

  programs.home-manager.enable = true;
}
