#!/data/data/com.termux/files/usr/bin/bash

# --- Style Colors ---
C='\033[1;36m'; G='\033[1;32m'; Y='\033[1;33m'; R='\033[1;31m'; N='\033[0m'

# --- 1. GLOBAL ERROR HANDLER ---
error_handler() {
    echo -e "\n${R}[!] CRITICAL ERROR: $1${N}" >&2
    exit 1
}

# --- 2. MODULAR FILE GENERATOR ---
# This builds the 'files' folder and internal scripts automatically
generate_modules() {
    echo -e "${Y}[*] Creating local 'files' directory and modules...${N}"
    mkdir -p ./files

    # Create Frontend Module
    cat << 'EOF' > ./files/frontend.sh
#!/data/data/com.termux/files/usr/bin/bash
C='\033[1;36m'; G='\033[1;32m'; Y='\033[1;33m'; N='\033[0m'
echo -e "\n${C}>>> FRONTEND MODULE: NODEJS SETUP <<<${N}"
pkg install nodejs -y
echo -e "${Y}[?] Install global dev tools (live-server, prettier, typescript)? [y/n]${N}"
read -p "Selection: " npm_choice
if [[ "$npm_choice" =~ ^[Yy]$ ]]; then
    npm install -g live-server prettier typescript
    echo -e "${G}[+] Global tools installed successfully.${N}"
fi
EOF

    # Create Backend Module
    cat << 'EOF' > ./files/backend.sh
#!/data/data/com.termux/files/usr/bin/bash
C='\033[1;36m'; G='\033[1;32m'; Y='\033[1;33m'; N='\033[0m'
echo -e "\n${C}>>> BACKEND MODULE: PYTHON & SQL <<<${N}"
pkg install python python-pip mariadb -y
echo -e "${G}[+] Backend environment ready.${N}"
EOF

    # Create Fullstack Module (Calls both)
    cat << 'EOF' > ./files/fullstack.sh
#!/data/data/com.termux/files/usr/bin/bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$BASE_DIR/frontend.sh"
bash "$BASE_DIR/backend.sh"
EOF

    chmod +x ./files/*.sh
}

# --- 3. SYSTEM REPAIR & INITIALIZATION ---
clear
echo -e "${C}  ____  _______     __   ____ _____  _  _____ _   _ ____  "
echo " |  _ \| ____\ \   / /  / ___|_   _|/ \|_   _| | | / ___| "
echo " | | | |  _|  \ \ / /___\___ \ | | / _ \ | | | | | \___ \ "
echo " | |_| | |___  \ V /_____|__) || |/ ___ \| | | |_| |___) |"
echo " |____/|_____|  \_/     |____/ |_/_/   \_\_|  \___/|____/ ${N}"
echo -e "          MODULAR GITHUB-READY DEVELOPER SETUP\n"

# Validate Nickname
while true; do
    read -p "Enter Nickname for Prompt: " nickname
    [[ -n "$nickname" ]] && break
done

# Path Selection
echo -e "\n${G}SELECT YOUR DEVELOPMENT PATH:${N}"
echo -e "${C}1)${N} Frontend   ${C}2)${N} Backend   ${C}3)${N} Fullstack"
while true; do
    read -p "Selection [1-3]: " choice
    case $choice in
        1) script_file="frontend.sh"; break ;;
        2) script_file="backend.sh"; break ;;
        3) script_file="fullstack.sh"; break ;;
        *) echo -e "${R}Invalid selection.${N}" ;;
    esac
done

# --- 4. PHASE 1: REPAIR & UPDATE ---
echo -e "\n${Y}[*] Phase 1: Fixing Library Mismatches (libngtcp2/curl)...${N}"
# Aggressive fix for broken Termux repositories
apt update && apt full-upgrade -y || {
    dpkg --configure -a
    apt install -f -y
    apt full-upgrade -y
}

# --- 5. PHASE 2: CORE TOOLS & NERD FONT ---
echo -e "${Y}[*] Phase 2: Installing UI Core & Icon Fonts...${N}"
pkg install zsh git eza curl ncurses-utils -y --reinstall || error_handler "Install failed."

# Download and set MesloLGS Nerd Font (Essential for eza icons)
mkdir -p ~/.termux
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf
echo "font-size = 13" > ~/.termux/termux.properties
termux-reload-settings

# --- 6. PHASE 3: GENERATE & RUN MODULES ---
generate_modules
echo -e "${Y}[*] Phase 3: Executing Module ($script_file)...${N}"
bash "./files/$script_file" || echo -e "${R}[!] Warning: Module reported errors.${N}"

# --- 7. PHASE 4: ZSH CONFIGURATION (.zshrc) ---
echo -e "${Y}[*] Phase 4: Setting up ZSH & Plugins...${N}"
mkdir -p ~/.zsh_plugins
[[ -d ~/.zsh_plugins/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh_plugins/zsh-syntax-highlighting
[[ -d ~/.zsh_plugins/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_plugins/zsh-autosuggestions

cat << EOF > ~/.zshrc
# Environment
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# Load Plugins
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Styles & Icons
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lh --icons=always --group-directories-first'
alias la='eza -a --icons=always'

# Bold Custom Prompt
PROMPT='%B%F{51}(%F{51}${nickname}%F{51}) %F{226}➜ %F{33}%~ %F{118}$ %f%b'
EOF

# --- 8. FINALIZE ---
# Setup termux-style engine for colors
if [[ ! -d "$HOME/termux-style" ]]; then
    git clone https://github.com/adi1090x/termux-style "$HOME/termux-style" && cd "$HOME/termux-style" && ./install && cd - > /dev/null
fi

echo -e "\n${G}[+] Setup Complete! Icons, Node.js, and Zsh are ready.${N}"
chsh -s zsh
exec zsh

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
