# ============================================================
#  NOTIFICATIONS
#
#  Handled by Noctalia's built-in notification system.
#  This file only provides libnotify (notify-send command).
# ============================================================
{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify
  ];
}
