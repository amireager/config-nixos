{ config, pkgs, inputs, ... }:

{
  # --- SYSTEM IMPORTS ---
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/niri/niri-system.nix
  ];

  # --- NIXOS CORE CONFIGURATION ---
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    # Binary cache for niri (avoids compiling from source on every update)
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # --- BOOTLOADER & KERNEL SETTINGS ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- LAPTOP OPTIMIZATIONS: POWER & THERMAL ---
  services.tlp.enable = true;
  services.upower.enable = true;
  powerManagement.enable = true;

  # --- HYBRID GRAPHICS: NVIDIA + AMD ---
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # GTX 1650 (Turing): GPU fully powers off when idle -> big battery savings
    powerManagement.finegrained = true;

    # GTX 1650 is Turing (TU117) -> open kernel modules are supported & recommended
    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Adds the 'nvidia-offload <app>' command
      };
      amdgpuBusId = "PCI:4:0:0"; # Verify using: lspci | grep -i vga
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # --- NETWORKING CONFIGURATION ---
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      # Prevent NetworkManager from overwriting /etc/resolv.conf
      dns = "none";
    };
    # Force the system to use the local SmartDNS server
    nameservers = [ "127.0.0.1" ];
  };

  # --- SMARTDNS SERVICE ---
  services.smartdns = {
    enable = true;
    settings = {
      # Upstream servers: Default group (General)
      server = [
        "1.1.1.1"
        "8.8.8.8"
        # Shecan DNS servers assigned to a specific group
        "178.22.122.100 -group shecan -exclude-default-list"
        "185.51.200.2 -group shecan -exclude-default-list"
      ];

      # Domain rules to route specific traffic through Shecan
      domain-rules = [
        "/google.com/ /gemini.google.com/ /googleusercontent.com/ -nameserver shecan"
      ];

      # Performance and security tweaks
      bind = [ "127.0.0.1" ]; # Listen only on localhost
      prefetch-domain = "yes";
      serve-expired = "yes";
      cache-size = 4096;
    };
  };

  # --- BLUETOOTH ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true; # System D-Bus service required by blueman GUI

  # --- SECURITY & SESSION SERVICES ---
  # PAM entry so swaylock can actually verify your password (CRITICAL!)
  security.pam.services.swaylock = { };
  # Authentication dialogs for GUI apps (mounting disks, network changes, ...)
  security.polkit.enable = true;

  # --- FILE MANAGER (SYSTEM LEVEL) ---
  # Thunar needs system D-Bus services for mounting/trash; HM can't provide them
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true; # USB drives, MTP (phones), Trash support
  services.tumbler.enable = true; # Thumbnails for images/videos

  # --- USER SETUP & SHELL CONFIGURATION ---
  users.users.amir = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "libvirtd" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # --- SYSTEM FONTS ---
  fonts.packages = with pkgs; [
    vazir-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # --- TIMEZONE AND LOCALIZATION ---
  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us,ir";
    options = "grp:alt_shift_toggle";
  };

  # --- MINIMAL SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    vim git gh wget curl pciutils
  ];

  system.stateVersion = "25.11";
}
