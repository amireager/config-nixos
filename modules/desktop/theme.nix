{ pkgs, ... }:

{
  # --- CURSOR ---
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  # --- GTK THEME (GTK3/4 apps: Thunar, Telegram, ...) ---
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Vazirmatn";
      size = 11;
    };
  };

  # --- QT THEME (Qt apps: vlc, qt-based tools) ---
  # Makes Qt apps follow the dark theme instead of showing up white
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
