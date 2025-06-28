#!/bin/bash

# Linux Core Packages Setup Script
# Description: Installs essential packages from apt_packages.txt

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

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

main() {
    log_info "Setting up Linux core packages..."

    # Get the directory of this script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PACKAGES_FILE="$SCRIPT_DIR/apt_packages.txt"

    # Check if packages file exists
    if [[ ! -f "$PACKAGES_FILE" ]]; then
        log_error "File apt_packages.txt not found at $PACKAGES_FILE"
        exit 1
    fi

    log_info "Installing packages from $PACKAGES_FILE..."

    # Read packages and install them
    if ! grep -vE '^\s*#|^\s*$' "$PACKAGES_FILE" | xargs --no-run-if-empty sudo apt-get install -y; then
        log_error "Failed to install some packages"
        exit 1
    fi

    log_success "Core Linux packages installation complete!"
}

# Run main function
main "$@"