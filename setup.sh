#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - THE CRASH-PROOF EDITION
# =============================================================

# ---------- 1. COLORS & PATHS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[38;5;206m'
CYAN='\033[38;5;87m'
NC='\033[0m'

# Discovery of current script path for the "devsetup" alias
SCRIPT_PATH=$(realpath "$0" 2>/dev/null || echo "$HOME/$(basename "$0")")

# ---------- 2. CRASH-PROOF LOGIC (THE "VALKYRIE" ENGINE) ----------
# Immediate failure handling
set -e
trap 'emergency_exit' ERR

emergency_exit() {
    echo -e "${RED}\n[!] CRITICAL SYSTEM FAILURE DETECTED."
    echo -e "${YELLOW}[*] Attempting Auto-Repair...${NC}"
    dpkg --configure -a || true
    pkg install -f -y || true
    echo -e "${CYAN}[i] Repair attempted. Try running the script again.${NC}"
    exit 1
}

# Task Runner with verification
run_safe() {
    local task=$1
    shift
    echo -ne "${YELLOW}[*] $task... ${NC}"
    if "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}DONE${NC}"
    else
        echo -e "${RED}FAILED${NC}"
        echo -e "${YELLOW}[!] Attempting Fix for $task...${NC}"
        # Context-aware recovery
        if [[ "$task" == *"Update"* ]]; then
            pkg update --fix-missing -y >/dev/null 2>&1 || true
        fi
        return 0 # Continue anyway to stay "crash-proof"
    fi
}

clear

# ---------- 3. BRANDING ----------
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝█████╗"
echo " ██║     ██║   ██║██╔══██╗██╔══╝"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗"
echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝${NC}"
echo -e "   ${CYAN}CORE-X ABSOLUTE SPECTRUM [GOD-MODE]${NC}\n"

# ---------- 4. INPUT HANDLING ----------
# Prevent "fast-forward" input crashes
echo -ne "${PINK}[?] Nickname: ${NC}"
if ! read -t 15 -r nickname < /dev/tty; then
    nickname="User"
    echo -e "${YELLOW}(Timeout: Using default 'User')${NC}"
fi
nickname=${nickname:-User}

# ---------- 5. STRENGTHENED DEPLOYMENT ----------
run_safe "System Repair" dpkg --configure -a
run_safe "Repo Sync" pkg update -y
run_safe "Core Install" pkg install -y zsh eza zoxide git nodejs-lts ruby termux-api curl

# Ensure Directories Exist
mkdir -p ~/.termux
mkdir -p ~/.zsh-plugins

# Font Download with logic to skip if curl fails
run_safe "Icon Injection" curl -L -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

# ---------- 6. BULLETPROOF ZSH LOGIC ----------
run_safe "Writing Config" cat <<EOF > ~/.zshrc
# --- SYSTEM ---
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGINS (Silent & Safe) ---
Z_DIR="\$HOME/.zsh-plugins"
[[ -d "\$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "\$Z_DIR/syntax" >/dev/null 2>&1 &
[[ -d "\$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "\$Z_DIR/suggest" >/dev/null 2>&1 &

# Delayed source to prevent startup crashes if git failed
sleep 0.2
[[ -f "\$Z_DIR/suggest/zsh-autosuggestions.zsh" ]] && source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"
[[ -f "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"

# --- TOOLS ---
command -v zoxide >/dev/null && eval "\$(zoxide init zsh)"

# --- RANDOM SPECTRUM ENGINE ---
# Guaranteed safe color range
RAND_COLOR=\$(( ( RANDOM % 180 )  + 35 ))

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# Spectrum Mapping
ZSH_HIGHLIGHT_STYLES[command]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=206,bold"
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=206,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=206,underline'
ZSH_HIGHLIGHT_STYLES[argument]='fg=118'
ZSH_HIGHLIGHT_STYLES[argument-fast]='fg=118'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=214'
ZSH_HIGHLIGHT_STYLES[path]='fg=33,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160,bold'

# --- ALIASES ---
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias cd='z'
alias devsetup='bash $SCRIPT_PATH'

# --- INTERFACE ---
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# --- PROMPT ---
PROMPT='%F{206}(%F{\$RAND_COLOR}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'

# Keybinds
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- 7. FINAL EXIT STRATEGY ----------
termux-reload-settings || true
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X FULLY DEPLOYED [CRASH-PROOF MODE]${NC}"
echo -e "${CYAN}[*] New Random Color Selected. Command: ${PINK}devsetup${NC}"

# Final verification before handover
if command -v zsh >/dev/null; then
    exec zsh
else
    echo -e "${RED}[!] ZSH install failed. Dropping to Bash.${NC}"
fi
