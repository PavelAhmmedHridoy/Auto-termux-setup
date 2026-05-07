#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3
# Structured Sectioned Edition
# =============================================================

# -------------------------------------------------------------
# 1. ENVIRONMENT SETUP
# -------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

set -e
trap 'echo -e "${RED}\n[!] SCRIPT CRASHED.\nRun: dpkg --configure -a && pkg upgrade -y${NC}"' ERR

clear

# -------------------------------------------------------------
# 2. BRANDING & INPUT
# -------------------------------------------------------------
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗"
echo " ██║     ██║   ██║██╔══██╗██╔══╝"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝${NC}"
echo -e "   ${CYAN}CORE-X ABSOLUTE SPECTRUM v25.3${NC}\n"

echo -ne "${PINK}[?] Nickname: ${NC}"
read -r nickname < /dev/tty
nickname=${nickname:-User}

# -------------------------------------------------------------
# 3. SYSTEM DEPLOYMENT
# -------------------------------------------------------------
echo -e "${YELLOW}[*] Syncing Repositories...${NC}"
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confold"

echo -e "${YELLOW}[*] Deploying Core Binaries...${NC}"
pkg install -y zsh eza zoxide git nodejs-lts ruby termux-api curl

echo -e "${YELLOW}[*] Injecting Nerd Fonts...${NC}"
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# -------------------------------------------------------------
# 4. ZSH LOGIC GENERATION
# -------------------------------------------------------------
echo -e "${YELLOW}[*] Building .zshrc Structure...${NC}"

cat > ~/.zshrc <<EOF
# --- SYSTEM EXPORTS ---
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGIN LOADER ---
Z_DIR="\$HOME/.zsh-plugins"
mkdir -p "\$Z_DIR"

[[ -d "\$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "\$Z_DIR/syntax"
[[ -d "\$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "\$Z_DIR/suggest"

# Source Order: Autosuggest -> Syntax
source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"
source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"

# --- TOOLS INIT ---
eval "\$(zoxide init zsh)"

# -------------------------------------------------------------
# 5. ULTIMATE SPECTRUM COLOR ENGINE
# -------------------------------------------------------------
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# Command & Structure (Multi-Command Awareness)
ZSH_HIGHLIGHT_STYLES[command]='fg=87,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=87,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=206,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=87,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=206,bold'  # Highlights ; && || |
ZSH_HIGHLIGHT_STYLES[precommand]='fg=206,underline'   # Highlights sudo, time, etc.

# Arguments & Parameters (e.g., 'mkdir rfg')
ZSH_HIGHLIGHT_STYLES[argument]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-fast]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-slow]='fg=118'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=214'

# Files, Paths & Quotes
ZSH_HIGHLIGHT_STYLES[path]='fg=33,underline'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=226'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=226'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=214,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=206,bold'

# Error States
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160,bold'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# -------------------------------------------------------------
# 6. ALIASES & RE-RUN COMMAND
# -------------------------------------------------------------
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias cd='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'

# The Rerun Command
alias devsetup='bash $HOME/$(basename "$0")'

# --- INTERFACE CONFIG ---
mkdir -p ~/.termux
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# --- PROMPT ---
PROMPT='%F{206}(%F{87}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'

# Fix for multi-line arrow navigation
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# -------------------------------------------------------------
# 7. FINALIZATION
# -------------------------------------------------------------
termux-reload-settings || true
chsh -s zsh || true

echo -e "\n${GREEN}[✔] DEPLOYMENT COMPLETE${NC}"
echo -e "${CYAN}[*] RERUN SETUP ANYTIME WITH: ${PINK}devsetup${NC}"

exec zsh
