#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS =================
C='\033[1;36m'
W='\033[1;37m'
Y='\033[1;33m'
R='\033[1;31m'
N='\033[0m'

clear

# ================= ASCII BANNER =================
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║        ⚡ TERMINAL UI ENGINE v1 ⚡          ║
╠════════════════════════════════════════════╣
║        ASCII • INPUT SYSTEM • MENU         ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# ================= INPUT =================
echo -ne "${W}Enter your nickname ❱ ${N}"
read nickname
nickname=${nickname:-User}

echo -e "\n${C}Welcome, ${nickname}! 🚀${N}"

# ================= MENU (4 OPTIONS) =================
echo -e "\n${W}Select Option:${N}"
echo -e "${C}1) Frontend Setup"
echo -e "${C}2) Backend Setup"
echo -e "${C}3) Custom Install"
echo -e "${C}4) Exit"
echo -ne "\nChoice ❱ ${N}"
read choice

# ================= BASIC RESPONSE =================
echo ""

case $choice in
    1)
        echo -e "${C}Frontend mode selected ⚡${N}"
        ;;
    2)
        echo -e "${C}Backend mode selected ⚙${N}"
        ;;
    3)
        echo -e "${C}Custom install mode selected 📦${N}"
        ;;
    4)
        echo -e "${Y}Exiting... Bye ${nickname} 👋${N}"
        exit
        ;;
    *)
        echo -e "${R}Invalid choice ❌${N}"
        ;;
esac
