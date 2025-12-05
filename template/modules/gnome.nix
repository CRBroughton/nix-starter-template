{ pkgs, lib, ... }:

{
  # Refresh GNOME app cache after home-manager switch
  # This ensures Flatpak apps appear in GNOME's app launcher
  home.activation.refreshGnomeApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if command -v update-desktop-database &> /dev/null; then
      ${pkgs.desktop-file-utils}/bin/update-desktop-database ~/.local/share/applications 2>/dev/null || true
    fi
  '';

  # GNOME dconf settings for customization
  dconf.settings = {
    # Example: Set favorite apps in GNOME dock
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        # Add your favorite apps here
      ];

      # Enable GNOME extensions (install them first using install-gnome-extensions)
      enabled-extensions = [
        # Example extensions:
        # "tilingshell@ferrarodomenico.com"
        # "blur-my-shell@aunetx"
        # "caffeine@patapon.info"
      ];
    };

    # Example: More GNOME customizations
    # "org/gnome/desktop/interface" = {
    #   color-scheme = "prefer-dark";
    #   gtk-theme = "Adwaita-dark";
    # };
  };
}
