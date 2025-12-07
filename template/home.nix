{ config, pkgs, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/flatpak.nix
    ./modules/gnome.nix
    ./modules/gnome-extensions-installer.nix
    ./modules/nix-just.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "your-username";
  home.homeDirectory = "/home/your-username";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
