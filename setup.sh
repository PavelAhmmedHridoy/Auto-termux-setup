#!/bin/bash

################################################################################
# Termux Fullstack Automated Setup
# A comprehensive, modular environment provisioner for Termux
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"
LOG_FILE="$SCRIPT_DIR/setup.log"

################################################################################
# Logging Functions
################################################################################

log() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$LOG_FILE"
}

################################################################################
# System Check & Repair
################################################################################

check_termux() {
    log "Checking Termux environment..."
    
    if [[ ! -d "$PREFIX" ]]; then
        error "Termux PREFIX not found. Are you running this in Termux?"
        exit 1
    fi
    
    success "Termux environment verified"
}

repair_libraries() {
    log "Repairing common library mismatches..."
    
    # Fix libngtcp2 mismatch
    if pkg list-installed 2>/dev/null | grep -q "^curl"; then
        log "Checking curl and libngtcp2..."
        apt-get update -qq
        apt-get install -y -qq libngtcp2 curl >/dev/null 2>&1 || true
        success "Library repair completed"
    fi
}

################################################################################
# Package Installation
################################################################################

install_base_packages() {
    log "Installing base packages..."
    
    local packages=(
        "git"
        "wget"
        "curl"
        "zsh"
        "nodejs"
        "python"
        "neofetch"
        "eza"
        "bat"
        "ripgrep"
    )
    
    for pkg in "${packages[@]}"; do
        if ! pkg list-installed 2>/dev/null | grep -q "^$pkg"; then
            log "Installing $pkg..."
            apt-get install -y -qq "$pkg" || warning "Failed to install $pkg"
        else
            success "$pkg already installed"
        fi
    done
    
    success "Base packages installation completed"
}

install_nerd_font() {
    log "Installing MesloLGS Nerd Font for icon support..."
    
    local font_dir="$HOME/.termux"
    mkdir -p "$font_dir"
    
    if [[ ! -f "$font_dir/font.ttf" ]]; then
        # Download MesloLGS Nerd Font
        wget -q -O "$font_dir/font.ttf" \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Meslo.zip" \
            2>/dev/null || {
            warning "Could not download Nerd Font, continuing without it"
            return 1
        }
        
        success "Nerd Font installed"
    else
        success "Nerd Font already present"
    fi
    
    # Set font in Termux properties
    log "Configuring font in Termux properties..."
    mkdir -p "$HOME/.termux"
    {
        echo "font-family = MesloLGS Nerd Font"
        echo "font-size = 10"
    } >> "$HOME/.termux/termux.properties" 2>/dev/null || true
    
    return 0
}

################################################################################
# Shell Configuration (Zsh)
################################################################################

setup_zsh() {
    log "Setting up Zsh with plugins..."
    
    # Change default shell to zsh
    if [[ "$SHELL" != "*zsh" ]]; then
        log "Changing default shell to Zsh..."
        chsh -s zsh || warning "Could not change shell automatically"
    fi
    
    # Create zsh config directory
    mkdir -p "$HOME/.config/zsh"
    
    # Install Oh My Zsh (if not already installed)
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || warning "Oh My Zsh installation failed"
    fi
    
    # Install Zsh plugins
    log "Installing Zsh plugins..."
    
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    mkdir -p "$plugins_dir"
    
    # zsh-syntax-highlighting
    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting" 2>/dev/null || true
        success "zsh-syntax-highlighting installed"
    fi
    
    # zsh-autosuggestions
    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions" 2>/dev/null || true
        success "zsh-autosuggestions installed"
    fi
    
    # Create .zshrc if it doesn't exist
    if [[ ! -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    fi
    
    # Update plugins in .zshrc
    log "Configuring Zsh plugins..."
    {
        echo ""
        echo "# Custom plugins"
        echo "plugins=(git zsh-syntax-highlighting zsh-autosuggestions)"
        echo ""
        echo "# Aliases"
        echo "alias ll='eza -lh --icons'"
        echo "alias la='eza -a --icons'"
        echo "alias tree='eza --tree --icons'"
        echo "alias cat='bat'"
    } >> "$HOME/.zshrc" || true
    
    success "Zsh setup completed"
}

################################################################################
# Modular Files Directory
################################################################################

create_modular_directory() {
    log "Creating modular files directory structure..."
    
    mkdir -p "$FILES_DIR"
    
    # Create README for files directory
    cat > "$FILES_DIR/README.md" << 'EOF'
# Setup Files Directory

This directory contains modular setup scripts for different development stacks.

## Available Stacks

- **frontend.sh** - Frontend development (Node.js, npm, Live Server)
- **backend.sh** - Backend development (Python, SQL, Flask/Django)
- **fullstack.sh** - Complete fullstack development environment

## Usage

Run individual stack scripts:

```bash
bash files/frontend.sh
bash files/backend.sh
bash files/fullstack.sh
