{
  description = "Minimal Home Manager Starter Template with GNOME & Flatpak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."your-username" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-flatpak.homeManagerModules.nix-flatpak
          ./home.nix
        ];
      };
    };
}
