#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS =================
C='\033[1;36m'; W='\033[1;37m'; G='\033[1;32m'
Y='\033[1;33m'; R='\033[1;31m'; N='\033[0m'

clear

# ================= ASCII =================
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║        ⚡ TERMUX FLOW INSTALLER ⚡         ║
╠════════════════════════════════════════════╣
║        CLEAN STEP WISE SYSTEM              ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# ================= STEP 1: NAME =================
echo -ne "${W}Enter your name ❱ ${N}"
read name
name=${name:-User}

echo -e "\n${G}Welcome ${name}! 🚀${N}"

# ================= STEP 2: FRONTEND / BACKEND =================
echo -e "\n${W}Select environment:${N}"
echo -e "${C}1) Frontend"
echo -e "${C}2) Backend"
echo -ne "\nChoice ❱ ${N}"
read env

# ================= ENV SETUP =================
setup_frontend() {
    echo -e "\n${C}[FRONTEND] Installing Node.js...${N}"
    pkg install nodejs -y
}

setup_backend() {
    echo -e "\n${B}[BACKEND] Installing Python + PHP...${N}"
    pkg install python php mariadb -y
}

case $env in
    1) setup_frontend ;;
    2) setup_backend ;;
    *) echo -e "${R}Invalid selection${N}"; exit ;;
esac

# ================= STEP 3: MODULE QUESTION =================
echo -e "\n${W}Do you want extra modules?${N}"
echo -e "${C}1) Yes"
echo -e "${C}2) No (Exit)"
echo -ne "\nChoice ❱ ${N}"
read want

[[ "$want" != "1" ]] && {
    echo -e "\n${Y}Done ${name} 👋${N}"
    exit
}

# ================= STEP 4: MODULE MENU =================
echo -e "\n${W}Select module option:${N}"
echo -e "${C}1) Install ALL modules"
echo -e "${C}2) Select modules manually"
echo -e "${C}3) Back"
echo -e "${C}4) Exit"
echo -ne "\nChoice ❱ ${N}"
read mode

# ================= CORE =================
core_install() {
    echo -e "\n${Y}[SYSTEM] Updating system...${N}"
    pkg update -y && pkg upgrade -y
    pkg install git curl zsh wget nano unzip -y
}

# ================= MODULES =================
frontend_module() {
    pkg install nodejs -y
}

backend_module() {
    pkg install python php mariadb -y
}

tools_module() {
    pkg install git curl wget nano -y
}

# ================= MODULE HANDLER =================
case $mode in

    1)
        core_install
        frontend_module
        backend_module
        tools_module
        ;;

    2)
        echo -e "\n${W}Select module:${N}"
        echo -e "${C}1) Frontend"
        echo -e "${C}2) Backend"
        echo -e "${C}3) Tools"
        echo -ne "\nChoice ❱ ${N}"
        read m

        core_install

        case $m in
            1) frontend_module ;;
            2) backend_module ;;
            3) tools_module ;;
            *) echo -e "${R}Invalid module${N}" ;;
        esac
        ;;

    3)
        echo -e "${Y}Going back...${N}"
        exec bash "$0"
        ;;

    4)
        echo -e "${R}Exit ${name} 👋${N}"
        exit
        ;;

    *)
        echo -e "${R}Invalid option${N}"
        ;;
esac

# ================= FINAL =================
echo -e "\n${G}✔ Setup complete for ${name}${N}"    exit
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
echo -e "${G}──────────────────────────────${N}"    exit
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
