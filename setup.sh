#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS =================
C='\033[1;36m'; W='\033[1;37m'; G='\033[1;32m'
Y='\033[1;33m'; R='\033[1;31m'; B='\033[1;34m'
N='\033[0m'

clear

# ================= ASCII HEADER =================
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║        ⚡ TERMUX WIZARD ENGINE ⚡          ║
╠════════════════════════════════════════════╣
║        STEP-BY-STEP INSTALLER UI           ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# ================= STEP 1: NAME =================
echo -ne "${W}Enter your name ❱ ${N}"
read name
name=${name:-User}

echo -e "\n${G}Welcome ${name}! 🚀${N}"

# ================= STEP 2: MODULE QUESTION =================
echo -e "\n${W}Do you want to install modules?${N}"
echo -e "${C}1) Yes"
echo -e "${C}2) No (Exit)"
echo -ne "\nChoice ❱ ${N}"
read want

[[ "$want" != "1" ]] && {
    echo -e "\n${Y}Goodbye ${name} 👋${N}"
    exit
}

# ================= STEP 3: MODE MENU =================
echo -e "\n${W}Select Mode:${N}"
echo -e "${C}1) Install ALL Modules"
echo -e "${C}2) Select Modules"
echo -e "${C}3) Back (Restart)"
echo -e "${C}4) Exit"
echo -ne "\nChoice ❱ ${N}"
read mode

# ================= CORE SYSTEM =================
system_core() {
    echo -e "\n${Y}[SYSTEM] Updating & Installing Core Tools...${N}"
    pkg update -y && pkg upgrade -y
    pkg install git zsh curl nodejs python php mariadb -y
}

# ================= MODULE FUNCTIONS =================
frontend() {
    echo -e "\n${C}[FRONTEND] Installing Node.js tools...${N}"
    pkg install nodejs -y
}

backend() {
    echo -e "\n${B}[BACKEND] Installing Python + PHP stack...${N}"
    pkg install python php mariadb -y
}

tools() {
    echo -e "\n${G}[TOOLS] Installing utility tools...${N}"
    pkg install git curl wget nano unzip -y
}

# ================= MODE LOGIC =================
case $mode in

    1)
        system_core
        frontend
        backend
        tools
        ;;

    2)
        echo -e "\n${W}Select modules:${N}"
        echo -e "${C}1) Frontend"
        echo -e "${C}2) Backend"
        echo -e "${C}3) Tools"
        echo -ne "\nChoice ❱ ${N}"
        read m

        system_core

        case $m in
            1) frontend ;;
            2) backend ;;
            3) tools ;;
            *) echo -e "${R}Invalid module selection${N}" ;;
        esac
        ;;

    3)
        echo -e "\n${Y}Restarting wizard...${N}"
        exec bash "$0"
        ;;

    4)
        echo -e "\n${R}Exit ${name} 👋${N}"
        exit
        ;;

    *)
        echo -e "\n${R}Invalid option${N}"
        ;;
esac

# ================= FINAL =================
echo -e "\n${G}──────────────────────────────${N}"
echo -e "${W}Setup Complete ✔ for ${C}${name}${N}"
echo -e "${G}──────────────────────────────${N}"
