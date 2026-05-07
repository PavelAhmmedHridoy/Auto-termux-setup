#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X SMART DEV INSTALLER v25.3 (FULL FINAL FIXED)
# =============================================================

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
PINK='\033[38;5;206m'
BLUE='\033[38;5;39m'
NC='\033[0m'

# ---------- ERROR HANDLER ----------
set -e
trap 'echo -e "\n${RED}❌ ERROR: Something failed. Run pkg update && upgrade${NC}\n"' ERR

run_task() {
    echo -e "${YELLOW}⚙️ $1${NC}"
    shift
    "$@" >/dev/null 2>&1 && echo -e "${GREEN}✔ DONE${NC}" || echo -e "${RED}✖ FAIL${NC}"
}

# ---------- HEADER ----------
clear
echo -e "${PINK}"
echo " ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔════╝"
echo " ██║     ██║   ██║█████╗   CORE-X"
echo " ██║     ██║   ██║██╔══╝"
echo " ╚██████╗╚██████╔╝███████╗ SMART DEV"
echo " ╚═════╝ ╚═════╝ ╚══════╝ v25.3"
echo -e "${NC}"

echo -e "${CYAN}💻 CORE-X DEV INSTALLER${NC}\n"

# ---------- USER ----------
echo -ne "${YELLOW}👤 Nickname: ${NC}"
read nickname < /dev/tty
nickname=${nickname:-User}

echo -e "\n${BLUE}Welcome $nickname 🚀${NC}\n"

# ---------- MODE ----------
echo -e "${CYAN}📦 Choose Mode:${NC}"
echo -e " 1️⃣ Frontend"
echo -e " 2️⃣ Backend"
echo -e " 3️⃣ Full Stack"
echo -ne "${YELLOW}👉 Select: ${NC}"
read mode < /dev/tty

# ---------- MODULES ----------
echo -ne "${CYAN}🧩 Install modules? (y/n): ${NC}"
read module_choice < /dev/tty

INSTALL_ALL=false

if [[ "$module_choice" == "y" || "$module_choice" == "Y" ]]; then
    echo -e "\n${CYAN}⚡ Modules:${NC}"
    echo -e " 1️⃣ All"
    echo -e " 2️⃣ Skip"
    read mod_mode < /dev/tty

    [[ "$mod_mode" == "1" ]] && INSTALL_ALL=true
fi

# ---------- SYSTEM ----------
run_task "Update" pkg update -y
run_task "Upgrade" pkg upgrade -y

# ---------- BASE PACKAGES ----------
BASE="git curl wget nano vim zsh termux-api vivid"

FRONTEND="nodejs-lts"
BACKEND="python clang make cmake"

INSTALL_PKGS="$BASE"

[[ "$mode" == "1" ]] && INSTALL_PKGS="$INSTALL_PKGS $FRONTEND"
[[ "$mode" == "2" ]] && INSTALL_PKGS="$INSTALL_PKGS $BACKEND"
[[ "$mode" == "3" ]] && INSTALL_PKGS="$INSTALL_PKGS $FRONTEND $BACKEND"

[[ "$INSTALL_ALL" == true ]] && INSTALL_PKGS="$INSTALL_PKGS ruby nodejs-lts python"

run_task "Installing packages" pkg install -y $INSTALL_PKGS

# ---------- NODE ----------
if [[ "$mode" == "1" || "$mode" == "3" || "$INSTALL_ALL" == true ]]; then
    run_task "Node tools" npm install -g npm yarn pnpm eslint prettier
fi

# ---------- PYTHON ----------
if [[ "$mode" == "2" || "$mode" == "3" || "$INSTALL_ALL" == true ]]; then
    run_task "Python setup" pip install --upgrade pip
    pip install requests flask fastapi rich colorama >/dev/null 2>&1
fi

# ---------- DEV FOLDER ----------
mkdir -p ~/dev/{projects,scripts,tools}

# ---------- ZSH CONFIG (FULL FIXED COLOR ENGINE) ----------
chsh -s zsh || true

cat > ~/.zshrc <<EOF
# =============================================================
# CORE-X SHELL ENGINE (FULL COLOR + COMMAND HIGHLIGHT FIX)
# =============================================================

export TERM=xterm-256color
export COLORTERM=truecolor
export LC_ALL=C.UTF-8

# ---------- LS COLORS ----------
if command -v vivid >/dev/null 2>&1; then
    export LS_COLORS=\$(vivid generate molokai)
fi

export CLICOLOR=1
export CLICOLOR_FORCE=1

# ---------- PLUGINS ----------
[[ -f "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh" ]] && source "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh"
[[ -f "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh"

command -v zoxide >/dev/null 2>&1 && eval "\$(zoxide init zsh)"

# =============================================================
# 🔥 COMMAND + ARG COLOR ENGINE (FIXED PART)
# =============================================================

autoload -U colors && colors

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

# COMMANDS
ZSH_HIGHLIGHT_STYLES[command]="fg=51,bold"

# BUILTINS
ZSH_HIGHLIGHT_STYLES[builtin]="fg=135,bold"

# ARGUMENTS (FIXED WHITE ISSUE)
ZSH_HIGHLIGHT_STYLES[argument]="fg=82"

# PATHS
ZSH_HIGHLIGHT_STYLES[path]="fg=39,underline"

# OPTIONS
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=208"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=208"

# STRINGS
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=220"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=220"

# ERRORS
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=196,bold"

# ---------- ALIASES ----------
alias ls='eza --icons=always --group-directories-first --color=always --color-scale=all --git'
alias ll='eza -lh --icons=always'
alias cls='clear'
alias j='z'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias dev='cd ~/dev'

# ---------- PROMPT ----------
setopt PROMPT_SUBST
RAND_COLOR=\$((RANDOM % 180 + 35))
PROMPT="%F{cyan}👤 $nickname%f %F{\${RAND_COLOR}}%~%f %F{yellow}➜%f "

# ---------- KEYBIND ----------
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- FINISH ----------
echo -e "\n${GREEN}🎉 CORE-X INSTALL COMPLETE${NC}"
echo -e "${CYAN}📁 ~/dev ready${NC}"
echo -e "${YELLOW}🚀 restart or run: zsh${NC}"

exec zsh || bash
