#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - 256 COLOR FIXED EDITION
# =============================================================

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

SCRIPT_FILE=$(realpath "$0" 2>/dev/null || echo "$HOME/setup.sh")

set -e
trap 'echo -e "${RED}[!] ERROR SAFE MODE TRIGGERED${NC}"' ERR

run_task() {
    echo -e "${YELLOW}[*] $1${NC}"
    shift
    "$@" >/dev/null 2>&1 && echo -e "${GREEN}[✔] OK${NC}" || echo -e "${RED}[✘] FAILED${NC}"
}

# ---------- HEADER ----------
clear
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo -e " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo -e " ██║     ██║   ██║██████╔╝█████╗  ${CYAN}CORE-X${PINK}"
echo -e " ██║     ██║   ██║██╔══██╗██╔══╝"
echo -e " ╚██████╗╚██████╔╝██║  ██║███████╗ ${CYAN}v25.3${PINK}"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "${CYAN}   --- 256 COLOR SPECTRUM ENGINE ---${NC}\n"

echo -ne "${PINK}[?] Nickname: ${NC}"
read -r nickname < /dev/tty || nickname="User"
nickname=${nickname:-User}

# ---------- PACKAGES ----------
run_task "Update" pkg update -y
run_task "Upgrade" pkg upgrade -y
run_task "Install Core" pkg install -y \
    zsh eza zoxide git curl ruby nodejs-lts termux-api vivid

# ---------- BACKGROUND SETUP ----------
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

# ---------- ZSH CONFIG ----------
cat > ~/.zshrc <<EOF

export TERM=xterm-256color
export LC_ALL=C.UTF-8

# ---------- PLUGINS ----------
[[ -f "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh" ]] && source "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh"
[[ -f "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh"

command -v zoxide >/dev/null 2>&1 && eval "\$(zoxide init zsh)"

# ---------- 256 COLOR ENGINE ----------
THEMES=("ansi-dark" "molokai" "dracula" "gruvbox-dark" "catppuccin-mocha")
RANDOM_THEME=\${THEMES[\$RANDOM % \${#THEMES[@]}]}

command -v vivid >/dev/null 2>&1 && eval "\$(vivid generate \$RANDOM_THEME)"
export LS_COLORS

# ---------- EZA FIX (NO MORE WHITE FILES) ----------
alias ls='eza --icons=always --group-directories-first --grid --color=always --color-scale=all --git'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias j='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'
alias devsetup="bash $SCRIPT_FILE"

# ---------- PROMPT ----------
RAND_COLOR=\$((RANDOM % 180 + 35))

setopt PROMPT_SUBST
PROMPT="%F{206}(%F{\${RAND_COLOR}}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f "

# ---------- NAVIGATION ----------
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

EOF

# ---------- FINISH ----------
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X FULLY DEPLOYED (256 COLOR FIXED)${NC}"
echo -e "${CYAN}[*] restart with:${NC} ${PINK}devsetup${NC}"

exec zsh || bash
