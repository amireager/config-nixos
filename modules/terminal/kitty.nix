{ pkgs, ... }:

{
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

      # --- CLEAN COLORS (Custom Dark Theme) ---
      color0 = "#161617";
      color8 = "#3b3b3b";
      color1 = "#eb6f92";
      color2 = "#a6e3a1";
      color4 = "#89b4fa";
      color5 = "#cba6f7";
    };

    # --- KEYBINDINGS ---
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };

  # Ensure the font is available for the system to pick up
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
}
