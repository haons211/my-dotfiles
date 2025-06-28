#!/bin/bash

# Programming Environment Setup Script
# Description: Sets up Java 21, Node.js, and Python development environments

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

# Function to get installed version
get_version() {
    local cmd="$1"
    case "$cmd" in
        "java")
            java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}' | awk -F '.' '{print $1}'
            ;;
        "node")
            node -v 2>/dev/null | sed 's/v//' | awk -F '.' '{print $1}'
            ;;
        "python3")
            python3 --version 2>/dev/null | awk '{print $2}' | awk -F '.' '{print $1"."$2}'
            ;;
    esac
}

# Setup Java 21
setup_java() {
    log_info "Setting up Java 21..."
    
    if command_exists java; then
        local current_version=$(get_version java)
        if [[ "$current_version" == "21" ]]; then
            log_warning "Java 21 is already installed"
            return 0
        else
            log_info "Java $current_version is installed, upgrading to Java 21..."
        fi
    fi

    if ! sudo apt-get install -y openjdk-21-jdk; then
        log_error "Failed to install Java 21"
        return 1
    fi

    # Set Java 21 as default
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-21-openjdk-amd64/bin/java 1
    sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java

    log_success "Java 21 installed and configured successfully"
    java -version
}

# Setup Node.js (using NodeSource repository for latest LTS)
setup_nodejs() {
    log_info "Setting up Node.js..."
    
    if command_exists node; then
        local current_version=$(get_version node)
        log_info "Node.js $current_version is already installed"
        if [[ "$current_version" -ge "18" ]]; then
            log_warning "Node.js version is acceptable, skipping installation"
            return 0
        fi
    fi

    # Install Node.js using NodeSource repository for latest LTS
    log_info "Installing Node.js LTS..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    
    if ! sudo apt-get install -y nodejs; then
        log_error "Failed to install Node.js"
        return 1
    fi

    # Install npm if not present
    if ! command_exists npm; then
        sudo apt-get install -y npm
    fi

    log_success "Node.js installed successfully"
    node -v && npm -v
}

# Setup Python 3.12
setup_python() {
    log_info "Setting up Python 3.12..."
    
    if command_exists python3; then
        local current_version=$(get_version python3)
        log_info "Python $current_version is already installed"
        if [[ "$current_version" == "3.12" ]]; then
            log_warning "Python 3.12 is already installed"
            return 0
        fi
    fi

    # Add deadsnakes PPA for Python 3.12
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update

    if ! sudo apt-get install -y python3.12 python3.12-pip python3.12-venv; then
        log_error "Failed to install Python 3.12"
        return 1
    fi

    # Set Python 3.12 as default python3
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

    log_success "Python 3.12 installed successfully"
    python3 --version
}

main() {
    log_info "Starting programming environment setup..."
    
    # Setup each environment
    setup_java
    setup_nodejs  
    setup_python
    
    log_success "Programming environment setup completed!"
    log_info "Installed versions:"
    echo "  Java: $(java -version 2>&1 | head -n 1)"
    echo "  Node.js: $(node -v 2>/dev/null || echo 'Not available')"
    echo "  Python: $(python3 --version 2>/dev/null || echo 'Not available')"
}

# Run main function
main "$@"