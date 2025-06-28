#!/bin/bash

# Docker Setup Script
# Description: Installs Docker CE with proper configuration

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

# Detect OS distribution
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# Install Docker
install_docker() {
    local os_id=$(detect_os)
    
    log_info "Detected OS: $os_id"
    
    if command_exists docker; then
        log_warning "Docker is already installed"
        docker --version
        return 0
    fi

    log_info "Installing Docker CE..."

    # Install prerequisites
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    
    # Determine the correct repository URL based on OS
    local repo_url
    case "$os_id" in
        "ubuntu")
            repo_url="https://download.docker.com/linux/ubuntu"
            ;;
        "debian")
            repo_url="https://download.docker.com/linux/debian"
            ;;
        *)
            log_warning "Unknown OS, trying Ubuntu repository"
            repo_url="https://download.docker.com/linux/ubuntu"
            ;;
    esac

    # Download and install GPG key
    if ! curl -fsSL "$repo_url/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg; then
        log_error "Failed to download Docker GPG key"
        return 1
    fi

    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $repo_url \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package index
    sudo apt-get update

    # Install Docker packages
    if ! sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
        log_error "Failed to install Docker packages"
        return 1
    fi

    log_success "Docker installed successfully"
}

# Configure Docker for current user
configure_docker() {
    log_info "Configuring Docker for user: $USER"

    # Add user to docker group
    if ! groups "$USER" | grep -q docker; then
        sudo usermod -aG docker "$USER"
        log_success "Added $USER to docker group"
        log_warning "Please log out and back in for group changes to take effect"
    else
        log_info "User $USER is already in docker group"
    fi

    # Enable and start Docker service
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    sudo systemctl start docker.service

    log_success "Docker service configured and started"
}

# Test Docker installation
test_docker() {
    log_info "Testing Docker installation..."

    # Test docker command (may need sudo if user hasn't logged out/in)
    if sudo docker run --rm hello-world >/dev/null 2>&1; then
        log_success "Docker test completed successfully"
    else
        log_warning "Docker test failed - this might be normal if user needs to re-login"
    fi

    # Show Docker version
    sudo docker --version
    sudo docker compose version
}

main() {
    log_info "Starting Docker installation..."

    install_docker
    configure_docker
    test_docker

    log_success "Docker setup completed!"
    log_info "Note: You may need to log out and back in for Docker group permissions to take effect"
}

# Run main function
main "$@"