{pkgs, ...}: {
  # --- KITTY TERMINAL CONFIGURATION ---
  programs.kitty = {
    enable = true;

    # --- FONT SETTINGS ---
    font = {
      # Ensure this matches the name in 'fc-list'
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    # --- APPEARANCE & BEHAVIOR ---
    settings = {
      # Transparency & Background
      background_opacity = "0.92";
      dynamic_background_opacity = "yes";
      background = "#0b0b0e";
      foreground = "#e0e0e0";

      # Window Layout
      window_padding_width = 4;
      confirm_os_window_close = 0;
      cursor_shape = "beam";

      # --- PERFORMANCE (Optimized for your Ryzen/Nvidia Setup) ---
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # --- CLEAN COLORS (16-color ANSI + Cursor) ---
      # Normal
      color0 = "#161617";
      color1 = "#eb6f92";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#cba6f7";
      color6 = "#94e2d5";
      color7 = "#cdd6f4";
      # Bright
      color8 = "#3b3b3b";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#cba6f7";
      color14 = "#94e2d5";
      color15 = "#bac2de";

      # Cursor & Selection
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";
      selection_foreground = "#1e1e2e";
      selection_background = "#f5e0dc";
    };

    # --- KEYBINDINGS ---
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };

  # Ensure the font is available for the system to pick up
  # Font also installed system-wide in core.nix — kept here for standalone use
  home.packages = [pkgs.nerd-fonts.jetbrains-mono];
}
