#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    print_error "Template directory not found at: $TEMPLATE_DIR"
    exit 1
fi

# Get username from environment
USERNAME="${USER:-$(whoami)}"
HOME_DIR="${HOME:-/home/$USERNAME}"

echo ""
print_info "Nix Home Manager Configuration Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_info "Detected username: $USERNAME"
print_info "Detected home directory: $HOME_DIR"
echo ""

# Ask for confirmation
read -p "Is this information correct? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    read -p "Enter your username: " USERNAME
    read -p "Enter your home directory (default: /home/$USERNAME): " CUSTOM_HOME
    if [ -n "$CUSTOM_HOME" ]; then
        HOME_DIR="$CUSTOM_HOME"
    else
        HOME_DIR="/home/$USERNAME"
    fi
fi

echo ""
print_info "Using username: $USERNAME"
print_info "Using home directory: $HOME_DIR"
echo ""

# Copy files to the same directory as the script
print_info "Copying configuration files..."

# Copy flake.nix
cp "$TEMPLATE_DIR/flake.nix" "$SCRIPT_DIR/flake.nix"
sed -i "s/your-username/$USERNAME/g" "$SCRIPT_DIR/flake.nix"
print_success "Created flake.nix"

# Copy home.nix
cp "$TEMPLATE_DIR/home.nix" "$SCRIPT_DIR/home.nix"
sed -i "s/your-username/$USERNAME/g" "$SCRIPT_DIR/home.nix"
sed -i "s|/home/your-username|$HOME_DIR|g" "$SCRIPT_DIR/home.nix"
print_success "Created home.nix"

# Copy justfile
cp "$TEMPLATE_DIR/justfile" "$SCRIPT_DIR/justfile"
print_success "Created justfile"

# Create modules directory if it doesn't exist
mkdir -p "$SCRIPT_DIR/modules"

# Copy module files
cp "$TEMPLATE_DIR/modules/packages.nix" "$SCRIPT_DIR/modules/packages.nix"
print_success "Created modules/packages.nix"

cp "$TEMPLATE_DIR/modules/flatpak.nix" "$SCRIPT_DIR/modules/flatpak.nix"
print_success "Created modules/flatpak.nix"

cp "$TEMPLATE_DIR/modules/gnome.nix" "$SCRIPT_DIR/modules/gnome.nix"
print_success "Created modules/gnome.nix"

cp "$TEMPLATE_DIR/modules/gnome-extensions-installer.nix" "$SCRIPT_DIR/modules/gnome-extensions-installer.nix"
print_success "Created modules/gnome-extensions-installer.nix"

cp "$TEMPLATE_DIR/modules/nix-just.nix" "$SCRIPT_DIR/modules/nix-just.nix"
sed -i "s|nix-configuration|$(basename "$SCRIPT_DIR")|g" "$SCRIPT_DIR/modules/nix-just.nix"
print_success "Created modules/nix-just.nix"

echo ""
print_success "Configuration files created successfully!"
echo ""
print_info "Next steps:"
echo "  1. Read the README.md for detailed instructions and explanations"
echo ""
echo "  2. Review and customize the configuration files:"
echo "     - modules/packages.nix (add Nix packages)"
echo "     - modules/flatpak.nix (add Flatpak apps)"
echo "     - modules/gnome.nix (customize GNOME settings)"
echo ""
echo "  3. Commit your Nix configuration:"
echo "     - git add ."
echo "     - git commit -m 'Initial Nix configuration'"
echo ""
echo "  4. Apply the configuration:"
echo -e "     ${GREEN}nix run home-manager/master -- switch --flake .#$USERNAME -b backup${NC}"
echo ""
echo "  5. After applying, install GNOME extensions:"
echo -e "     ${GREEN}install-gnome-extensions${NC}"
echo ""
print_warning "Remember to back up your configuration!"
echo "  - Use Git and push to GitHub/GitLab (recommended)"
echo "  - Or copy this folder to a USB stick"
echo "  - See README.md for detailed backup instructions"
echo ""
