{...}: {
  # ============================================================
  #  ENTRY POINT for user 'amir'
  #  Keep this file minimal: only imports + essential user info.
  #  - Packages  -> ./packages.nix
  #  - Settings  -> ./settings.nix
  # ============================================================

  # --- MODULE IMPORTS ---
  imports = [
    # Local splits
    ./packages.nix
    ./settings.nix

    # Desktop environment (compositor + theme + notifications)
    ../../modules/desktop

    # Editor
    ../../modules/editor/nvim

    # Terminal
    ../../modules/terminal/kitty.nix
    ../../modules/terminal/fish.nix
  ];

  # --- USER ENVIRONMENT (essentials) ---
  home.username = "amir";
  home.homeDirectory = "/home/amir";
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
