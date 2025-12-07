{ pkgs, ... }:

{
  # Packages to install directly via Nix
  #
  # Find packages at: https://search.nixos.org/packages
  #
  # After adding packages, run:
  #   home-manager switch --flake .#your-username
  #
  # Note: Some packages (especially GUI apps) may require logging out
  # and back in before they appear in your application menu.

  home.packages = with pkgs; [
    # Package management tools (enabled by default)
    just                 # Command runner for common tasks
    nix-search-cli       # Fast package search tool
    nixfmt-rfc-style     # Nix code formatter

    # Example packages - uncomment or add your own:

    # Development tools
    # git
    # vim
    # neovim
    # vscode

    # Terminal utilities
    # htop
    # tree
    # curl
    # wget

    # System tools
    # gnome.gnome-tweaks
    # dconf-editor

    # Media
    # vlc
    # gimp
    # inkscape
  ];
}
