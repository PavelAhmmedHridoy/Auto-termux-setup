#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - PATH FIXED
# =============================================================

# ---------- 1. PRE-FLIGHT & ERROR HANDLING ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

# Capture the absolute path of this script for the devsetup alias
SCRIPT_PATH=$(realpath "$0")

set -e
trap 'echo -e "${RED}\n[!] CRITICAL ERROR. Check internet or run: dpkg --configure -a${NC}"' ERR

execute_task() {
    local task_name=$1
    shift
    echo -e "${YELLOW}[*] $task_name...${NC}"
    if "$@"; then
        echo -e "${GREEN}[✔] Done.${NC}"
    else
        echo -e "${RED}[✘] Failed.${NC}"
        return 1
    fi
}

clear

# ---------- 2. BRANDING & IDENTITY ----------
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗"
echo " ██║     ██║   ██║██╔══██╗██╔══╝"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝${NC}"
echo -e "   ${CYAN}CORE-X ABSOLUTE SPECTRUM [STABLE PATH]${NC}\n"

echo -ne "${PINK}[?] Nickname: ${NC}"
read -r nickname < /dev/tty
nickname=${nickname:-User}

# ---------- 3. SYSTEM DEPLOYMENT ----------
execute_task "Updating System" pkg update -y
execute_task "Installing Binaries" pkg install -y zsh eza zoxide git nodejs-lts ruby termux-api curl

execute_task "Installing Fonts" curl -L -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf" || true

# ---------- 4. ZSH CONFIGURATION ----------
execute_task "Generating Spectrum Logic" cat <<EOF > ~/.zshrc
# --- EXPORTS ---
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGINS ---
Z_DIR="\$HOME/.zsh-plugins"
mkdir -p "\$Z_DIR"

[[ -d "\$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "\$Z_DIR/syntax" >/dev/null 2>&1
[[ -d "\$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "\$Z_DIR/suggest" >/dev/null 2>&1

source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"
source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"

# --- INIT ---
eval "\$(zoxide init zsh)"

# --- RANDOM SPECTRUM ENGINE ---
# Picks a random vibrant color on every run
RAND_COLOR=\$(( ( RANDOM % 190 )  + 30 ))

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# Applying Random Spectrum
ZSH_HIGHLIGHT_STYLES[command]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=206,bold"

# Multi-Command/Logic Highlighting
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=206,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=206,underline'

# Argument & UI Colors
ZSH_HIGHLIGHT_STYLES[argument]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-fast]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-slow]='fg=118'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[path]='fg=33,underline'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=214,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160,bold'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# --- ALIASES ---
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias cd='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'

# FIXED: Points to the exact script location discovered at install
alias devsetup='bash $SCRIPT_PATH'

# --- INTERFACE ---
mkdir -p ~/.termux
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# --- PROMPT ---
PROMPT='%F{206}(%F{\$RAND_COLOR}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'

# Keys
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- 5. FINALIZATION ----------
execute_task "Finalizing" termux-reload-settings
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X DEPLOYED${NC}"
echo -e "${CYAN}[*] RERUN SETUP ANYTIME WITH: ${PINK}devsetup${NC}"

exec zsh
