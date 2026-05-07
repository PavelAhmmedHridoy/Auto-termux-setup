#!/data/data/com.termux/files/usr/bin/bash

# ==================================================
#                 DevSetup v30
#     Clean • Fast • Modular Termux Setup
# ==================================================

# --- Colors ---
P='\033[0;35m'
W='\033[0;37m'
G='\033[0;32m'
N='\033[0m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'

# --- Simple Progress System ---
show_progress() {
    local label="$1"
    echo -ne "${P}[⚡]${N} $label... ${G}0%${N}"

    while read -r line; do
        if [[ $line =~ ([0-9]+)% ]]; then
            percent="${BASH_REMATCH[1]}"
            echo -ne "\r${P}[⚡]${N} $label... ${G}${percent}%${N}"
        fi
    done

    echo -e "\r${P}[⚡]${N} $label... ${G}100% ✓ Done${N}"
}

# --- Welcome Screen ---
clear
echo -e "${PINK}"
cat << "EOF"
██████╗ ███████╗██╗   ██╗███████╗███████╗████████╗
██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝╚══██╔══╝
██║  ██║█████╗  ██║   ██║███████╗█████╗     ██║   
██║  ██║██╔══╝  ╚██╗ ██╔╝╚════██║██╔══╝     ██║   
██████╔╝███████╗ ╚████╔╝ ███████║███████╗   ██║   
╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝   ╚═╝   
EOF

echo -e "${CYAN}DevSetup v30 — Modern Termux Environment${N}"
echo -e "${W}Simple • Clean • Developer Friendly${N}\n"

# --- System Update ---
pkg update -y
pkg upgrade -y | show_progress "Updating System"

# --- Font Setup ---
mkdir -p "$HOME/.termux"

echo -e "${P}[⚡]${N} Installing Nerd Font..."
curl -fsSL -o "$HOME/.termux/font.ttf" \
"https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# --- User Name ---
echo -ne "\n${PINK}What should I call you? ${N}"
read -r nickname
nickname="${nickname:-User}"

echo -e "${G}Nice to meet you, $nickname ✨${N}\n"

# --- Core Packages ---
pkg install -y zsh git curl eza zoxide | show_progress "Installing Tools"

# --- Plugins ---
PLUGIN_DIR="$HOME/.zsh-plugins"
mkdir -p "$PLUGIN_DIR"

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
"$PLUGIN_DIR/syntax" 2>/dev/null || true

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
"$PLUGIN_DIR/suggest" 2>/dev/null || true

# --- ZSH CONFIG ---
cat > "$HOME/.zshrc" <<EOF
export TERM="xterm-256color"

Z_DIR="\$HOME/.zsh-plugins"

# Plugins
source \$Z_DIR/suggest/zsh-autosuggestions.zsh
source \$Z_DIR/syntax/zsh-syntax-highlighting.zsh

# Clean aliases
alias ls='eza --icons --group-directories-first'
alias cls='clear'
alias devsetup='curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash'
EOF

# --- Prompt (safe + simple) ---
echo "PROMPT='%F{206}(${nickname})%f %F{87}➜ %F{214}%~ %f$ '" >> "$HOME/.zshrc"

# --- Theme ---
mkdir -p "$HOME/.termux"
cat > "$HOME/.termux/colors.properties" <<EOF
background=#000000
foreground=#ffffff
EOF

# --- Finish ---
termux-reload-settings 2>/dev/null || true
chsh -s zsh 2>/dev/null || true

echo -e "\n${G}✔ DevSetup installed successfully!${N}"
echo -e "${W}Restart Termux or it will auto switch to Zsh.${N}\n"

exec zsh
