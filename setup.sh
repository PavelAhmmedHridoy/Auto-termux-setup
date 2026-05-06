#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS & UI =================
C='\033[1;36m'; W='\033[1;37m'; G='\033[1;32m'; Y='\033[1;33m'
R='\033[1;31m'; P='\033[1;35m'; B='\033[1;34m'; N='\033[0m'

# ================= ERROR HANDLER =================
# Catches any command failure and reports the line number
error_handler() {
    echo -e "\n${R} [!] CRITICAL ERROR at line $1${N}"
    echo -e "${Y} [*] Setup halted. Check your internet or storage.${N}"
    exit 1
}
trap 'error_handler $LINENO' ERR

# ================= MODULE INSTALLERS =================
frontend_modules() {
    echo -e "\n${W}Available Frontend Modules:${N}"
    echo -e "${C}1) live-server  2) prettier  3) vite  0) Install ALL${N}"
    echo -ne "${Y}Would you like to install modules? [Choice/No] ❱ ${N}"
    read -r m_choice < /dev/tty || m_choice="No"
    
    case $m_choice in
        1) npm install -g live-server ;;
        2) npm install -g prettier ;;
        3) npm install -g vite ;;
        0) npm install -g live-server prettier vite ;;
        *) echo -e "${P}[-] Skipping modules...${N}" ;;
    esac
}

backend_modules() {
    echo -e "\n${W}Available Backend Modules:${N}"
    echo -e "${C}1) flask  2) fastapi  3) websockets  0) Install ALL${N}"
    echo -ne "${Y}Would you like to install modules? [Choice/No] ❱ ${N}"
    read -r m_choice < /dev/tty || m_choice="No"
    
    case $m_choice in
        1) pip install flask ;;
        2) pip install fastapi ;;
        3) pip install websockets ;;
        0) pip install flask fastapi websockets ;;
        *) echo -e "${P}[-] Skipping modules...${N}" ;;
    esac
}

# ================= MAIN EXECUTION FLOW =================
clear
echo -e "${C}╔════════════════════════════════════════════╗"
echo -e "║      💎 GHOST COMMAND FLOW SYSTEM 💎       ║"
echo -e "╚════════════════════════════════════════════╝${N}"

# 1. NAME IDENTITY
echo -ne "${W}Enter your name ❱ ${N}"
read -r name < /dev/tty || name="User"
name=${name:-User}

# 2. PATH SELECTION
echo -e "\n${W}SELECT YOUR SETUP PATH:${N}"
echo -e "${G}1) Frontend Setup ${W}(NodeJS + Modules)${N}"
echo -e "${B}2) Backend Setup  ${W}(Python + Modules)${N}"
echo -e "${P}3) Just UI Setup  ${W}(Styling & Zsh Only)${N}"
echo -ne "\nChoice [1-3] ❱ ${N}"
read -r path_choice < /dev/tty

# 3. BRANCHING LOGIC
case $path_choice in
    1)
        echo -e "\n${Y}[!] Phase: Installing Frontend Core...${N}"
        apt update -y && pkg install nodejs git curl zsh eza -y
        frontend_modules
        ;;
    2)
        echo -e "\n${Y}[!] Phase: Installing Backend Core...${N}"
        apt update -y && pkg install python python-pip git curl zsh eza -y
        backend_modules
        ;;
    3)
        echo -e "\n${P}[!] UI Mode: Skipping language packages...${N}"
        apt update -y && pkg install git curl zsh eza -y
        ;;
    *)
        echo -e "\n${R}Invalid choice. Please run 'auto-termux' to try again.${N}"
        exit 1
        ;;
esac

# 4. UNIVERSAL UI & ICON SETUP
echo -e "\n${Y}[*] Phase: UI & Icon Styling...${N}"
mkdir -p ~/.termux
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf
echo "font-size = 13" > ~/.termux/termux.properties
termux-reload-settings

# Install & Run termux-style
if [[ ! -d "$HOME/termux-style" ]]; then
    git clone https://github.com/adi1090x/termux-style "$HOME/termux-style"
    cd "$HOME/termux-style" && ./install
    echo -e "${G}>>> SELECT THEME NOW. SCRIPT WILL CONTINUE AFTER EXIT.${N}"
    termux-style < /dev/tty
    cd - > /dev/null
    rm -rf "$HOME/termux-style" # Delete styling folder
else
    termux-style < /dev/tty
fi

# 5. REGISTER DEFAULT COMMAND
# Save this script to system bin before it deletes itself
cp "$0" "$PREFIX/bin/auto-termux"
chmod +x "$PREFIX/bin/auto-termux"

# 6. SHELL CONFIGURATION
echo -e "${Y}[!] Phase: Finalizing Shell Environment...${N}"
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

# 7. CLEANUP & HANDOVER
chsh -s zsh
echo -e "\n${G}────────────────────────────────────────────────────────────${N}"
echo -e "       ${W}SUCCESS! TYPE ${C}auto-termux${W} TO RERUN ANYTIME${N}"
echo -e "       ${R}CLEANUP: setup.sh & source folders REMOVED${N}"
echo -e "       ${G}Welcome to your new terminal, ${name}!${N}"
echo -e "${G}────────────────────────────────────────────────────────────${N}"

# Delete the downloaded setup.sh file
(sleep 2; rm -f "$0") & 
exec zsh
