{pkgs, ...}: {
  # ============================================================
  #  HOST: nixos  (this specific laptop)
  #
  #  Only machine-specific / personal config belongs here:
  #  hardware (GPU, power), kernel, bluetooth, and the personal
  #  DNS setup. The portable base lives in ../../system/core.nix.
  # ============================================================

  # --- IMPORTS ---
  imports = [
    ./hardware-configuration.nix
    ./core.nix
  ];

  # --- HOSTNAME + PERSONAL DNS ---
  networking = {
    hostName = "nixos";
    networkmanager = {
      # Don't let NetworkManager overwrite /etc/resolv.conf; we run smartdns.
      dns = "none";
    };
    # Force the system to use the local SmartDNS server.
    nameservers = ["127.0.0.1"];
  };

  # --- SMARTDNS SERVICE (personal: Iran routing via Shecan) ---
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
      bind = ["127.0.0.1"]; # Listen only on localhost
      prefetch-domain = "yes";
      serve-expired = "yes";
      cache-size = 4096;
    };
  };

  # --- KERNEL ---
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- LAPTOP OPTIMIZATIONS: POWER & THERMAL ---
  services.tlp.enable = true;
  services.upower.enable = true;
  powerManagement.enable = true;

  # --- HYBRID GRAPHICS: NVIDIA + AMD ---
  # (base hardware.graphics is enabled in system/core.nix)
  services.xserver.videoDrivers = ["nvidia"];

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

  # --- BLUETOOTH ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true; # System D-Bus service required by blueman GUI
}
