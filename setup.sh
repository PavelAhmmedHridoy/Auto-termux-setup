#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS =================
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'

clear

# ================= ASCII BANNER =================
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║        ⚡ TERMINAL UI ENGINE v1 ⚡          ║
╠════════════════════════════════════════════╣
║        BUILDER • INPUT SYSTEM • CORE       ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# ================= USER INPUT =================
echo -ne "${W}Enter your nickname ❱ ${N}"
read nickname

# default fallback
nickname=${nickname:-User}

echo -e "\n${C}Welcome, ${nickname}! 🚀${N}"

# ================= SIMPLE MENU =================
echo -e "\n${W}Select Option:${N}"
echo -e "${C}1) Start Setup"
echo -e "${C}2) Exit"
echo -ne "\nChoice ❱ ${N}"
read choice

# ================= BASIC RESPONSE =================
if [[ "$choice" == "1" ]]; then
    echo -e "\n${C}Starting setup engine...${N}"
elif [[ "$choice" == "2" ]]; then
    echo -e "\n${C}Bye ${nickname} 👋${N}"
    exit
else
    echo -e "\n${C}Invalid input → staying in UI${N}"
fi
