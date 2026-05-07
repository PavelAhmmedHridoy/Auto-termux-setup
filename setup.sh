#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X NITRO v25.3 - THE ULTIMATE STABLE RELEASE
# =============================================================

# ---------- 1. PRE-FLIGHT (CRASH PROOF) ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; PINK='\033[38;5;206m'; CYAN='\033[38;5;87m'; NC='\033[0m'

# Capture absolute path for devsetup alias
SCRIPT_PATH=$(realpath "$0" 2>/dev/null || echo "$HOME/$(basename "$0")")

set -e
trap 'echo -e "${RED}\n[!] ERROR DETECTED. Running Auto-Fix...${NC}"; dpkg --configure -a || true' ERR

# ---------- 2. BRANDING ----------
clear
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo -e " ██╔════╝ ██║   ██║ ██████╔╝ █████╗  ${CYAN}ULTIMATE${NC}"
echo -e " ╚██████╗ ╚██████╔╝ ██║  ╚═╝ ███████╗ ${CYAN}v25.3${NC}"
echo -e "  ╚═════╝  ╚═════╝  ╚═╝      ╚══════╝${NC}\n"

# ---------- 3. SMART INPUT (NON-BLOCKING) ----------
echo -ne "${PINK}[?] Nickname: ${NC}"
if ! read -t 10 -r nickname < /dev/tty; then
    nickname="User"
    echo -e "${YELLOW}(Timeout: Defaulting to 'User')${NC}"
fi
nickname=${nickname:-User}

# ---------- 4. SPEED DEPLOYMENT ----------
echo -e "${YELLOW}[*] Quick-Syncing Repos...${NC}"
pkg update -z -q # Quiet and fast sync

# Selective Install (Only if missing)
for pkg in zsh eza zoxide git curl termux-api; do
    if ! command -v $pkg >/dev/null 2>&1; then
        echo -e "${CYAN}[+] Installing $pkg...${NC}"
        pkg install -y "$pkg" -q
    fi
done

# ---------- 5. ASYNC BACKGROUND TASKS ----------
mkdir -p ~/.termux ~/.zsh-plugins
Z_DIR="$HOME/.zsh-plugins"

# Background cloning of plugins for speed
(
    [[ -d "$Z_DIR/syntax" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$Z_DIR/syntax" >/dev/null 2>&1
    [[ -d "$Z_DIR/suggest" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$Z_DIR/suggest" >/dev/null 2>&1
    [[ -f ~/.termux/font.ttf ]] || curl -L -s -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
    termux-reload-settings
) &

# ---------- 6. BULLETPROOF ZSH LOGIC ----------
echo -e "${YELLOW}[*] Configuring Nitro Engine...${NC}"
cat <<EOF > ~/.zshrc
# --- SYSTEM ---
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGINS ---
Z_DIR="\$HOME/.zsh-plugins"
# Fail-safe source
[[ -f "\$Z_DIR/suggest/zsh-autosuggestions.zsh" ]] && source "\$Z_DIR/suggest/zsh-autosuggestions.zsh"
[[ -f "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$Z_DIR/syntax/zsh-syntax-highlighting.zsh"

# --- TOOLS ---
[[ -x "\$(command -v zoxide)" ]] && eval "\$(zoxide init zsh)"

# --- RANDOM SPECTRUM ENGINE (MULTI-COMMAND READY) ---
RAND_COLOR=\$(( ( RANDOM % 180 )  + 35 ))
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# Command & Structure
ZSH_HIGHLIGHT_STYLES[command]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=206,bold"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=206,bold" # Highlighting for ; && ||
ZSH_HIGHLIGHT_STYLES[precommand]="fg=206,underline"

# Arguments & Options (The 'mkdir rfg' fix)
ZSH_HIGHLIGHT_STYLES[argument]="fg=118"
ZSH_HIGHLIGHT_STYLES[argument-fast]="fg=118"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=214"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=214"

# Path & Error
ZSH_HIGHLIGHT_STYLES[path]="fg=33,underline"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=160,bold"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# --- ALIASES ---
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias cd='z'
alias devsetup='bash $SCRIPT_PATH'

# --- INTERFACE ---
PROMPT='%F{206}(%F{\$RAND_COLOR}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- 7. HANDOVER ----------
chsh -s zsh 2>/dev/null || true

echo -e "\n${GREEN}[✔] CORE-X NITRO DEPLOYED.${NC}"
echo -e "${CYAN}[*] Refresh with: ${PINK}devsetup${NC}"

# Ensure we land in ZSH
if command -v zsh >/dev/null; then
    exec zsh
else
    echo -e "${RED}[!] Critical Error: ZSH not found.${NC}"
fi
