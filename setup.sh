#!/data/data/com.termux/files/usr/bin/bash

# ================= 1. COLORS =================
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'
P='\033[1;35m'; C='\033[1;36m'; W='\033[1;37m'; N='\033[0m'

clear

# ================= 2. ASCII UI =================
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║        ⚡ TERMUX AUTO ENGINE v4 ⚡         ║
╠════════════════════════════════════════════╣
║   CLEAN STRUCTURE • MODULAR SYSTEM         ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# ================= 3. INPUT =================
echo -ne "${W}Enter Nickname ❱ ${N}"
read nickname
nickname=${nickname:-User}

echo -e "\n${C}Welcome ${nickname}! 🚀${N}"

echo -e "\n${W}Select Setup Mode:${N}"
echo -e "${C}1) Frontend"
echo -e "${C}2) Backend"
echo -e "${C}3) Fullstack"
echo -e "${C}4) Exit"
echo -ne "\nChoice ❱ ${N}"
read choice

# ================= 4. CORE SYSTEM UPDATE =================
system_update() {
    echo -e "\n${Y}[1] System Update Phase...${N}"
    apt update -y && apt full-upgrade -y
    pkg install git zsh curl eza ncurses-utils -y
}

# ================= 5. MODULES =================
install_frontend() {
    echo -e "\n${P}[2] Frontend Setup...${N}"
    pkg install nodejs -y

    echo -ne "${C}Install live-server + prettier? [y/n] ❱ ${N}"
    read ans
    [[ "$ans" =~ ^[Yy]$ ]] && npm install -g live-server prettier
}

install_backend() {
    echo -e "\n${B}[2] Backend Setup...${N}"
    pkg install python python-pip mariadb php -y
}

install_fullstack() {
    install_frontend
    install_backend
}

# ================= 6. FONTS =================
install_fonts() {
    echo -e "\n${Y}[3] Installing Fonts...${N}"
    mkdir -p ~/.termux

    curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" \
    -o ~/.termux/font.ttf

    echo "font-size = 13" > ~/.termux/termux.properties
    termux-reload-settings
}

# ================= 7. STYLE ENGINE =================
install_style() {
    echo -e "\n${Y}[4] Installing Theme Engine...${N}"

    if [[ ! -d "$HOME/termux-style" ]]; then
        git clone https://github.com/adi1090x/termux-style "$HOME/termux-style"
        cd "$HOME/termux-style" || return
        chmod +x install
        ./install
    fi

    echo -e "${G}Select your theme now...${N}"
    termux-style < /dev/tty

    cd "$HOME"
    rm -rf "$HOME/termux-style"
}

# ================= 8. ZSH CONFIG =================
install_zsh() {
    echo -e "\n${Y}[5] Configuring Zsh...${N}"

    mkdir -p ~/.zsh_plugins

    [[ ! -d ~/.zsh_plugins/zsh-autosuggestions ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_plugins/zsh-autosuggestions

    [[ ! -d ~/.zsh_plugins/zsh-syntax-highlighting ]] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh_plugins/zsh-syntax-highlighting

    cat > ~/.zshrc << EOF
export TERM="xterm-256color"

source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='eza --icons=always'
alias ll='eza -lh --icons=always'

PROMPT='%F{cyan}(${nickname}) ➜ %~ %# %f'
EOF

    chsh -s zsh
}

# ================= 9. SAVE COMMAND =================
save_script() {
    cp "$0" "$PREFIX/bin/auto-termux"
    chmod +x "$PREFIX/bin/auto-termux"
}

# ================= 10. EXECUTION FLOW =================

system_update

case $choice in
    1) install_frontend ;;
    2) install_backend ;;
    3) install_fullstack ;;
    4) echo -e "${Y}Exit ${nickname} 👋${N}"; exit ;;
    *) echo -e "${Y}Invalid choice → continuing setup${N}" ;;
esac

install_fonts
install_style
install_zsh
save_script

# ================= FINAL =================
echo -e "\n${G}──────────────────────────────${N}"
echo -e "${W}SETUP COMPLETE ✔ TYPE: ${C}auto-termux${N}"
echo -e "${G}──────────────────────────────${N}"

exec zsh
