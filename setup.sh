#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================================
# 1. THE COLOR PALETTE & UI ASSETS
# ==============================================================================
C='\033[1;36m'; W='\033[1;37m'; G='\033[1;32m'; Y='\033[1;33m'
R='\033[1;31m'; P='\033[1;35m'; B='\033[1;34m'; N='\033[0m'
BG_B='\033[44m'; U='\033[4m'

# ==============================================================================
# 2. INTERNAL MODULE INSTALLERS
# ==============================================================================
install_frontend_module() {
    case $1 in
        1) npm install -g live-server ;;
        2) npm install -g prettier ;;
        3) npm install -g vite ;;
    esac
}

install_backend_module() {
    case $1 in
        1) pip install flask ;;
        2) pip install fastapi ;;
        3) pip install websockets ;;
    esac
}

# ==============================================================================
# 3. CORE SYSTEM FUNCTIONS
# ==============================================================================
system_repair() {
    echo -e "\n${Y}[SYSTEM] Phase 1: Heavy Repair & Sync...${N}"
    # Aggressive one-line chain to fix potential library mismatches
    apt update -y && apt full-upgrade -y && pkg install zsh git eza curl ncurses-utils nodejs python -y --reinstall || {
        dpkg --configure -a && apt install -f -y && apt full-upgrade -y
    }
}

setup_icons() {
    echo -e "${Y}[SYSTEM] Phase 2: Deploying Nerd-Fonts & Glyphs...${N}"
    mkdir -p ~/.termux
    curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf
    echo "font-size = 13" > ~/.termux/termux.properties && termux-reload-settings
}

apply_styling() {
    echo -e "${Y}[SYSTEM] Phase 3: Launching Style Engine...${N}"
    if [[ ! -d "$HOME/termux-style" ]]; then
        git clone https://github.com/adi1090x/termux-style "$HOME/termux-style"
        cd "$HOME/termux-style" && ./install
        echo -e "${G}>>> SELECT THEME & FONT. CLEANUP STARTS AFTER MENU EXIT...${N}"
        termux-style < /dev/tty
        cd - > /dev/null
        rm -rf "$HOME/termux-style" # Total folder removal
    else
        termux-style < /dev/tty
    fi
}

# ==============================================================================
# 4. MAIN EXECUTION FLOW
# ==============================================================================
clear
echo -e "${C}"
cat << "EOF"
╔════════════════════════════════════════════╗
║     ⚡ TERMUX DEPENDENCY INSTALLER ⚡      ║
╠════════════════════════════════════════════╣
║   CLEAN ENV → GHOST MODULE SYSTEM          ║
╚════════════════════════════════════════════╝
EOF
echo -e "${N}"

# Step 1: Identity
echo -ne "${W}Enter your name ❱ ${N}"
read name
name=${name:-User}

# Step 2: Path Selection
echo -e "\n${U}${W}SELECT ENVIRONMENT:${N}"
echo -e "${C}1) Frontend ${W}(NodeJS/Web)${N}"
echo -e "${C}2) Backend  ${W}(Python/Server)${N}"
echo -ne "\nChoice ❱ ${N}"
read env
[[ "$env" == "1" ]] && ENV_TYPE="frontend" || ENV_TYPE="backend"

# Step 3: The Module Question
echo -e "\n${W}Do you want to install additional modules?${N}"
echo -e "${G}1) Yes, show options"
echo -e "${R}2) No, skip to UI setup"
echo -ne "\nChoice ❱ ${N}"
read want

if [[ "$want" == "1" ]]; then
    # Start System Core for Modules
    system_repair
    setup_icons

    # Module Selection Menu
    echo -e "\n${W}Available Modules (${ENV_TYPE^^}):${N}"
    if [[ "$ENV_TYPE" == "frontend" ]]; then
        echo -e "${C}1) live-server  2) prettier  3) vite"
    else
        echo -e "${C}1) flask  2) fastapi  3) websockets"
    fi
    echo -e "${Y}0) Install ALL  ${R}9) Back  ${R}8) Exit${N}"
    echo -ne "\nChoice ❱ ${N}"
    read mode

    case $mode in
        0)
            if [[ "$ENV_TYPE" == "frontend" ]]; then
                for i in {1..3}; do install_frontend_module $i; done
            else
                for i in {1..3}; do install_backend_module $i; done
            fi
            ;;
        1|2|3)
            [[ "$ENV_TYPE" == "frontend" ]] && install_frontend_module $mode || install_backend_module $mode
            ;;
        9) exec bash "$0" ;;
        8) exit ;;
        *) echo -e "${Y}Skipping invalid choice...${N}" ;;
    esac
else
    echo -e "\n${Y}[!] Skipping dependency modules...${N}"
fi

# Step 4: UI and Styling
apply_styling

# Register 'auto-termux' for rerun persistence
cp "$0" "$PREFIX/bin/auto-termux"
chmod +x "$PREFIX/bin/auto-termux"

# Step 5: Shell Provisioning
echo -e "${Y}[SYSTEM] Phase 4: Finalizing Custom Zsh...${N}"
mkdir -p ~/.zsh_plugins
[[ -d ~/.zsh_plugins/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh_plugins/zsh-syntax-highlighting
[[ -d ~/.zsh_plugins/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_plugins/zsh-autosuggestions

cat << EOF > ~/.zshrc
export TERM="xterm-256color"
export LC_ALL=C.UTF-8
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lh --icons=always --group-directories-first'
alias la='eza -a --icons=always'
alias auto-termux='auto-termux'
PROMPT='%B%F{51}(%F{51}${name}%F{51}) %F{226}➜ %F{33}%~ %F{118}$ %f%b'
EOF

# ==============================================================================
# 5. CLEANUP & HANDOVER
# ==============================================================================
chsh -s zsh
echo -e "\n${G}────────────────────────────────────────────────────────────${N}"
echo -e "       ${W}SYSTEM READY: TYPE ${C}auto-termux${W} TO RERUN${N}"
echo -e "       ${R}CLEANUP: setup.sh & termux-style folder REMOVED${N}"
echo -e "${G}────────────────────────────────────────────────────────────${N}"

# Ghost Self-Destruct
(sleep 2; rm -f "$0") & 
exec zsh
