#!/data/data/com.termux/files/usr/bin/bash

# ==================================================
#                 DevSetup v30
#        Auto Install (No User Input)
# ==================================================

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
██████╗ ███████╗██╗   ██╗███████╗███████╗████████╗
██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝╚══██╔══╝
██║  ██║█████╗  ██║   ██║███████╗█████╗     ██║   
██║  ██║██╔══╝  ╚██╗ ██╔╝╚════██║██╔══╝     ██║   
██████╔╝███████╗ ╚████╔╝ ███████║███████╗   ██║   
╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝   ╚═╝   
EOF

echo -e "${CYAN}DevSetup v30 — Auto Mode (No Input Required)${N}\n"

# --- System Update ---
pkg update -y
pkg upgrade -y

# --- Install Packages ---
pkg install -y zsh git curl eza zoxide

# --- Font ---
mkdir -p "$HOME/.termux"
curl -fsSL -o "$HOME/.termux/font.ttf" \
"https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# --- Default Name (NO INPUT) ---
nickname="DevUser"

echo -e "${G}Using default nickname: $nickname${N}\n"

# --- Plugins ---
PLUGIN_DIR="$HOME/.zsh-plugins"
mkdir -p "$PLUGIN_DIR"

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
"$PLUGIN_DIR/syntax" 2>/dev/null || true

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
"$PLUGIN_DIR/suggest" 2>/dev/null || true

# --- ZSH Config ---
cat > "$HOME/.zshrc" <<EOF
export TERM="xterm-256color"

Z_DIR="\$HOME/.zsh-plugins"

source \$Z_DIR/suggest/zsh-autosuggestions.zsh
source \$Z_DIR/syntax/zsh-syntax-highlighting.zsh

alias ls='eza --icons --group-directories-first'
alias cls='clear'
alias devsetup='curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash'

PROMPT='%F{206}(${nickname})%f %F{87}➜ %F{214}%~ %f$ '
EOF

# --- Theme ---
mkdir -p "$HOME/.termux"
cat > "$HOME/.termux/colors.properties" <<EOF
background=#000000
foreground=#ffffff
EOF

# --- Finish ---
termux-reload-settings 2>/dev/null || true
chsh -s zsh 2>/dev/null || true

echo -e "\n${G}✔ DevSetup Installed Successfully (Auto Mode)${N}"
echo -e "${W}Restart Termux to apply changes.${N}"

exec zsh
