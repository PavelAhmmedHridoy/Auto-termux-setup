#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - FINAL FIXED
# =============================================================

# ---------- SECTION 1: ENVIRONMENT & SAFETY ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

SCRIPT_FILE=$(realpath "$0" 2>/dev/null || echo "$HOME/setup.sh")

set -e
trap 'echo -e "${RED}\n[!] SYSTEM ERROR DETECTED. RUN: dpkg --configure -a${NC}"' ERR

run_task() {
    local task_name=$1
    shift
    echo -e "${YELLOW}[*] $task_name...${NC}"

    if "$@" >/dev/null 2>&1; then
        echo -e "${GREEN}[✔] $task_name Successful.${NC}"
    else
        echo -e "${RED}[✘] $task_name Failed (Continuing).${NC}"
    fi
}

# ---------- SECTION 2: BRANDING ----------
clear
echo -e "${PINK}"
echo " ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗  ${CYAN}NITRO-CORE${PINK}"
echo " ██║     ██║   ██║██╔══██╗██╔══╝"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗ ${CYAN}v25.3${PINK}"
echo "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "${CYAN}   --- ABSOLUTE SPECTRUM STABLE ---${NC}\n"

echo -ne "${PINK}[?] Enter Nickname: ${NC}"
read -t 15 -r nickname < /dev/tty || nickname="User"
nickname=${nickname:-User}

# ---------- SECTION 3: PACKAGE DEPLOYMENT ----------
run_task "Syncing Repositories" pkg update -y
run_task "Upgrading Packages" pkg upgrade -y
run_task "Installing Essentials" pkg install -y \
    zsh \
    eza \
    zoxide \
    git \
    nodejs-lts \
    ruby \
    curl \
    termux-api

# ---------- SECTION 4: BACKGROUND SETUP ----------
mkdir -p ~/.termux ~/.zsh-plugins

(
    [[ -f ~/.termux/font.ttf ]] || curl -L -s \
        -o ~/.termux/font.ttf \
        "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

    [[ -d ~/.zsh-plugins/syntax ]] || git clone --depth=1 \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ~/.zsh-plugins/syntax >/dev/null 2>&1

    [[ -d ~/.zsh-plugins/suggest ]] || git clone --depth=1 \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        ~/.zsh-plugins/suggest >/dev/null 2>&1

    command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings
) &

# ---------- SECTION 5: CREATE ZSH CONFIG ----------
echo -e "${YELLOW}[*] Injecting Spectrum Engine...${NC}"

cat > ~/.zshrc <<EOF
# -------------------------------
# CORE-X ZSH CONFIG
# -------------------------------

export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# Plugins
[[ -f "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh" ]] && source "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh"
[[ -f "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh"

# Tools
command -v zoxide >/dev/null 2>&1 && eval "\$(zoxide init zsh)"

# Random Color Engine
RAND_COLOR=\$((RANDOM % 180 + 35))

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=206,bold"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=206,bold"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=206,underline"

ZSH_HIGHLIGHT_STYLES[argument]="fg=118"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=214"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=214"

ZSH_HIGHLIGHT_STYLES[path]="fg=33,underline"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=226"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=226"

ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=160,bold"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# Aliases
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias j='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'
alias devsetup="bash $SCRIPT_FILE"

# Prompt
setopt PROMPT_SUBST
PROMPT="%F{206}(%F{\${RAND_COLOR}}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f "

# Arrow keys
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- SECTION 6: FINALIZATION ----------
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X DEPLOYED SUCCESSFULLY${NC}"
echo -e "${CYAN}[*] Refresh anytime with:${NC} ${PINK}devsetup${NC}"
echo -e "${CYAN}[*] Jump directories with:${NC} ${PINK}j foldername${NC}"

sleep 1
exec zsh || bash
