#!/data/data/com.termux/files/usr/bin/bash

# 1. TITANIUM STABILITY DEFS
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
PINK='\033[38;5;206m'; CYAN='\033[38;5;87m'; NC='\033[0m'

# 2. CRASH-PROOF GUARD
set -e
trap 'echo -e "${RED}\n[!] SCRIPT CRASHED. RUN dpkg --configure -a AND RESTART.${NC}"' ERR

# 3. BRANDING (SIMPLE & CLEAN)
clear
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗  "
echo " ██║     ██║   ██║██╔══██╗██╔══╝  "
echo " ╚██████╗╚██████╔╝██║  ██║███████╗"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝${NC}"
echo -e "   ${CYAN}CORE-X ABSOLUTE SPECTRUM v25.0${NC}\n"

# 4. SELF-HEALING SYSTEM
echo -e "${YELLOW}[*] Validating System Health...${NC}"
dpkg --configure -a || true
pkg update -y

# 5. INSTALL CORE TOOLS
echo -e "${YELLOW}[*] Deploying Binaries...${NC}"
pkg install zsh eza zoxide curl git nodejs-lts ruby -y

# 6. PRO-ICON FONT (JetBrains Nerd Font)
echo -e "${YELLOW}[*] Injecting Pro-Icons...${NC}"
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# 7. IDENTITY
echo -ne "${PINK}[?] Nickname: ${NC}"; read -r nickname
nickname=${nickname:-"User"}

# 8. MASTER ZSHRC GENERATION (THE SPECTRUM LOGIC)
echo -e "${YELLOW}[*] Writing Spectrum Logic...${NC}"
cat << EOF > ~/.zshrc
# --- ENVIRONMENT ---
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGIN SETUP ---
Z_DIR="\$HOME/.zsh-plugins"
mkdir -p "\$Z_DIR"

# Auto-Download Plugins if missing
[[ -d "\$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "\$Z_DIR/syntax"
[[ -d "\$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "\$Z_DIR/suggest"

# Source Order is critical for Colors
source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"
source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"

# --- THE COLOR SPECTRUM ENGINE (NO WHITE) ---
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# Commands (Cyan)
ZSH_HIGHLIGHT_STYLES[command]='fg=87'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=87'
ZSH_HIGHLIGHT_STYLES[alias]='fg=206'

# Structural (Pink)
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=206'

# Sub-Commands (Orange/Amber 214)
ZSH_HIGHLIGHT_PATTERNS+=('install' 'fg=214')
ZSH_HIGHLIGHT_PATTERNS+=('update' 'fg=214')
ZSH_HIGHLIGHT_PATTERNS+=('upgrade' 'fg=214')
ZSH_HIGHLIGHT_PATTERNS+=('remove' 'fg=160')

# Package Names / Tools (Lime 118)
ZSH_HIGHLIGHT_PATTERNS+=('pkg' 'fg=87')
ZSH_HIGHLIGHT_PATTERNS+=('git' 'fg=118')
ZSH_HIGHLIGHT_PATTERNS+=('python' 'fg=118')
ZSH_HIGHLIGHT_PATTERNS+=('node' 'fg=118')
ZSH_HIGHLIGHT_PATTERNS+=('ruby' 'fg=118')

# Options & Paths (Orange & Blue)
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[path]='fg=33,underline'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# --- PRO ALIASES (EZA ICONS) ---
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'

# --- TERMINAL THEME ---
mkdir -p ~/.termux
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# --- PROMPT ---
PROMPT='%F{206}(%F{87}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'
EOF

# 9. FINALIZE & LAUNCH
termux-reload-settings
echo -e "\n${GREEN}[✔] CORE-X DEPLOYED. ENJOY THE SPECTRUM.${NC}"
chsh -s zsh
exec zsh
