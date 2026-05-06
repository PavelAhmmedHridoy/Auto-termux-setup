#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS & ASSETS =================
C='\033[1;36m'; W='\033[1;37m'; G='\033[1;32m'; Y='\033[1;33m'
R='\033[1;31m'; P='\033[1;35m'; B='\033[1;34m'; N='\033[0m'
BG_B='\033[44m'; U='\033[4m'

# ================= MODULE FUNCTIONS =================
install_frontend_modules() {
    echo -e "\n${W}Available Frontend Modules:${N}"
    echo -e "${C}1) live-server  2) prettier  3) vite  0) ALL${N}"
    echo -ne "${Y}Install modules? [Choice/No] ❱ ${N}"
    read m_choice
    case $m_choice in
        1) npm install -g live-server ;;
        2) npm install -g prettier ;;
        3) npm install -g vite ;;
        0) npm install -g live-server prettier vite ;;
        *) echo -e "${R}Skipping modules...${N}" ;;
    esac
}

install_backend_modules() {
    echo -e "\n${W}Available Backend Modules:${N}"
    echo -e "${C}1) flask  2) fastapi  3) websockets  0) ALL${N}"
    echo -ne "${Y}Install modules? [Choice/No] ❱ ${N}"
    read m_choice
    case $m_choice in
        1) pip install flask ;;
        2) pip install fastapi ;;
        3) pip install websockets ;;
        0) pip install flask fastapi websockets ;;
        *) echo -e "${R}Skipping modules...${N}" ;;
    esac
}

# ================= SYSTEM FLOW =================
clear
echo -e "${C}╔════════════════════════════════════════════╗"
echo -e "║      💎 GHOST COMMAND FLOW SYSTEM 💎       ║"
echo -e "╚════════════════════════════════════════════╝${N}"

# 1. NAME
echo -ne "${W}Enter your name ❱ ${N}"
read name
name=${name:-User}

# 2. PATH SELECTION
echo -e "\n${U}${W}SELECT YOUR SETUP PATH:${N}"
echo -e "${G}1) Frontend Setup ${W}(NodeJS + Modules)${N}"
echo -e "${B}2) Backend Setup  ${W}(Python + Modules)${N}"
echo -e "${P}3) Just UI Setup  ${W}(Styling & Zsh Only)${N}"
echo -ne "\nChoice ❱ ${N}"
read path_choice

# 3. LOGIC EXECUTION
case $path_choice in
    1)
        echo -e "\n${Y}[!] Installing Frontend Environment...${N}"
        apt update -y && pkg install nodejs git curl zsh eza -y
        install_frontend_modules
        ;;
    2)
        echo -e "\n${Y}[!] Installing Backend Environment...${N}"
        apt update -y && pkg install python python-pip mariadb git curl zsh eza -y
        install_backend_modules
        ;;
    3)
        echo -e "\n${P}[!] UI Mode: Skipping language packages...${N}"
        apt update -y && pkg install git curl zsh eza -y
        ;;
    *)
        echo -e "${R}Invalid choice. Exiting.${N}"
        exit 1
        ;;
esac

# 4. UNIVERSAL UI SETUP (For all paths)
echo -e "\n${Y}[*] Phase: UI & Icon Styling...${N}"
# Install Nerd Font
mkdir -p ~/.termux
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf
echo "font-size = 13" > ~/.termux/termux.properties && termux-reload-settings

# termux-style Installation & Trigger
if [[ ! -d "$HOME/termux-style" ]]; then
    git clone https://github.com/adi1090x/termux-style "$HOME/termux-style"
    cd "$HOME/termux-style" && ./install
    echo -e "${G}>>> SELECT THEME NOW...${N}"
    termux-style < /dev/tty
    cd - > /dev/null
    rm -rf "$HOME/termux-style"
else
    termux-style < /dev/tty
fi

# 5. COMMAND PERSISTENCE & ZSH
cp "$0" "$PREFIX/bin/auto-termux"
chmod +x "$PREFIX/bin/auto-termux"

mkdir -p ~/.zsh_plugins
[[ -d ~/.zsh_plugins/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh_plugins/zsh-syntax-highlighting
[[ -d ~/.zsh_plugins/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_plugins/zsh-autosuggestions

cat << EOF > ~/.zshrc
export TERM="xterm-256color"
export LC_ALL=C.UTF-8
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias ls='eza --icons=always --group-directories-first'
alias auto-termux='auto-termux'
PROMPT='%B%F{51}(%F{51}${name}%F{51}) %F{226}➜ %F{33}%~ %F{118}$ %f%b'
EOF

# 6. FINAL CLEANUP
chsh -s zsh
echo -e "\n${G}────────────────────────────────────────────────────────────${N}"
echo -e "       ${W}READY! TYPE ${C}auto-termux${W} TO RERUN${N}"
echo -e "       ${R}CLEANUP: setup.sh & source folders REMOVED${N}"
echo -e "${G}────────────────────────────────────────────────────────────${N}"

(sleep 2; rm -f "$0") & 
exec zsh
