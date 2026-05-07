<p align="center">
  <img src="https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/logo.jpg" width="180" alt="DevSetup Logo">
</p>

<h1 align="center">⚡ DevSetup</h1>

<p align="center">
  Simple setup script for making Termux cleaner, prettier, and more comfortable for daily use.
</p>

---

## ✨ Why I Made This

I use Termux a lot for coding and testing stuff on my phone, but the default setup always felt too plain and boring.

So I started customizing my own terminal little by little:
- better colors
- cleaner prompt
- modern tools
- smoother shell experience

After rebuilding it many times, I decided to turn everything into one simple installer that anyone can use easily.

---

## 🚀 What It Includes

- ZSH setup
- Colorful syntax highlighting
- JetBrains Mono Nerd Font
- Neon-style prompt
- Better `ls` command with icons
- Smart terminal plugins
- Cleaner developer environment

---

## 📦 Installed Packages

- `zsh`
- `eza`
- `zoxide`
- `git`
- `curl`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

---

## ⚠️ Important Notes

> First installation can take a few minutes.

> If something stops during installation, just run the command again.

> Everything is designed to reinstall safely.

---

# 🛠️ Installation

## Step 1 — Update Termux

```bash
pkg update -y && pkg upgrade -y
```

## Step 2 — Run Installer

```bash
curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash
```

---

# 🖥️ After Installation

Your terminal will look something like this:

```bash
(YourName) ➜ ~ $
```

And typing commands will feel much more colorful and modern.

---

# 🧩 Useful Commands

| Command | Description |
|---------|-------------|
| `devsetup` | Reinstall or update setup |
| `ls` | Better file listing |
| `cls` | Clear screen |

---

# 🎛️ Customization

### Change nickname

```bash
devsetup
```

### Edit shell config

```bash
nano ~/.zshrc
```

---

# ❤️ Final Note

This project started as my personal setup, but maybe it can make someone else's Termux experience better too.

If you like it, consider giving the repository a ⭐

---

# 📂 Repository

```bash
PavelAhmmedHridoy/Auto-termux-setup
```</a>
</p>
<p align="center">
<a href="https://github.com/PavelAhmmedHridoy/Auto-termux-setup/stargazers">
<img src="https://img.shields.io/github/stars/PavelAhmmedHridoy/Auto-termux-setup?style=for-the-badge&logo=github&color=FFD700" alt="Stars">
</a>
</p>
## ✨ Features
 * **Dynamic Spectrum Engine** — Live colorful syntax highlighting (every word gets a unique color)
 * **JetBrains Mono Nerd Font** with perfect ligatures
 * **Beautiful neon prompt** with your custom nickname
 * **Modern tools**: eza (better ls), zoxide, zsh
 * **Smart animated progress** during installation
 * **One-command update** system (devsetup)
 * **Clean black theme** with pink/cyan/orange accents
## ⚠️ Important Notes Before Installation
> <span style="color:red">**If the installation crashes or stops** — Don't worry! Just run the command again. Everything will be fixed automatically.</span>
> <span style="color:#FFD700">**This process may take some time** (especially first run) — Please be patient. It will complete successfully.</span>
> 
## Installation
### Step 1: Update Termux
```bash
pkg update -y && pkg upgrade -y

```
### Step 2: Install DevSetup
```bash
curl -L [https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh](https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh) | bash

```
## After Installation
Your new prompt will look like this:
(YourName) ➜ ~ $
With live dynamic rainbow syntax highlighting as you type.
## Useful Commands
| Command | Description |
|---|---|
| devsetup | Update / Reinstall latest version |
| ls | Modern ls with icons and grid |
| cls | Clear screen |
## What's Included
 * **Shell:** Zsh (set as default)
 * **Font:** JetBrains Mono Nerd Font
 * **Plugins:** zsh-autosuggestions + zsh-syntax-highlighting
 * **Dynamic Colors:** Unique color for every word
 * **Tools:** eza, zoxide, git, curl
 * **Theme:** Pure black background + vibrant neon accents
## Customization
 * **Change your nickname:** Run devsetup again
 * **Edit prompt or colors:** nano ~/.zshrc
 * **Reinstall everything:** Just run the installation command again
## Repository
**GitHub:** PavelAhmmedHridoy/Auto-termux-setup
**Made with ❤️ for the Termux Community**
