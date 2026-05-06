#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS =================
C='\033[1;36m'
W='\033[1;37m'
G='\033[1;32m'
Y='\033[1;33m'
R='\033[1;31m'
N='\033[0m'

clear

# ================= ASCII BANNER =================
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║        ⚡ TERMINAL UI ENGINE v2 ⚡          ║
╠════════════════════════════════════════════╣
║      ASCII • MENU • UPDATE SYSTEM          ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# ================= NICKNAME INPUT =================
echo -ne "${W}Enter your nickname ❱ ${N}"
read nickname
nickname=${nickname:-User}

echo -e "\n${C}Welcome, ${nickname}! 🚀${N}"

# ================= MENU =================
echo -e "\n${W}Select Option:${N}"
echo -e "${C}1) Frontend Setup"
echo -e "${C}2) Backend Setup"
echo -e "${C}3) Custom Install"
echo -e "${C}4) Exit"
echo -ne "\nChoice ❱ ${N}"
read choice

echo ""

# ================= SYSTEM UPDATE FUNCTION =================
system_update() {
    echo -e "${Y}🔄 Updating packages...${N}"
    pkg update -y

    echo -e "${Y}⬆ Upgrading packages...${N}"
    pkg upgrade -y

    echo -e "${G}✔ System updated successfully!${N}"
}

# ================= ACTIONS =================
case $choice in
    1)
        echo -e "${C}Frontend Setup Selected ⚡${N}"
        system_update
        pkg install nodejs git -y
        echo -e "${G}✔ Frontend tools installed${N}"
        ;;
    2)
        echo -e "${C}Backend Setup Selected ⚙${N}"
        system_update
        pkg install python php mariadb git -y
        echo -e "${G}✔ Backend tools installed${N}"
        ;;
    3)
        echo -e "${C}Custom Install Selected 📦${N}"
        system_update
        echo -ne "${W}Enter packages ❱ ${N}"
        read pkgs
        [[ -n "$pkgs" ]] && pkg install $pkgs -y
        echo -e "${G}✔ Custom packages installed${N}"
        ;;
    4)
        echo -e "${Y}Goodbye ${nickname} 👋${N}"
        exit
        ;;
    *)
        echo -e "${R}Invalid choice ❌${N}"
        ;;
esac

# ================= FINISH =================
echo -e "\n${G}✔ Setup Complete${N}"
