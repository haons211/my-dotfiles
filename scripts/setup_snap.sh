#!/bin/bash

# Snap Packages Setup Script
# Description: Installs snap and packages from snap_packages.txt

# Enable strict error handling
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Setup snap if not installed
setup_snap() {
    if command_exists snap; then
        log_info "Snap is already installed"
        return 0
    fi

    log_info "Snap is not installed. Installing snapd..."
    
    if ! sudo apt-get install -y snapd; then
        log_error "Failed to install snapd"
        return 1
    fi

    # Enable and start snapd service
    sudo systemctl enable snapd.service
    sudo systemctl start snapd.service

    # Create symbolic link for snap command
    if [[ ! -e /snap ]]; then
        sudo ln -sf /var/lib/snapd/snap /snap
    fi

    log_success "Snap installed successfully"
    
    # Add snap to PATH if not already there
    if ! echo "$PATH" | grep -q "/snap/bin"; then
        echo 'export PATH="$PATH:/snap/bin"' >> ~/.bashrc
        log_info "Added /snap/bin to PATH in ~/.bashrc"
    fi
}

# Install snap packages
install_snap_packages() {
    local packages_file="$1"
    
    log_info "Installing snap packages from $packages_file..."

    local failed_packages=()
    local installed_count=0

    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
            continue
        fi

        # Extract package name and options
        local package_info="$line"
        local package_name=$(echo "$package_info" | awk '{print $1}')
        
        if [[ -n "$package_name" ]]; then
            log_info "Installing: $package_info"
            
            if sudo snap install $package_info; then
                log_success "Installed: $package_name"
                ((installed_count++))
            else
                log_error "Failed to install: $package_name"
                failed_packages+=("$package_name")
            fi
        fi
    done < <(grep -vE '^\s*#|^\s*$' "$packages_file")

    # Summary
    log_info "Installation summary:"
    echo "  Successfully installed: $installed_count packages"
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        echo "  Failed packages: ${failed_packages[*]}"
        return 1
    fi
    
    return 0
}

main() {
    log_info "Starting snap packages setup..."

    # Get the directory of this script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SNAP_PACKAGES_FILE="$SCRIPT_DIR/snap_packages.txt"

    # Check if snap packages file exists
    if [[ ! -f "$SNAP_PACKAGES_FILE" ]]; then
        log_error "File snap_packages.txt not found at $SNAP_PACKAGES_FILE"
        exit 1
    fi

    # Setup snap first
    setup_snap

    # Wait a moment for snap to be ready
    sleep 2

    # Install packages
    install_snap_packages "$SNAP_PACKAGES_FILE"

    log_success "Snap packages setup completed!"
}

# Run main function
main "$@"