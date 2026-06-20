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
    tor-browser

    # --- Multimedia (view & play) ---
    imv # Image viewer (Wayland native)
    mpv # Video/audio player
    # vlc # Heavy-duty fallback player
    playerctl # Media keys control (play/pause from keyboard)

    # --- Documents ---
    zathura # Lightweight vim-style PDF viewer
    poppler-utils # PDF CLI tools (pdftotext, ...)

    # --- Archives (thunar-archive-plugin NEEDS a real archive tool!) ---
    xarchiver
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

    # --- Modern replacements ---
    dust # `du` replacement — disk-usage tree
    duf # `df` replacement — pretty mounted-disk overview
    procs # `ps` replacement — colored process list
    sd # `sed`/`awk` replacement — dead-simple find & replace

    # --- Dev / productivity ---
    hyperfine # Statistical command-line benchmarking
    just # Modern task runner (a friendly `make`)

    # --- Monitoring ---
    # nvtop # GPU monitor (Nvidia/AMD/Intel) — btop handles CPU/RAM

    # --- Nix workflow ---
    nixd # Nix language server (LSP)
    nix-tree # Explore a derivation's dependency tree
    nvd # Diff two generations (what changed after a rebuild)
    nix-init # Generate package expressions from a URL
    comma # Run any program without installing: `, cowsay hi`

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
    adwaita-qt
    adwaita-qt6
  ];
}
