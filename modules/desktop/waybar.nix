{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        margin-top = 8;
        margin-left = 12;
        margin-right = 12;
        spacing = 8;

        # Layout Arrangement
        modules-left = [ "custom/menu" "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ 
          "cpu" 
          "memory" 
          "backlight" 
          "pulseaudio" 
          "bluetooth" 
          "network" 
          "battery" 
          "niri/language" 
          "tray" 
        ];

        # --- Modules Configuration ---

        "custom/menu" = {
          format = ""; # NixOS Icon
          tooltip = false;
          on-click = "fuzzel"; # Application Launcher
        };

        "niri/workspaces" = {
          format = "{index}";
          active-only = false;
          all-outputs = true;
        };

        "niri/window" = {
          format = "{}";
          max-length = 30;
          separate-outputs = true;
        };

        "clock" = {
          format = "󱑂 {:%H:%M}";
          format-alt = "󰃭 {:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "backlight" = {
          device = "intel_backlight"; # Change to your GPU driver if needed
          format = "{icon} {percentage}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
        };

        "cpu" = {
          format = " {usage}%";
          interval = 2;
        };

        "memory" = {
          format = " {percentage}%";
          interval = 2;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 Muted";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol"; # Sound Mixer
        };

        "bluetooth" = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          on-click = "blueman-manager"; # Bluetooth Menu
        };

        "network" = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 Wired";
          format-disconnected = "󰖪 Off";
          on-click = "nm-connection-editor"; # WiFi Menu
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        "niri/language" = {
          format = "󰌌 {short}";
        };

        "tray" = {
          icon-size = 18;
          spacing = 10;
        };
      };
    };

    # --- Modern Glassmorphism CSS ---
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Vazirmatn";
        font-size: 13px;
        font-weight: bold;
      }

      window#waybar {
        background: rgba(24, 24, 37, 0.65); /* High transparency */
        color: #cdd6f4;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
        padding: 0 10px;
        margin: 4px 2px;
        color: #89b4fa;
        background: transparent;
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      #workspaces button.focused {
        background: #89b4fa;
        color: #1e1e2e;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
      }

      /* Style for each module "pill" */
      #clock, #cpu, #memory, #backlight, #pulseaudio, #bluetooth, #network, #battery, #language, #custom-menu {
        padding: 0 12px;
        margin: 4px 2px;
        background: rgba(49, 50, 68, 0.4);
        border-radius: 8px;
        border: 1px solid rgba(255, 255, 255, 0.05);
      }

      #custom-menu {
        color: #89b4fa;
        font-size: 18px;
        padding-right: 15px;
      }

      #battery.charging { color: #a6e3a1; }
      #battery.warning { color: #fab387; }
      #battery.critical { color: #f38ba8; }

      #language { color: #f5c2e7; }
    '';
  };
}
