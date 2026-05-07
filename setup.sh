#!/data/data/com.termux/files/usr/bin/bash

# --- DevCoreX Official Palette ---
P='\033[0;35m'; W='\033[0;37m'; G='\033[0;32m'; N='\033[0m'
PINK='\033[38;5;206m'; CYAN='\033[38;5;87m'; ORANGE='\033[38;5;214m'

# --- 1. THE PROGRESS ENGINE ---
show_progress() {
    local label=$1
    echo -ne "${P}[⚡]${N} $label: ${G}0%${N}"
    while read line; do
        if [[ $line =~ ([0-9]+)% ]]; then
            percent="${BASH_REMATCH[1]}"
            echo -ne "\r${P}[⚡]${N} $label: ${G}${percent}%${N} "
        fi
    done
    echo -e "\r${P}[⚡]${N} $label: ${G}100% - Done!${N}"
}

# --- 2. BRANDING ---
clear
echo -e "${PINK}"
echo " ██████╗ ██████╗ ██████╗ ███████╗"
echo "██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo "██║     ██║   ██║██████╔╝█████╗  "
echo "██║     ██║   ██║██╔══██╗██╔══╝  "
echo "╚██████╗╚██████╔╝██║  ██║███████╗"
echo " ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "   ${CYAN}TERMUX MODULAR FRAMEWORK v29.0${N}"
echo -e "      ${W}DYNAMIC SPECTRUM & AUTO-RERUN${N}\n"

# --- 3. SYSTEM REPAIR ---
pkg update -y
pkg upgrade -y | show_progress "System Sync"

# --- 4. ASSETS ---
mkdir -p ~/.termux
curl -L -s -o ~/.termux/font.ttf "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"

echo -ne "\n${PINK}[?]${N} Nickname: "; read nickname
[[ -z "$nickname" ]] && nickname="User"

pkg install zsh eza zoxide curl git -y | show_progress "Core Tools"

# --- 5. PLUGINS ---
Z_DIR="$HOME/.zsh-plugins"
mkdir -p "$Z_DIR"
[[ -d "$Z_DIR/syntax" ]] || git clone --depth=1 "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$Z_DIR/syntax" &>/dev/null
[[ -d "$Z_DIR/suggest" ]] || git clone --depth=1 "https://github.com/zsh-users/zsh-autosuggestions.git" "$Z_DIR/suggest" &>/dev/null

# --- 6. THE MASTER .ZSHRC ---
cat << 'EOF' > ~/.zshrc
export TERM="xterm-256color"
export LC_ALL=C.UTF-8

# --- TOTAL SPECTRUM ENGINE (NO WHITE/BLUE) ---
_spectrum_engine() {
    ZSH_HIGHLIGHT_PATTERNS=()
    local words=(${(z)BUFFER})
    for word in $words; do
        local -i sum=0
        for i in {1..${#word}}; do sum+=$(( #word[$i] )); done
        local color=$(( (sum % 190) + 33 ))
        ZSH_HIGHLIGHT_PATTERNS+=("$word" "fg=$color,bold")
    done
}

# Plugins
Z_DIR="$HOME/.zsh-plugins"
source $Z_DIR/suggest/zsh-autosuggestions.zsh
source $Z_DIR/syntax/zsh-syntax-highlighting.zsh

# Overrides
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

# --- CUSTOM COMMANDS ---
# Replace 'YOUR_GITHUB_URL' with your actual raw script link
alias auto-termux='curl -L https://raw.githubusercontent.com/username/repo/main/script.sh | bash'
alias ls='eza --icons=always --group-directories-first --grid'
alias cls='clear'
EOF

# Append Prompt
echo "PROMPT='%F{206}(%F{87}${nickname}%F{206}) %F{214}➜ %F{33}%~ %F{118}$ %f'" >> ~/.zshrc

# Terminal Styling
echo "background: #000000" > ~/.termux/colors.properties
echo "foreground: #ffffff" >> ~/.termux/colors.properties

# --- 7. DEPLOY ---
sync
termux-reload-settings
chsh -s zsh
echo -e "\n${G}SUCCESS! Type 'auto-termux' anytime to rerun this setup.${N}"
sleep 1
exec zsh
