#!/bin/bash

# Dotfiles Installation Script
# Author: haons211
# Description: Automated environment setup for development tools and applications

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

# Function to check if script exists and is executable
check_script() {
    local script_path="$1"
    if [[ ! -f "$script_path" ]]; then
        log_error "Script not found: $script_path"
        return 1
    fi
    if [[ ! -x "$script_path" ]]; then
        log_info "Making script executable: $script_path"
        chmod +x "$script_path"
    fi
    return 0
}

# Function to run script with error handling
run_script() {
    local script_path="$1"
    local description="$2"
    
    log_info "Starting: $description"
    if check_script "$script_path" && bash "$script_path"; then
        log_success "Completed: $description"
        return 0
    else
        log_error "Failed: $description"
        return 1
    fi
}

# Main installation function
main() {
    log_info "Starting the environment installation..."
    log_info "Detected OS: $(uname -s) $(uname -r)"

    # Get the directory of this script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SCRIPTS_DIR="$SCRIPT_DIR/scripts"

    # Step 1: Detect OS
    OS=$(uname -s)

    case $OS in
        "Linux")
            log_info "Linux detected - proceeding with Linux setup"
            
            # Update system first
            log_info "Updating system packages..."
            sudo apt-get update && sudo apt-get upgrade -y
            
            # Core system setup
            run_script "$SCRIPTS_DIR/setup_linux.sh" "Core system packages installation"
            
            
            # Snap packages installation
            run_script "$SCRIPTS_DIR/setup_snap.sh" "Snap packages installation"
            
            # Application installations
            run_script "$SCRIPTS_DIR/application/setup_docker.sh" "Docker installation"
            run_script "$SCRIPTS_DIR/application/setup_brave.sh" "Brave browser installation"
            
            log_success "Linux environment setup completed successfully!"
            ;;
        "Darwin")
            log_warning "macOS detected but not yet supported"
            log_info "You can extend this script to support macOS"
            exit 1
            ;;
        *)
            log_error "Unsupported OS: $OS"
            log_info "Supported operating systems: Linux"
            exit 1
            ;;
    esac

    log_success "All installations completed successfully!"
    log_info "Please restart your terminal or run 'source ~/.bashrc' to apply changes"
}

# Check if running as root (not recommended)
if [[ $EUID -eq 0 ]]; then
    log_warning "Running as root is not recommended for this script"
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled"
        exit 1
    fi
fi

# Run main function
main "$@"

