#!/data/data/com.termux/files/usr/bin/bash

# ===================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - ULTIMATE COLOR FIX
# ===================================================

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

# ---------- SAFETY ----------
set -e
trap 'echo -e "${RED}\n[!] SCRIPT CRASHED.\nRun: dpkg --configure -a && pkg upgrade -y${NC}"' ERR

clear

# ---------- BANNER ----------
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗"
echo " ██║     ██║   ██║██╔══██╗██╔══╝"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝${NC}"
echo -e "   ${CYAN}CORE-X ABSOLUTE SPECTRUM v25.3${NC}\n"

# ---------- USER INPUT ----------
echo -ne "${PINK}[?] Nickname: ${NC}"
read -r nickname < /dev/tty
nickname=${nickname:-User}

# ---------- SYSTEM UPDATE ----------
echo -e "${YELLOW}[*] Syncing Repositories...${NC}"
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confold"

# ---------- INSTALLATION ----------
echo -e "${YELLOW}[*] Deploying Core Binaries...${NC}"
pkg install -y \
zsh eza zoxide git nodejs-lts ruby termux-api curl

# ---------- NERD FONT ----------
echo -e "${YELLOW}[*] Installing JetBrainsMono Nerd Font...${NC}"
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf \
"https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# ---------- ZSH CONFIGURATION ----------
echo -e "${YELLOW}[*] Configuring Spectrum Logic...${NC}"

cat > ~/.zshrc <<EOF
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# ---------- PLUGINS ----------
Z_DIR="\$HOME/.zsh-plugins"
mkdir -p "\$Z_DIR"

[[ -d "\$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "\$Z_DIR/syntax"
[[ -d "\$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "\$Z_DIR/suggest"

# Load plugins (Order matters!)
source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"
source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"

# ---------- INITIALIZE TOOLS ----------
eval "\$(zoxide init zsh)"

# ---------- ULTIMATE COLOR ENGINE ----------
# Must be declared AFTER sourcing syntax plugin
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# 1. Commands (mkdir, pkg, etc)
ZSH_HIGHLIGHT_STYLES[command]='fg=87,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=87,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=206,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=87,bold'

# 2. Arguments (This makes 'rfg' colorful!)
ZSH_HIGHLIGHT_STYLES[argument]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-fast]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-slow]='fg=118'

# 3. Flags & Options (-p, --force)
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=214'

# 4. Paths & Strings
ZSH_HIGHLIGHT_STYLES[path]='fg=33,underline'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=226'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=226'

# 5. Logic & Separators ( ; && || )
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=206,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160,bold'

# 6. Brackets (Levels for nested blocks)
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=214,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=206,bold'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# ---------- ALIASES ----------
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias la='eza -la --icons=always'
alias cls='clear'
alias cd='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'

# ---------- INTERFACE ----------
mkdir -p ~/.termux
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# ---------- PROMPT ----------
PROMPT='%F{206}(%F{87}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'

# Improve multi-line arrow key behavior
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- FINALIZING ----------
termux-reload-settings || true
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X DEPLOYED WITH FULL SPECTRUM COLORS${NC}"
echo -e "${CYAN}[*] Try: mkdir rfg && ls -la${NC}"

exec zsh
