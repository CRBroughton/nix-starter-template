{ pkgs, config, lib, ... }:

let
  # TOGGLE: Set to true to enable global just wrapper (run from anywhere)
  # To enable easily, run: enable-just-support
  enableGlobalJustWrapper = false;

  configDir = "${config.home.homeDirectory}/my-nix-config";

  justWrapper = pkgs.writeShellScriptBin "just" ''
    # Global just wrapper - always uses your nix config justfile
    CONFIG_DIR="${configDir}"

    if [ ! -d "$CONFIG_DIR" ]; then
      echo "Error: Config directory not found at $CONFIG_DIR"
      echo "Update configDir in modules/just-wrapper.nix to match your config location"
      exit 1
    fi

    if [ ! -f "$CONFIG_DIR/justfile" ]; then
      echo "Error: justfile not found at $CONFIG_DIR/justfile"
      exit 1
    fi

    # Run just with the config directory's justfile
    exec ${pkgs.just}/bin/just --justfile "$CONFIG_DIR/justfile" --working-directory "$CONFIG_DIR" "$@"
  '';

  enableJustSupportScript = pkgs.writeShellScriptBin "enable-just-support" ''
    # Colors for output
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color

    WRAPPER_FILE="${configDir}/modules/just-wrapper.nix"

    echo ""
    echo -e "''${BLUE}Enabling Global Just Support''${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ ! -f "$WRAPPER_FILE" ]; then
        echo -e "''${YELLOW}Error: just-wrapper.nix not found at $WRAPPER_FILE''${NC}"
        exit 1
    fi

    # Check if already enabled
    if grep -q "enableGlobalJustWrapper = true" "$WRAPPER_FILE"; then
        echo -e "''${GREEN}✓''${NC} Global just support is already enabled!"
        echo ""
        echo "Run 'home-manager switch --flake ${configDir}' to apply if you haven't already."
        exit 0
    fi

    # Enable the wrapper
    ${pkgs.gnused}/bin/sed -i 's/enableGlobalJustWrapper = false/enableGlobalJustWrapper = true/' "$WRAPPER_FILE"

    echo -e "''${GREEN}✓''${NC} Global just support enabled!"
    echo ""
    echo "What this means:"
    echo "  - You can now run 'just' commands from anywhere"
    echo "  - They will always use your Nix config's justfile"
    echo "  - No need to cd into your config directory"
    echo ""
    echo -e "''${YELLOW}Important:''${NC} You must now run:"
    echo -e "  ''${GREEN}home-manager switch --flake ${configDir}''${NC}"
    echo ""
    echo "This will activate the global just wrapper."
    echo ""
  '';
in
{
  # Always install the enable script, only install wrapper if enabled
  home.packages = [ enableJustSupportScript ]
    ++ lib.optionals enableGlobalJustWrapper [ justWrapper ];
}
