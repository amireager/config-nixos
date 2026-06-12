
{ config, pkgs, inputs, ... }:

{
  # --- MODULE IMPORTS ---
  imports = [
    ../modules/desktop/niri/default.nix
    ../modules/desktop/waybar.nix

    ../modules/editor/nvim/default.nix
    
    ../modules/terminal/kitty.nix
    ../modules/terminal/fish.nix
  ];

  # --- USER ENVIRONMENT ---
  home.username = "amir";
  home.homeDirectory = "/home/amir";
  home.stateVersion = "25.11";

  # --- GENERAL SYSTEM THEME ---
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    font = { name = "Vazirmatn"; size = 11; };
  };

  # --- GENERAL APPLICATIONS (Apps with no specific nix-config) ---
  home.packages = with pkgs; [
    # Browsers
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    telegram-desktop

    # File Management
    thunar thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer
    
    # Pro CLI Tools
    btop eza bat fzf zoxide ripgrep fd lazygit fastfetch zellij direnv bottom
    tmux broot
    
    # Multimedia
    vlc playerctl imv mpv poppler-utils
  ];

  # --- SHARED PROGRAM CONFIGS ---
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };
  
  programs.firefox.enable = true;

  programs.home-manager.enable = true;
}
