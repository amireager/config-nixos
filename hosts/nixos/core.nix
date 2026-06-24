{
  pkgs,
  inputs,
  username,
  ...
}: {
  # ============================================================
  #  CORE SYSTEM  (universal / reusable — every machine)
  #
  #  Lives OUTSIDE modules/ on purpose: modules/ is for user
  #  (home-manager) config only; system/ is for NixOS config.
  #
  #  Anything portable that should make sense on ANY machine you
  #  run goes here. Hardware- and personal-specific bits live in
  #  hosts/<host>/configuration.nix.
  # ============================================================

  # --- NIX / NIXPKGS ---
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;

    # Binary cache for niri (avoids compiling from source).
    substituters = ["https://niri.cachix.org"];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # --- BOOTLOADER (UEFI, generic) ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================
  #  DESKTOP STACK (Niri + login + audio + graphics)
  # ============================================================

  # --- NIRI COMPOSITOR ---
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  # --- DISPLAY MANAGER (SDDM, Wayland) ---
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # --- AUDIO (PipeWire) ---
  security.rtkit.enable = true; # real-time priority for low-latency audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # professional audio work
  };

  # --- GRAPHICS (base; vendor driver is per-host) ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ============================================================
  #  SECURITY / SESSION
  # ============================================================
  # PAM entry so swaylock can verify your password (CRITICAL!)
  security.pam.services.swaylock = {};
  # Authentication dialogs for GUI apps (mounting disks, etc.)
  security.polkit.enable = true;

  # --- FILE MANAGER (SYSTEM LEVEL) ---
  # Thunar needs system D-Bus services for mounting/trash; HM can't provide them.
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true; # USB drives, MTP (phones), Trash support
  services.tumbler.enable = true; # Thumbnails for images/videos

  # ============================================================
  #  USER / SHELL / FONTS / LOCALE
  # ============================================================
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "video" "audio"]; # "docker" "libvirtd"
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # virtualisation.docker.enable = true;
  # virtualisation.libvirtd.enable = true;

  fonts.packages = with pkgs; [
    vazir-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us,ir";
    options = "grp:alt_shift_toggle";
  };

  # ============================================================
  #  SYSTEM PACKAGES
  # ============================================================
  environment.systemPackages = with pkgs; [
    # Base CLI
    vim
    git
    gh
    wget
    pciutils

    home-manager

    # Desktop/Wayland helpers (needed by the Niri session)
    wayland-utils
    glib # gsettings / theming
    gsettings-desktop-schemas # GTK consistency
  ];

  # ============================================================
  #  NIX HELPER (nh) - The modern way to manage NixOS
  # ============================================================
  programs.nh = {
    enable = true;
    flake = "/home/${username}/config-nixos";

    # Auto-cleanup for older generations
    clean = {
      enable = true;
      extraArgs = "--keep-since 10d --keep 3";
    };
  };

  # NixOS release this config was written against. Keep stable.
  system.stateVersion = "24.11";
}
