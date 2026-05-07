#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - COLOR FIX EDITION
# =============================================================

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
    "$@" >/dev/null 2>&1 && echo -e "${GREEN}[✔] DONE${NC}" || echo -e "${RED}[✘] FAIL${NC}"
}

# ---------- HEADER ----------
clear
echo -e "${PINK} CORE-X COLOR FIX INSTALLER ${NC}\n"

echo -ne "${CYAN}[?] Nickname: ${NC}"
read -r nickname < /dev/tty || nickname="User"
nickname=${nickname:-User}

# ---------- PACKAGES ----------
run_task "Updating" pkg update -y
run_task "Upgrading" pkg upgrade -y
run_task "Installing tools" pkg install -y \
    zsh eza zoxide git curl vivid

# ---------- ZSH PLUGINS ----------
mkdir -p ~/.zsh-plugins

(
    [[ -d ~/.zsh-plugins/syntax ]] || git clone --depth=1 \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ~/.zsh-plugins/syntax >/dev/null 2>&1

    [[ -d ~/.zsh-plugins/suggest ]] || git clone --depth=1 \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        ~/.zsh-plugins/suggest >/dev/null 2>&1
) &

# ---------- ZSH CONFIG FIX ----------
cat > ~/.zshrc <<EOF

# =============================================================
# CORE-X ZSH FIXED CONFIG
# =============================================================

export TERM=xterm-256color
export COLORTERM=truecolor
export LC_ALL=C.UTF-8

# ---------- PLUGINS ----------
[[ -f "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh" ]] && source "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh"
[[ -f "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh"

command -v zoxide >/dev/null 2>&1 && eval "\$(zoxide init zsh)"

# ---------- FIX: LS_COLORS (REAL FIX) ----------
if command -v vivid >/dev/null 2>&1; then
    export LS_COLORS=\$(vivid generate molokai)
fi

export CLICOLOR=1
export CLICOLOR_FORCE=1

# ---------- EZA FIX ----------
alias ls='eza --icons=always --group-directories-first --color=always --color-scale=all --git'
alias ll='eza --icons=always --group-directories-first -lh'

# ---------- BASIC ALIASES ----------
alias cls='clear'
alias j='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'
alias devsetup="bash $SCRIPT_FILE"

# ---------- PROMPT ----------
setopt PROMPT_SUBST
RAND_COLOR=\$((RANDOM % 180 + 35))
PROMPT="%F{206}(%F{\${RAND_COLOR}}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f "

# ---------- COMPLETION COLORS FIX ----------
autoload -U colors && colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ---------- KEY BINDINGS ----------
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

EOF

# ---------- FINISH ----------
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X COLOR FIX INSTALLED${NC}"
echo -e "${CYAN}Run:${NC} ${PINK}devsetup${NC}"

exec zsh || bash
