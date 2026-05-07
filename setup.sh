#!/data/data/com.termux/files/usr/bin/bash

# ===============================================
#          DevSetup - Termux Setup
# ===============================================

set -e

# --- Colors ---
P='\033[0;35m'
W='\033[0;37m'
G='\033[0;32m'
N='\033[0m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'

# --- Banner ---
clear
echo -e "${PINK}"
cat << "EOF"
██████╗ ███████╗██╗   ██╗███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║  ██║█████╗  ██║   ██║███████╗█████╗     ██║   ██║   ██║██████╔╝
██║  ██║██╔══╝  ╚██╗ ██╔╝╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
██████╔╝███████╗ ╚████╔╝ ███████║███████╗   ██║   ╚██████╔╝██║     
╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
EOF
echo -e "${CYAN}DevSetup - Termux Modern Setup${N}\n"

# --- System update ---
pkg update -y && pkg upgrade -y

# --- Ask nickname ---
echo -ne "${PINK}Enter nickname: ${N}"
read -r nickname
nickname=${nickname:-Friend}

echo -e "${G}Hello, $nickname! Setting up your environment...${N}\n"

# --- Install packages ---
pkg install -y zsh git curl eza zoxide

# --- Fonts ---
mkdir -p $HOME/.termux
curl -fsSL -o $HOME/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf

# --- Plugins ---
PLUGIN_DIR="$HOME/.zsh-plugins"
mkdir -p "$PLUGIN_DIR"

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
"$PLUGIN_DIR/syntax" 2>/dev/null || true

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
"$PLUGIN_DIR/suggest" 2>/dev/null || true

# --- Zsh config ---
cat > $HOME/.zshrc <<EOF
export TERM="xterm-256color"

Z_DIR="\$HOME/.zsh-plugins"

source \$Z_DIR/suggest/zsh-autosuggestions.zsh
source \$Z_DIR/syntax/zsh-syntax-highlighting.zsh

# Aliases
alias ls='eza --icons --group-directories-first'
alias cls='clear'
alias devsetup='curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash'

# Prompt
PROMPT='%F{206}($nickname)%f %F{87}➜ %F{214}%~ %f '
EOF

# --- Theme ---
mkdir -p $HOME/.termux
cat > $HOME/.termux/colors.properties <<EOF
background=#000000
foreground=#ffffff
EOF

# --- Enable Zsh ---
chsh -s zsh || true
termux-reload-settings || true

echo -e "\n${G}✔ Setup Completed Successfully!${N}"
echo -e "${CYAN}Restart Termux or it will auto switch to Zsh.${N}"

exec zsh
