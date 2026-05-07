#!/data/data/com.termux/files/usr/bin/bash

# ==============================
# CORE-X ABSOLUTE SPECTRUM v25.1
# Stable Edition
# ==============================

# --- COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

# --- SAFETY ---
set -e
trap 'echo -e "${RED}\n[!] SCRIPT CRASHED. RUN: dpkg --configure -a && pkg upgrade -y${NC}"' ERR

clear

# --- BANNER ---
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗"
echo " ██║     ██║   ██║██╔══██╗██╔══╝"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝${NC}"
echo -e "   ${CYAN}CORE-X ABSOLUTE SPECTRUM v25.1${NC}\n"

# --- SYSTEM HEALTH CHECK ---
echo -e "${YELLOW}[*] Validating System Health...${NC}"
dpkg --configure -a || true

# Set repo manually only if needed
if ! grep -q "deb" "$PREFIX/etc/apt/sources.list"; then
    echo -e "${YELLOW}[*] Configuring mirrors...${NC}"
    yes | termux-change-repo
fi

pkg update -y
pkg upgrade -y

# --- INSTALL CORE TOOLS ---
echo -e "${YELLOW}[*] Deploying Binaries...${NC}"
pkg install -y \
    zsh \
    eza \
    zoxide \
    git \
    nodejs-lts \
    ruby

# Install curl only if missing
if ! command -v curl >/dev/null 2>&1; then
    pkg install curl -y
fi

# --- FONT SETUP ---
echo -e "${YELLOW}[*] Injecting Pro-Icons...${NC}"
mkdir -p ~/.termux

curl -L \
-o ~/.termux/font.ttf \
"https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# --- USER INPUT ---
echo -ne "${PINK}[?] Nickname: ${NC}"
read -r nickname
nickname=${nickname:-User}

# --- ZSH CONFIG ---
echo -e "${YELLOW}[*] Writing Spectrum Logic...${NC}"

cat > ~/.zshrc <<EOF
# ==============================
# CORE-X ZSH CONFIG
# ==============================

export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGINS ---
Z_DIR="\$HOME/.zsh-plugins"
mkdir -p "\$Z_DIR"

[[ -d "\$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "\$Z_DIR/syntax"
[[ -d "\$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "\$Z_DIR/suggest"

source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"
source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"

# --- COLORS ---
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]='fg=87'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=87'
ZSH_HIGHLIGHT_STYLES[alias]='fg=206'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=206'

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[path]='fg=33,underline'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

ZSH_HIGHLIGHT_PATTERNS+=('install' 'fg=214')
ZSH_HIGHLIGHT_PATTERNS+=('update' 'fg=214')
ZSH_HIGHLIGHT_PATTERNS+=('upgrade' 'fg=214')
ZSH_HIGHLIGHT_PATTERNS+=('remove' 'fg=160')

ZSH_HIGHLIGHT_PATTERNS+=('pkg' 'fg=87')
ZSH_HIGHLIGHT_PATTERNS+=('git' 'fg=118')
ZSH_HIGHLIGHT_PATTERNS+=('python' 'fg=118')
ZSH_HIGHLIGHT_PATTERNS+=('node' 'fg=118')
ZSH_HIGHLIGHT_PATTERNS+=('ruby' 'fg=118')

# --- ALIASES ---
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias la='eza -la --icons=always'
alias cls='clear'

# --- THEME ---
mkdir -p ~/.termux
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# --- PROMPT ---
PROMPT='%F{206}(%F{87}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'
EOF

# --- APPLY SETTINGS ---
termux-reload-settings || true

# --- DEFAULT SHELL ---
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X DEPLOYED SUCCESSFULLY.${NC}"
echo -e "${CYAN}[*] Restart Termux if font/icons do not apply.${NC}"

exec zsh
