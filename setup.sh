#!/data/data/com.termux/files/usr/bin/bash

# ================= COLORS =================
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
P='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'
U='\033[4m'

# ================= RANDOM COLORS =================
colors=(
"\033[1;31m" "\033[1;32m" "\033[1;33m"
"\033[1;34m" "\033[1;35m" "\033[1;36m"
"\033[1;37m"
)

random_color_word() {
    for word in $1; do
        color=${colors[$RANDOM % ${#colors[@]}]}
        echo -ne "${color}${word}${N} "
    done
    echo ""
}

# ================= ASCII UI =================
clear

echo -e "${C}"
echo "╔════════════════════════════════════════════╗"
echo "║        ⚡ AUTO TERMUX SETUP TOOL ⚡         ║"
echo "╠════════════════════════════════════════════╣"
echo "║   DEV MODE • UI ENGINE • PACKAGE BUILDER   ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${N}"

# ================= NICKNAME =================
echo -ne "${W}Enter Nickname ❱ ${N}"
read nickname
[[ -z "$nickname" ]] && nickname="User"

# ================= MENU =================
echo -e "\n${U}${W}SELECT MODE:${N}"
echo -e "${C}1 Frontend"
echo -e "${C}2 Backend"
echo -e "${C}3 Custom Packages"
echo -e "${C}4 Just UI"
echo -ne "\nChoice ❱ ${N}"
read choice

# ================= FUNCTIONS =================
install_frontend() {
    echo -e "\n${P}⚡ FRONTEND SETUP${N}"
    pkg install nodejs git -y

    echo -ne "${C}Install live-server + prettier? [y/n] ❱ ${N}"
    read ans
    [[ "$ans" =~ ^[Yy]$ ]] && npm install -g live-server prettier
}

install_backend() {
    echo -e "\n${B}⚙ BACKEND SETUP${N}"
    pkg install python python-pip mariadb php git -y
}

install_custom() {
    echo -e "\n${P}📦 CUSTOM PACKAGE MODE${N}"
    echo -ne "${C}Enter packages ❱ ${N}"
    read pkgs
    [[ -n "$pkgs" ]] && pkg install $pkgs -y
}

# ================= SYSTEM =================
pkg update -y && pkg upgrade -y
pkg install zsh git curl eza ncurses-utils -y

# ================= FONT =================
mkdir -p ~/.termux
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" \
-o ~/.termux/font.ttf

echo "font-size = 13" > ~/.termux/termux.properties
termux-reload-settings

# ================= MODE EXEC =================
case $choice in
    1) install_frontend ;;
    2) install_backend ;;
    3) install_custom ;;
    4) echo -e "${Y}UI ONLY MODE${N}" ;;
    *) echo -e "${Y}Invalid choice → UI MODE${N}" ;;
esac

# ================= COMMAND PREVIEW UI =================
echo -e "\n${U}COMMAND PREVIEW UI${N}\n"

echo -e "${C}Single command:${N}"
random_color_word "pkg install python"

echo -e "\n${C}Multiple commands (one line):${N}"
random_color_word "pkg update && pkg upgrade && pkg install git"

echo -e "\n${C}Multiple commands (multi-line):${N}"
random_color_word "pkg update -y"
random_color_word "pkg upgrade -y"
random_color_word "pkg install git -y"

# ================= TERMUX STYLE =================
echo -e "\n${Y}Installing termux-style...${N}"

if [[ ! -d "$HOME/termux-style" ]]; then
    git clone https://github.com/adi1090x/termux-style "$HOME/termux-style"
    cd "$HOME/termux-style" || exit
    chmod +x install
    ./install
fi

cd "$HOME"

bash -c "termux-style"
read -p "Press Enter after theme selection..."

rm -rf "$HOME/termux-style"

# ================= ZSH =================
mkdir -p ~/.zsh_plugins

[[ ! -d ~/.zsh_plugins/zsh-autosuggestions ]] && \
git clone https://github.com/zsh-users/zsh-autosuggestions \
~/.zsh_plugins/zsh-autosuggestions

[[ ! -d ~/.zsh_plugins/zsh-syntax-highlighting ]] && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
~/.zsh_plugins/zsh-syntax-highlighting

cat > ~/.zshrc << EOF
export TERM="xterm-256color"

source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='eza --icons=always'
alias ll='eza -lh --icons=always'
alias auto-termux='auto-termux'

PROMPT="%B%F{51}( ${nickname} ) ➜ %~ $ %f%b"
EOF

chsh -s zsh

# ================= SAVE COMMAND =================
cp "$0" "$PREFIX/bin/auto-termux"
chmod +x "$PREFIX/bin/auto-termux"

# ================= CLEANUP =================
echo -e "\n${G}Cleaning installer...${N}"
rm -f "$0"

echo -e "${C}Run again: auto-termux${N}"

exec zsh
