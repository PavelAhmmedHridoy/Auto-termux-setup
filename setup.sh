#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X SMART DEV INSTALLER v25.3 (ULTIMATE FIXED)
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
trap 'echo -e "\n${RED}❌ ERROR: Something broke. Run: pkg update && pkg upgrade${NC}\n"' ERR

# ---------- FUNCTION ----------
run_task() {
    echo -e "${YELLOW}⚙️  $1${NC}"
    shift
    if "$@" >/dev/null 2>&1; then
        echo -e "${GREEN}✔ SUCCESS${NC}"
    else
        echo -e "${RED}✖ FAILED${NC}"
    fi
}

# ---------- HEADER ----------
clear
echo -e "${PINK}"
echo "██████╗ ██████╗ ███████╗"
echo "██╔════╝██╔═══██╗██╔════╝"
echo "██║     ██║   ██║█████╗   CORE-X"
echo "██║     ██║   ██║██╔══╝"
echo "╚██████╗╚██████╔╝███████╗ SMART INSTALLER"
echo "╚═════╝ ╚═════╝ ╚══════╝ v25.3"
echo -e "${NC}"

echo -e "${CYAN}💻 Welcome to CORE-X Dev Setup${NC}"

# ---------- USER ----------
echo -ne "${YELLOW}👤 Enter Nickname: ${NC}"
read nickname < /dev/tty
nickname=${nickname:-User}

echo -e "\n${BLUE}Hello, $nickname 🚀${NC}\n"

# ---------- MODE SELECT ----------
echo -e "${CYAN}📦 Choose Environment:${NC}"
echo -e " 1️⃣ Frontend"
echo -e " 2️⃣ Backend"
echo -e " 3️⃣ Full Stack"

echo -ne "${YELLOW}👉 Select: ${NC}"
read mode < /dev/tty

# ---------- MODULE SYSTEM ----------
echo -ne "${CYAN}🧩 Install modules? (y/n): ${NC}"
read module_choice < /dev/tty

INSTALL_ALL=false

if [[ "$module_choice" == "y" || "$module_choice" == "Y" ]]; then
    echo -e "\n${CYAN}⚡ Module Options:${NC}"
    echo -e " 1️⃣ All Modules"
    echo -e " 2️⃣ Manual (coming basic preset)"

    read module_mode < /dev/tty

    if [[ "$module_mode" == "1" ]]; then
        INSTALL_ALL=true
    fi
fi

# ---------- UPDATE SYSTEM ----------
run_task "System Update" pkg update -y
run_task "System Upgrade" pkg upgrade -y

# ---------- BASE PACKAGES ----------
BASE="git curl wget nano vim zsh termux-api"

# ---------- FRONTEND ----------
FRONTEND="nodejs-lts"

# ---------- BACKEND ----------
BACKEND="python clang make cmake"

INSTALL_PKGS="$BASE"

if [[ "$mode" == "1" ]]; then
    INSTALL_PKGS="$INSTALL_PKGS $FRONTEND"
elif [[ "$mode" == "2" ]]; then
    INSTALL_PKGS="$INSTALL_PKGS $BACKEND"
elif [[ "$mode" == "3" ]]; then
    INSTALL_PKGS="$INSTALL_PKGS $FRONTEND $BACKEND"
fi

# ---------- ALL MODULES ----------
if [[ "$INSTALL_ALL" == true ]]; then
    INSTALL_PKGS="$INSTALL_PKGS ruby nodejs-lts python"
fi

# ---------- INSTALL ----------
run_task "Installing Packages" pkg install -y $INSTALL_PKGS

# ---------- NODE GLOBALS ----------
if [[ "$mode" == "1" || "$mode" == "3" || "$INSTALL_ALL" == true ]]; then
    run_task "Node Tools" npm install -g npm yarn pnpm eslint prettier
fi

# ---------- PYTHON SETUP ----------
if [[ "$mode" == "2" || "$mode" == "3" || "$INSTALL_ALL" == true ]]; then
    run_task "Python Pip Upgrade" pip install --upgrade pip
    pip install requests flask fastapi rich colorama >/dev/null 2>&1
fi

# ---------- DEV STRUCTURE ----------
mkdir -p ~/dev/{projects,scripts,tools}

# ---------- ZSH SETUP ----------
chsh -s zsh || true

cat > ~/.zshrc <<EOF
# CORE-X ENV

export TERM=xterm-256color

# ---------- ALIASES ----------
alias cls='clear'
alias ll='ls -la'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias dev='cd ~/dev'
alias j='z'

# ---------- PROMPT ----------
PROMPT="%F{cyan}👤 $nickname%f %F{green}%~%f %F{yellow}➜%f "
EOF

# ---------- FINAL ----------
echo -e "\n${GREEN}🎉 CORE-X SETUP COMPLETE${NC}"
echo -e "${CYAN}📁 Dev Folder: ~/dev${NC}"
echo -e "${YELLOW}🚀 Restart Termux or run: zsh${NC}"

exec zsh || bash
