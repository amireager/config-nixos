{pkgs, ...}: {
  # ============================================================
  #  HOST: nixos  (this specific laptop)
  #
  #  Only machine-specific / personal config belongs here:
  #  hardware (GPU, power), kernel, bluetooth, and the personal
  #  DNS setup. The portable base lives in ./core.nix.
  # ============================================================

  # --- IMPORTS ---
  imports = [
    ./hardware-configuration.nix
    ./core.nix
    ./network.nix
  ];

  # --- HOSTNAME + PERSONAL DNS ---
  # Moved to ./network.nix

  # --- KERNEL ---
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "vm.swappiness" = 20;
    "vm.vfs_cache_pressure" = 50;
  };

  # --- SWAP ---
  # Without swap, OOM killer will terminate apps when RAM is full.
  # Option A: ZRAM (recommended for laptops with SSD)
  #   zramSwap.enable = true;
  #   zramSwap.memoryPercent = 50;
  # Option B: Swap file
  #   swapDevices = [{ device = "/swapfile"; size = 4096; }];

  # --- LAPTOP OPTIMIZATIONS: POWER & THERMAL ---
  services.tlp.enable = true;
  services.upower.enable = true;
  # powerManagement.enable = true;

  # --- HYBRID GRAPHICS: NVIDIA + AMD ---
  # (base hardware.graphics is enabled in system/core.nix)
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # GTX 1650 (Turing): GPU fully powers off when idle -> big battery savings
    powerManagement.finegrained = true;

    # TU117 chip (GTX 1650 Mobile) lacks GSP firmware, so open modules DO NOT work.
    # Therefore, we must explicitly set open = false to use the proprietary driver.
    open = false;

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
