#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS & UI =================
C='\033[1;36m'; W='\033[1;37m'; G='\033[1;32m'; Y='\033[1;33m'
R='\033[1;31m'; P='\033[1;35m'; B='\033[1;34m'; N='\033[0m'

# ================= ERROR HANDLER =================
error_handler() {
    echo -e "\n${R} [!] CRITICAL ERROR at line $1${N}"
    echo -e "${Y} [*] Attempting automated environment fix...${N}"
    # Force install compilers if they were missing
    pkg install rust binutils build-essential -y
    exit 1
}
trap 'error_handler $LINENO' ERR

# ================= MODULE INSTALLERS =================
frontend_modules() {
    echo -e "\n${W}Available Frontend Modules:${N}"
    echo -e "${C}1) live-server  2) prettier  3) vite  0) Install ALL${N}"
    echo -ne "${Y}Install modules? [Choice/No] ❱ ${N}"
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
    echo -ne "${Y}Install modules? [Choice/No] ❱ ${N}"
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
echo -e "${G}1) Frontend Setup ${W}(NodeJS)${N}"
echo -e "${B}2) Backend Setup  ${W}(Python + Rust Compiler)${N}"
echo -e "${P}3) Just UI Setup  ${W}(Styling Only)${N}"
echo -ne "\nChoice [1-3] ❱ ${N}"
read -r path_choice < /dev/tty

# 3. FORCE REPAIR & COMPILER INSTALL
echo -e "\n${Y}[!] Phase 0: Repairing & Syncing Compilers...${N}"
apt update -y
# Added rust, binutils, and build-essential to prevent the Pydantic error
apt install openssl libngtcp2 curl git zsh eza rust binutils build-essential -y --reinstall

# 4. BRANCHING LOGIC
case $path_choice in
    1)
        echo -e "\n${Y}[!] Phase 1: Installing Frontend Core...${N}"
        pkg install nodejs -y
        frontend_modules
        ;;
    2)
        echo -e "\n${Y}[!] Phase 1: Installing Backend Core...${N}"
        pkg install python python-pip -y
        # Upgrade pip and setuptools to help with wheels
        pip install --upgrade pip setuptools wheel
        backend_modules
        ;;
    3)
        echo -e "\n${P}[!] UI Mode: Proceeding to Styling...${N}"
        ;;
    *)
        echo -e "\n${R}Invalid choice. Exiting.${N}"
        exit 1
        ;;
esac

# 5. UI & ICON SETUP
echo -e "\n${Y}[*] Phase 2: UI & Icon Styling...${N}"
mkdir -p ~/.termux
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf
echo "font-size = 13" > ~/.termux/termux.properties
termux-reload-settings

# Install & Run termux-style
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

# 6. REGISTER PERMANENT COMMAND
cp "$0" "$PREFIX/bin/auto-termux"
chmod +x "$PREFIX/bin/auto-termux"

# 7. SHELL CONFIG
echo -e "${Y}[!] Phase 3: Finalizing Shell Environment...${N}"
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

# 8. CLEANUP & HANDOVER
chsh -s zsh
echo -e "\n${G}────────────────────────────────────────────────────────────${N}"
echo -e "       ${W}BACKEND REPAIRED (RUST/BINUTILS ADDED)${N}"
echo -e "       ${W}TYPE ${C}auto-termux${W} TO RERUN${N}"
echo -e "       ${R}CLEANUP: setup.sh & folders REMOVED${N}"
echo -e "${G}────────────────────────────────────────────────────────────${N}"

(sleep 2; rm -f "$0") & 
exec zsh
