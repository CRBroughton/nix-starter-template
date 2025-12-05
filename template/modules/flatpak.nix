{ ... }:

{
  # Flatpak applications - declaratively managed via nix-flatpak
  #
  # Find apps at: https://flathub.org
  #
  # The app ID is at the end of the URL. For example:
  #   https://flathub.org/apps/com.spotify.Client
  #   The ID is: com.spotify.Client
  #
  # After adding apps, run:
  #   home-manager switch --flake .#your-username

  services.flatpak.enable = true;
  services.flatpak.packages = [
    # Example: GNOME Extension Manager for managing extensions
    "com.mattjakeman.ExtensionManager"

    # Add more apps here, e.g.:
    # "org.mozilla.firefox"
    # "com.spotify.Client"
    # "org.gimp.GIMP"
  ];
}
