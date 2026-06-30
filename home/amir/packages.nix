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
    # MONITORING & SYSTEM OBSERVABILITY
    # ----------------------------------------------------------

    # --- Already managed via programs.* in settings.nix ---
    # btop          → CPU/RAM/Disk/Network monitor (main dashboard)
    # fastfetch     → System info fetch

    # --- Already provided by fish.nix module ---
    bottom # Alternative monitor (replaced by btop)

    # --- GPU Monitoring ---
    # nvtop # GPU monitor for Nvidia/AMD/Intel (GTX 1650 supported)

    # --- Network Monitoring ---
    nload # Live network throughput graph

    # --- Disk I/O ---
    iotop # Disk usage per process (needs sudo)
    dust # Disk usage tree (better du)
    duf # Pretty disk overview (better df)

    # --- CPU ---
    s-tui # CPU stress test + monitor (temp, freq, power)

    # --- Process Monitoring ---
    procs # Colored process list (better ps)

    # --- Find & Replace ---
    sd # Simple find & replace (better sed/awk)

    # --- Dev / productivity ---
    hyperfine # Statistical command-line benchmarking
    just # Modern task runner (a friendly make)
    httpie # Human-friendly HTTP client (API testing)
    tokei # Count lines of code (fast, accurate)
    strace # Trace system calls (debugging)
    socat # Multipurpose socket tool (network debug)
    gh-dash # GitHub dashboard TUI

    # --- Nix workflow ---
    nixd # Nix language server (LSP)
    nix-tree # Explore derivation dependency tree
    nvd # Diff two generations (what changed after rebuild)
    nix-init # Generate package expressions from a URL
    comma # Run any program without installing: , cowsay hi

    # ========================================================
    # 3) REFERENCE — kept but COMMENTED (live elsewhere)
    # ========================================================

    # --- Multiplexer ---
    # tmux is enabled & configured via programs.tmux in ./settings.nix
    # zellij                # alt multiplexer; sticking with tmux for now

    # --- Provided by modules/terminal/fish.nix (terminal module) ---
    # eza bat ripgrep fd fzf carapace starship zoxide direnv
    # bottom jq nh nix-output-monitor grc yazi tealdeer
    # (bottom is now redundant since btop is our main monitor)
  ];
}
