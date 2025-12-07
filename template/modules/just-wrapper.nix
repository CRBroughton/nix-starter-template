{ pkgs, config, ... }:

{
  # Create a wrapper script that overrides 'just' to always use the config directory
  home.packages = [
    (pkgs.writeShellScriptBin "just" ''
      # Global just wrapper - always uses your nix config justfile
      CONFIG_DIR="${config.home.homeDirectory}/my-nix-config"

      if [ ! -d "$CONFIG_DIR" ]; then
        echo "Error: Config directory not found at $CONFIG_DIR"
        echo "Update CONFIG_DIR in modules/just-wrapper.nix to match your config location"
        exit 1
      fi

      if [ ! -f "$CONFIG_DIR/justfile" ]; then
        echo "Error: justfile not found at $CONFIG_DIR/justfile"
        exit 1
      fi

      # Run just with the config directory's justfile
      exec ${pkgs.just}/bin/just --justfile "$CONFIG_DIR/justfile" --working-directory "$CONFIG_DIR" "$@"
    '')
  ];
}
