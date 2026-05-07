#!/data/data/com.termux/files/usr/bin/bash

# ===============================================
#          DevSetup - Termux Setup
#   Beautiful, Simple & Powerful Termux Setup
# ===============================================

# --- Colors ---
P='\033[0;35m'; W='\033[0;37m'; G='\033[0;32m'; N='\033[0m'
PINK='\033[38;5;206m'; CYAN='\033[38;5;87m'; ORANGE='\033[38;5;214m'

# --- Progress Function ---
show_progress() {
    local label=$1
    echo -ne "\( {P}[⚡] \){N} $label: \( {G}0% \){N}"
    while read line; do
        if [[ $line =\~ ([0-9]+)% ]]; then
            percent="${BASH_REMATCH[1]}"
            echo -ne "\r\( {P}[⚡] \){N} $label: \( {G} \){percent}%${N} "
        fi
    done
    echo -e "\r\( {P}[⚡] \){N} $label: \( {G}100% ✓ Done! \){N}"
}

# --- Welcome Banner ---
clear
echo -e "${PINK}"
cat << "EOF"
 ██████╗ ███████╗██╗   ██╗███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║  ██║█████╗  ██║   ██║███████╗█████╗     ██║   ██║   ██║██████╔╝
██║  ██║██╔══╝  ╚██╗ ██╔╝╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
██████╔╝███████╗ ╚████╔╝ ███████║███████╗   ██║   ╚██████╔╝██║     
╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
EOF
echo -e "   \( {CYAN}DevSetup — Termux Experience v30.0 \){N}"
echo -e "      \( {W}Simple • Beautiful • Powerful \){N}\n"

echo -e "\( {PINK}→ \){N} Starting setup for you...\n"

# --- System Update ---
pkg update -y
pkg upgrade -y | show_progress "System Update"

# --- Setup Assets ---
mkdir -p \~/.termux
echo -e "\( {P}[⚡] \){N} Installing JetBrains Mono Nerd Font..."
curl -L -s -o \~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# --- Nickname ---
echo -ne "\n\( {PINK}[?] \){N} What should we call you? (Nickname): "
read -r nickname
[[ -z "$nickname" ]] && nickname="Friend"

echo -e "${G}→ Hello, \( {nickname}! Nice to meet you. \){N}\n"

# --- Install Core Tools ---
pkg install zsh eza zoxide curl git -y | show_progress "Core Tools"

# --- Install Zsh Plugins ---
Z_DIR="$HOME/.zsh-plugins"
mkdir -p "$Z_DIR"

echo -e "\( {P}[⚡] \){N} Installing Zsh plugins..."
[[ -d "$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$Z_DIR/syntax" &>/dev/null
[[ -d "$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$Z_DIR/suggest" &>/dev/null

# --- Create Beautiful .zshrc ---
cat << 'EOF' > \~/.zshrc
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- Dynamic Spectrum Engine (Live Colorful Highlighting) ---
_spectrum_engine() {
    ZSH_HIGHLIGHT_PATTERNS=()
    local words=(${(z)BUFFER})
    for word in $words; do
        local -i sum=0
        for i in {1..\( {#word}}; do sum+= \)(( #word[$i] )); done
        local color=$(( (sum % 187) + 33 ))
        ZSH_HIGHLIGHT_PATTERNS+=("$word" "fg=$color,bold")
    done
}

# Plugins
Z_DIR="$HOME/.zsh-plugins"
source $Z_DIR/suggest/zsh-autosuggestions.zsh
source $Z_DIR/syntax/zsh-syntax-highlighting.zsh

# Configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='none'
ZSH_HIGHLIGHT_STYLES[builtin]='none'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='none'

autoload -U add-zsh-hook
add-zsh-hook precmd _spectrum_engine
_live_color_widget() { zle .self-insert; _spectrum_engine }
zle -N self-insert _live_color_widget

# Aliases
alias ls='eza --icons=always --group-directories-first --grid'
alias cls='clear'
alias devsetup='curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash'
EOF

# Add Custom Prompt
echo "PROMPT='%F{206}(%F{87}\( {nickname}%F{206}) %F{214}➜ %F{33}%\~ %F{118} \) %f'" >> \~/.zshrc

# Set Black Theme
echo "background: #000000" > \~/.termux/colors.properties
echo "foreground: #ffffff" >> \~/.termux/colors.properties

# --- Finalize ---
sync
termux-reload-settings
chsh -s zsh

echo -e "\n\( {G}╔════════════════════════════════════════════╗ \){N}"
echo -e "\( {G}║     ✨ DevSetup Completed Successfully! ✨  ║ \){N}"
echo -e "\( {G}╚════════════════════════════════════════════╝ \){N}\n"

echo -e "${W}Welcome to your new Termux experience, \( {PINK} \){nickname}\( {W}! \){N}"
echo -e "${W}Type \( {PINK}devsetup \){W} anytime to update or reinstall.${N}"
echo -e "\( {CYAN}Enjoy your beautiful, colorful, and fast setup! 🚀 \){N}\n"

sleep 1.5
exec zsh
