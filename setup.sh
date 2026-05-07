#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# CORE-X ABSOLUTE SPECTRUM v25.3 - THE FINAL BOSS
# =============================================================

# ---------- SECTION 1: ENVIRONMENT & SAFETY ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
PINK='\033[38;5;206m'; CYAN='\033[38;5;87m'; NC='\033[0m'

# Determine the permanent script path for the refresh command
# This ensures 'devsetup' always finds the file
SCRIPT_FILE=$(realpath "$0" 2>/dev/null || echo "$HOME/setup.sh")

set -e
trap 'echo -e "${RED}\n[!] SYSTEM CRASH PREVENTED. RUN: dpkg --configure -a${NC}"' ERR

# Error-safe task wrapper
run_task() {
    local task_name=$1
    shift
    echo -e "${YELLOW}[*] $task_name...${NC}"
    if "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}[✔] $task_name Successful.${NC}"
    else
        echo -e "${RED}[✘] $task_name Failed (Continuing Fix).${NC}"
    fi
}

# ---------- SECTION 2: BRANDING & IDENTITY ----------
clear
echo -e "${PINK} ██████╗ ██████╗ ██████╗ ███████╗"
echo -e " ██╔════╝ ██║   ██║ ██████╔╝ █████╗  ${CYAN}NITRO-CORE${NC}"
echo -e " ╚██████╗ ╚██████╔╝ ██║  ╚═╝ ███████╗ ${CYAN}v25.3${NC}"
echo -e "  ╚═════╝  ╚═════╝  ╚═╝      ╚══════╝${NC}"
echo -e "      ${CYAN}--- ABSOLUTE SPECTRUM STABLE ---${NC}\n"

echo -ne "${PINK}[?] Nickname: ${NC}"
read -t 15 -r nickname < /dev/tty || nickname="User"
nickname=${nickname:-User}

# ---------- SECTION 3: LIGHTWEIGHT DEPLOYMENT ----------
run_task "Syncing Repositories" pkg update -y
run_task "Deploying Binaries" pkg install -y zsh eza zoxide git nodejs-lts ruby termux-api curl

# ---------- SECTION 4: ASYNC CACHING (SPEED) ----------
# We do the heavy lifting in the background
mkdir -p ~/.termux ~/.zsh-plugins
(
    [[ -f ~/.termux/font.ttf ]] || curl -L -s -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
    [[ -d ~/.zsh-plugins/syntax ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-plugins/syntax >/dev/null 2>&1
    [[ -d ~/.zsh-plugins/suggest ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh-plugins/suggest >/dev/null 2>&1
    termux-reload-settings
) &

# ---------- SECTION 5: SPECTRUM LOGIC GENERATION ----------
echo -e "${YELLOW}[*] Injecting Color Engine Logic...${NC}"

cat <<EOF > ~/.zshrc
# --- EXPORTS ---
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- PLUGIN LOADER ---
# Fail-safe sourcing
[[ -f "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh" ]] && source "\$HOME/.zsh-plugins/suggest/zsh-autosuggestions.zsh"
[[ -f "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh" ]] && source "\$HOME/.zsh-plugins/syntax/zsh-syntax-highlighting.zsh"

# --- INIT TOOLS ---
[[ -x "\$(command -v zoxide)" ]] && eval "\$(zoxide init zsh)"

# --- RANDOM SPECTRUM ENGINE ---
# Picks a random vibrant color (35-215) for every session
RAND_COLOR=\$(( ( RANDOM % 180 )  + 35 ))

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# Commands & Multi-Command Logic
ZSH_HIGHLIGHT_STYLES[command]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=\$RAND_COLOR,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=206,bold"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=206,bold" # Highlighting for ; && ||
ZSH_HIGHLIGHT_STYLES[precommand]="fg=206,underline"

# Argument Highlighting (Makes 'rfg' colorful)
ZSH_HIGHLIGHT_STYLES[argument]="fg=118"
ZSH_HIGHLIGHT_STYLES[argument-fast]="fg=118"
ZSH_HIGHLIGHT_STYLES[argument-slow]="fg=118"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=214"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=214"

# Path & Strings
ZSH_HIGHLIGHT_STYLES[path]="fg=33,underline"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=226"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=226"

# Error Feedback
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=160,bold"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# --- SECTION 6: ALIASES & REFRESH ---
alias ls='eza --icons=always --group-directories-first --grid --color=always'
alias ll='eza --icons=always --group-directories-first -lh'
alias cls='clear'
alias cd='z'
alias copy='termux-clipboard-set'
alias paste='termux-clipboard-get'

# THE REFRESH COMMAND (FIXED)
# Points to the absolute path discovered at install
alias devsetup='bash $SCRIPT_FILE'

# --- SECTION 7: UI & PROMPT ---
PROMPT='%F{206}(%F{\$RAND_COLOR}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'

# Fix for multi-line command editing
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
EOF

# ---------- SECTION 8: FINALIZATION ----------
chsh -s zsh || true

echo -e "\n${GREEN}[✔] CORE-X DEPLOYED SUCCESSFULLY${NC}"
echo -e "${CYAN}[*] REFRESH COLORS ANYTIME WITH: ${PINK}devsetup${NC}"

# Launch into the new shell
exec zsh
