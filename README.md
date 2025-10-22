# My Dotfiles - Automated Development Environment Setup
aa aaa qqqq
An automated setup system for configuring a complete development environment on Linux systems.
aaaa

## 🚀 Features

This automation script will install and configure:

### Core System Tools
- Essential system utilities (curl, wget, git, vim, htop, tree, etc.)
- Build tools and development dependencies
- System monitoring tools

### Programming Languages
- **Java 21** (OpenJDK with proper alternatives configuration)
- **Node.js LTS** (via NodeSource repository)
- **Python 3.12** (via deadsnakes PPA with pip and venv)

### Applications via APT
- Flameshot (screenshot tool)
- VLC media player
- Neofetch (system information)

### Applications via Snap
- Obsidian (note-taking)
- Discord (communication)
- IntelliJ IDEA Ultimate (IDE)
- DataGrip (database tool)
- Redis Insight (Redis GUI)

### Containerization
- **Docker CE** with Docker Compose
- Proper user permissions and service configuration

### Web Browsers
- **Brave Browser** (privacy-focused browser)

## 📋 Requirements

- **Operating System**: Ubuntu/Debian-based Linux distributions
- **User Privileges**: sudo access required
- **Internet Connection**: Required for downloading packages and repositories

## 🔧 Installation

### Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Make the installer executable
chmod +x install.sh

# Run the automated setup
./install.sh
```

### Manual Component Installation

You can also run individual setup scripts:

```bash
# Core system packages
./scripts/setup_linux.sh

# Programming environments
./scripts/setup_environment.sh

# Snap packages
./scripts/setup_snap.sh

# Docker
./scripts/application/setup_docker.sh

# Brave browser
./scripts/application/setup_brave.sh
```

## 📂 Project Structure

```
my-dotfiles/
├── install.sh                          # Main installation script
├── scripts/
│   ├── setup_linux.sh                  # Core system packages
│   ├── setup_environment.sh            # Programming languages
│   ├── setup_snap.sh                   # Snap packages
│   ├── apt_packages.txt                # APT packages list
│   ├── snap_packages.txt               # Snap packages list
│   └── application/
│       ├── setup_docker.sh             # Docker installation
│       └── setup_brave.sh              # Brave browser installation
└── README.md                           # This file
```

## ✨ Features

### 🛡️ Error Handling
- Strict error handling with `set -euo pipefail`
- Comprehensive logging with colored output
- Individual component failure handling
- Pre-installation checks for existing software

### 🎨 User Experience
- Colored terminal output for better readability
- Progress indicators and status messages
- Clear success/failure reporting
- Installation summaries

### 🔧 Smart Installation
- Detects already installed software
- Version checking for programming languages
- Automatic service configuration (Docker, snap)
- User permission setup (Docker group)

### 📦 Package Management
- Organized package lists with comments
- Support for package options (snap classic mode)
- Skips empty lines and comments in package files
- Batch installation with error tracking

## 🔍 Verification

After installation, verify your setup:

```bash
# Check programming languages
java -version
node -v
python3 --version

# Check applications
docker --version
brave-browser --version
snap list

# Check services
systemctl status docker
systemctl status snapd
```

## 🔧 Customization

### Adding APT Packages
Edit `scripts/apt_packages.txt`:
```
# Add your packages here
package-name
another-package
```

### Adding Snap Packages
Edit `scripts/snap_packages.txt`:
```
# Add snap packages here
package-name
package-with-options --classic
```

### Adding Custom Scripts
1. Create your script in the appropriate directory
2. Make it executable: `chmod +x your-script.sh`
3. Add it to the main `install.sh` flow

## 📝 Post-Installation Notes

### Docker Usage
- You may need to log out and back in for Docker group permissions
- Test Docker: `docker run hello-world`

### Environment Variables
- Snap binaries are added to PATH in `~/.bashrc`
- Restart your terminal or run `source ~/.bashrc`

### Version Management
- Java alternatives are configured automatically
- Python 3.12 is set as the default python3
- Node.js LTS is installed via NodeSource

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure you have sudo access
2. **Package Not Found**: Update package lists with `sudo apt update`
3. **Snap Installation Fails**: Restart snapd service and try again
4. **Docker Permission Issues**: Log out and back in after installation

### Logs and Debugging
- All scripts provide detailed colored output
- Check individual script logs for specific issues
- Run scripts individually to isolate problems

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your improvements
4. Test on a clean system
5. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

---

**Note**: This setup is optimized for Ubuntu/Debian systems. For other distributions, you may need to modify package names and installation methods. 
