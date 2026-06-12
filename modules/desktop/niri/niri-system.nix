{ pkgs, inputs, ... }:

{
  # --- NIRI COMPOSITOR SYSTEM SETUP ---
  # Enable the Niri window manager using the flake input for the latest updates
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  # --- DISPLAY MANAGER (SDDM) ---
  # Standard Wayland-ready login manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # --- AUDIO INFRASTRUCTURE (PIPEWIRE) ---
  # Real-time audio priority for better performance
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # Useful for professional audio work
  };

  # --- HARDWARE & DRIVER COMPATIBILITY ---
  # Ensuring GPU and input devices work correctly under Niri
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # --- SYSTEM-WIDE UTILITIES ---
  environment.systemPackages = with pkgs; [
    wayland-utils
    glib # Required for gsettings/theming
    gnome-settings-daemon # Helpful for GTK consistency
    pciutils # Helpful for hardware debugging (lspci)
  ];
}
