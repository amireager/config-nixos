{
  pkgs,
  inputs,
  ...
}: {
  # ============================================================
  #  USER PACKAGES — single source of truth for "what I have"
  #
  #  Layout:
  #    1) GUI / daily-driver apps
  #    2) CLI tools (active)
  #    3) Reference block (commented) = tools that actually come
  #       from other modules, listed here just so everything is
  #       visible in ONE place. Duplicating them is harmless
  #       (same store path -> Home Manager dedups), but we keep
  #       them commented to avoid confusion about "where it lives".
  #
  #  Things enabled as `programs.*` live in ./settings.nix:
  #    btop, fastfetch, lazygit, broot, yazi, bat, git, gh,
  #    atuin, tmux, tealdeer
  # ============================================================
  home.packages = with pkgs; [
    # ========================================================
    # 1) GUI / DAILY-DRIVER APPS
    # ========================================================

    # --- Browsers & Communication ---
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    telegram-desktop
    qutebrowser
    # tor-browser

    # --- Multimedia (view & play) ---
    imv # Image viewer (Wayland native)
    mpv # Video/audio player
    # vlc # Heavy-duty fallback player
    playerctl # Media keys control (play/pause from keyboard)

    # --- Documents ---
    zathura # Lightweight vim-style PDF viewer
    poppler-utils # PDF CLI tools (pdftotext, ...)

    # --- Archives (thunar-archive-plugin NEEDS a real archive tool!) ---
    zip
    unzip
    p7zip
    unrar

    # --- Removable media helper (tray icon + automount, works with gvfs) ---
    udiskie

    # --- Thumbnails backend for videos (used by system-level tumbler) ---
    ffmpegthumbnailer

    # ========================================================
    # 2) CLI TOOLS (active)
    # ========================================================

    # ----------------------------------------------------------
    # SYSTEM MONITORING
    # ----------------------------------------------------------

    # --- Already managed via programs.* in settings.nix ---
    # btop          → CPU/RAM/Disk/Network monitor (main dashboard)
    # fastfetch     → System info fetch

    # --- Already provided by fish.nix module ---
    # bottom is installed via modules/terminal/fish.nix

    # --- Disk I/O ---
    iotop # Disk usage per process (needs sudo)
    dust # Disk usage tre

    bandwhich # Network usage per-process (realtime)
    erdtree # Directory tree with icons (better dust)
    procs # Colored process list (better ps)

    # --- GPU Monitoring ---
    # nvtop # GPU monitor for Nvidia/AMD/Intel (GTX 1650 supported)

    # ----------------------------------------------------------
    # WAYLAND / NIRI TOOLS
    # ----------------------------------------------------------

    grim # Screenshot tool (Wayland)
    slurp # Region selection for screenshots (Wayland)
    wl-screenrec # Screen recorder (Wayland)
    brightnessctl # Screen brightness control
    pamixer # Volume control from terminal
    bluetui # Bluetooth TUI manager
    wl-clipboard # copy/paste for Wayland

    # ----------------------------------------------------------
    # CLI UTILITIES
    # ----------------------------------------------------------

    sd # Simple find & replace (better sed/awk)
    xh # HTTP client (modern httpie alternative, Rust)
    rsync # File sync / incremental copy
    file # Detect file type
    grex # Generate regex from examples
    hexyl # Hex viewer
    tailspin # Log viewer with auto-highlighting
    navi # Interactive cheatsheet (complements tealdeer)
    hyperfine # Statistical command-line benchmarking
    just # Modern task runner (a friendly make)
    gh-dash # GitHub dashboard TUI

    # ----------------------------------------------------------
    # NIX WORKFLOW
    # ----------------------------------------------------------

    nixd # Nix language server (LSP)
    nix-tree # Explore derivation dependency tree
    nvd # Diff two generations (what changed after rebuild)
    nix-search-tv # Search nixpkgs with fzf

    # ========================================================
    # 3) REFERENCE — kept but COMMENTED (live elsewhere)
    # ========================================================

    # --- Multiplexer ---
    # tmux is enabled & configured via programs.tmux in ./settings.nix

    # --- Provided by modules/terminal/fish.nix (terminal module) ---
    # eza bat ripgrep fd fzf carapace starship zoxide direnv
    # bottom jq nh nix-output-monitor grc yazi tealdeer glow
  ];
}
