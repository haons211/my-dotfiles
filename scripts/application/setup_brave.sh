#!/bin/bash

# Brave Browser Setup Script
# Description: Installs Brave browser with proper repository setup

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

# Install Brave browser
install_brave() {
    if command_exists brave-browser; then
        log_warning "Brave browser is already installed"
        brave-browser --version 2>/dev/null || echo "Brave browser is installed"
        return 0
    fi

    log_info "Installing Brave browser..."

    # Install curl if not present
    if ! command_exists curl; then
        log_info "Installing curl..."
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    # Download and install Brave's signing key
    log_info "Adding Brave browser repository..."
    
    if ! sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg; then
        log_error "Failed to download Brave signing key"
        return 1
    fi

    # Add Brave repository to sources
    if ! sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources \
        https://brave-browser-apt-release.s3.brave.com/brave-browser.sources; then
        log_error "Failed to add Brave repository"
        return 1
    fi

    # Update package list
    log_info "Updating package list..."
    if ! sudo apt-get update; then
        log_error "Failed to update package list"
        return 1
    fi

    # Install Brave browser
    log_info "Installing Brave browser package..."
    if ! sudo apt-get install -y brave-browser; then
        log_error "Failed to install Brave browser"
        return 1
    fi

    log_success "Brave browser installed successfully"
    
    # Verify installation
    if command_exists brave-browser; then
        log_success "Brave browser is ready to use"
    else
        log_warning "Brave browser installed but command not found in PATH"
    fi
}

main() {
    log_info "Starting Brave browser installation..."

    install_brave

    log_success "Brave browser setup completed!"
    log_info "You can now launch Brave browser from your applications menu or by running 'brave-browser'"
}

# Run main function
main "$@"