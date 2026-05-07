#!/data/data/com.termux/files/usr/bin/bash

# ==================================================
#           DevSetup v30 — SPECTRUM AUTO
#        No User Input - Instant Deployment
# ==================================================

set -e

# --- Colors for Terminal ---
P='\033[0;35m'; W='\033[0;37m'; G='\033[0;32m'; N='\033[0m'
PINK='\033[38;5;206m'; CYAN='\033[38;5;87m'

# --- Banner ---
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
echo -e "${CYAN}   DevSetup v30 — SPECTRUM EDITION (AUTO)${N}\n"

# --- System Update ---
echo -e "${P}[⚡]${N} Syncing Repositories..."
pkg update -y && pkg upgrade -y

# --- Install Packages ---
echo -e "${P}[⚡]${N} Installing Core Tools..."
pkg install -y zsh git curl eza zoxide

# --- Font (JetBrains Nerd Font) ---
mkdir -p "$HOME/.termux"
curl -fsSL -o "$HOME/.termux/font.ttf" \
"https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# --- Default Configs ---
nickname="DevUser"
PLUGIN_DIR="$HOME/.zsh-plugins"
mkdir -p "$PLUGIN_DIR"

# --- Clone Plugins ---
echo -e "${P}[⚡]${N} Injecting ZSH Plugins..."
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/syntax" 2>/dev/null || true
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/suggest" 2>/dev/null || true

# --- THE MASTER SPECTRUM .ZSHRC ---
cat > "$HOME/.zshrc" <<EOF
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- SPECTRUM ENGINE (DYNAMIC WORD COLORS) ---
_spectrum_engine() {
    ZSH_HIGHLIGHT_PATTERNS=()
    local words=(\${(z)BUFFER})
    for word in \$words; do
        local -i sum=0
        # Character hashing for unique color per word
        for i in {1..\${#word}}; do sum+=\$(( #word[\$i] )); done
        # Color range 33-220 (No White, No Blue Defaults, No Black)
        local color=\$(( (sum % 187) + 33 ))
        ZSH_HIGHLIGHT_PATTERNS+=("\$word" "fg=\$color,bold")
    done
}

# Load Plugins
source "$PLUGIN_DIR/suggest/zsh-autosuggestions.zsh"
source "$PLUGIN_DIR/syntax/zsh-syntax-highlighting.zsh"

# Force Spectrum & Strip Defaults
ZSH_HIGHLIGHT_HIGHLIGHTERS=(pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='none'
ZSH_HIGHLIGHT_STYLES[builtin]='none'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='none'

# Trigger Logic
autoload -U add-zsh-hook
add-zsh-hook precmd _spectrum_engine
_live_color_widget() { zle .self-insert; _spectrum_engine }
zle -N self-insert _live_color_widget

# Aliases
alias ls='eza --icons --group-directories-first --grid'
alias cls='clear'
alias devsetup='curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash'

# Prompt
PROMPT='%F{206}(${nickname})%f %F{87}➜ %F{214}%~ %f$ '
EOF

# --- Theme & UI ---
cat > "$HOME/.termux/colors.properties" <<EOF
background=#000000
foreground=#ffffff
EOF

# --- Finalize ---
termux-reload-settings 2>/dev/null || true
chsh -s zsh 2>/dev/null || true

echo -e "\n${G}✔ DevSetup Spectrum Deployed Successfully!${N}"
echo -e "${W}Type ${PINK}devsetup${W} anytime to update from GitHub.${N}"

sync
exec zsh
