#!/data/data/com.termux/files/usr/bin/bash

# ===== COLORS =====
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
P='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'
BG_B='\033[44m'
U='\033[4m'

# ===== FUNCTIONS =====
install_frontend() {
    echo -e "\n${P}⚡ STARTING FRONTEND SETUP...${N}"
    pkg install nodejs -y

    echo -ne "${C}Install global tools (live-server, prettier)? [y/n] ❱ ${N}"
    read npm_choice

    if [[ "$npm_choice" =~ ^[Yy]$ ]]; then
        npm install -g live-server prettier
    fi
}

install_backend() {
    echo -e "\n${B}⚙ STARTING BACKEND SETUP...${N}"
    pkg install python python-pip mariadb -y
}

# ===== UI =====
clear
echo -e "${C}────────────────────────────────────────────────────────────${N}"
echo -e "${P}  ____  _______     __   ____ _____  _  _____ _   _ ____  ${N}"
echo -e "${P} |  _ \| ____\ \   / /  / ___|_   _|/ \|_   _| | | / ___| ${N}"
echo -e "${P} | | | |  _|  \ \ / /___\___ \ | | / _ \ | | | | | \___ \ ${N}"
echo -e "${P} | |_| | |___  \ V /_____|__) || |/ ___ \| | | |_| |___) |${N}"
echo -e "${P} |____/|_____|  \_/     |____/ |_/_/   \_\_|  \___/|____/ ${N}"
echo -e "${C}────────────────────────────────────────────────────────────${N}"
echo -e "       ${BG_B}${W}  AUTO-REPAIR  ${N} ❱❱❱ ${BG_B}${W} COMMAND: auto-termux ${N}"
echo -e "${C}────────────────────────────────────────────────────────────${N}"

# ===== NICKNAME =====
echo -ne "${W}Enter Your Nickname ❱ ${N}"
read nickname

if [[ -z "$nickname" ]]; then
    nickname="User"
fi

# ===== MENU =====
echo -e "\n${U}${W}CHOOSE YOUR DEVELOPMENT PATH:${N}"
echo -e "${C}1.${G} Frontend ${W}| ${C}2.${B} Backend ${W}| ${C}3.${P} Fullstack${N}"
echo -ne "${W}Select [1-3] ❱ ${N}"
read choice

# ===== PHASE 1 =====
echo -e "\n${Y}[!] Phase 1: System Repair & Package Sync...${N}"
apt update -y
apt full-upgrade -y
pkg install zsh git curl eza ncurses-utils -y

# ===== PHASE 2 =====
echo -e "\n${Y}[!] Phase 2: Installing Nerd Font...${N}"
mkdir -p ~/.termux

curl -L \
"https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" \
-o ~/.termux/font.ttf

echo "font-size = 13" > ~/.termux/termux.properties
termux-reload-settings

# ===== PHASE 3 =====
case $choice in
    1) install_frontend ;;
    2) install_backend ;;
    3)
        install_frontend
        install_backend
        ;;
    *)
        echo -e "${Y}Skipping stack install...${N}"
        ;;
esac

# ===== PHASE 4 STYLE =====
echo -e "\n${Y}[!] Phase 4: Launching Style Engine...${N}"

if [[ ! -d "$HOME/termux-style" ]]; then
    git clone https://github.com/adi1090x/termux-style "$HOME/termux-style"
    cd "$HOME/termux-style" || exit
    chmod +x install
    ./install
fi

cd "$HOME" || exit

echo -e "${G}Choose your theme now.${N}"
echo -e "${C}After finishing theme selection press ENTER here.${N}"

bash -c "termux-style"
read -p "Done styling? Press Enter to continue..."

# ===== COMMAND SAVE =====
cp "$0" "$PREFIX/bin/auto-termux"
chmod +x "$PREFIX/bin/auto-termux"

# ===== ZSH SETUP =====
echo -e "\n${Y}[!] Phase 5: Configuring ZSH...${N}"

mkdir -p ~/.zsh_plugins

if [[ ! -d ~/.zsh_plugins/zsh-syntax-highlighting ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.zsh_plugins/zsh-syntax-highlighting
fi

if [[ ! -d ~/.zsh_plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.zsh_plugins/zsh-autosuggestions
fi

cat > ~/.zshrc << EOF
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lh --icons=always --group-directories-first'
alias auto-termux='auto-termux'

PROMPT="%B%F{51}( ${nickname} ) %F{226}➜ %F{33}%~ %F{118}$ %f%b"
EOF

chsh -s zsh

# ===== DONE =====
echo -e "\n${G}────────────────────────────────────────────────────────────${N}"
echo -e "${W}Setup complete.${N}"
echo -e "${C}Run anytime with: auto-termux${N}"
echo -e "${G}────────────────────────────────────────────────────────────${N}"

exec zsh    fi
    
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
