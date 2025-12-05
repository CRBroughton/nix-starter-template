#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Get username from environment
USERNAME="${USER:-$(whoami)}"
HOME_DIR="${HOME:-/home/$USERNAME}"

echo ""
print_info "Update Username Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_info "This script will update your username and home directory in:"
echo "  - flake.nix"
echo "  - home.nix"
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

# Check if files exist
if [ ! -f "flake.nix" ]; then
    print_error "flake.nix not found in current directory"
    exit 1
fi

if [ ! -f "home.nix" ]; then
    print_error "home.nix not found in current directory"
    exit 1
fi

# Update flake.nix - replace any homeConfigurations."*" with new username
print_info "Updating flake.nix..."
sed -i "s/homeConfigurations\\.\"[^\"]*\"/homeConfigurations.\"$USERNAME\"/" flake.nix
print_success "Updated flake.nix"

# Update home.nix - replace username and home directory
print_info "Updating home.nix..."
sed -i "s/home\\.username = \"[^\"]*\"/home.username = \"$USERNAME\"/" home.nix
sed -i "s|home\\.homeDirectory = \"[^\"]*\"|home.homeDirectory = \"$HOME_DIR\"|" home.nix
print_success "Updated home.nix"

echo ""
print_success "Username and home directory updated successfully!"
echo ""
print_info "Next step:"
echo "  Run: ${GREEN}home-manager switch --flake .#$USERNAME${NC}"
echo ""
