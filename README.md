<p align="center">
  <img src="https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/logo.png" width="180" alt="DevSetup Logo">
</p>

<h1 align="center">⚡ DevSetup — Make Termux Feel Modern</h1>

<p align="center">
  Simple setup script for turning normal Termux into a clean and modern developer environment.
</p>

<p align="center">
  <a href="https://github.com/PavelAhmmedHridoy/Auto-termux-setup/stargazers">
    <img src="https://img.shields.io/github/stars/PavelAhmmedHridoy/Auto-termux-setup?style=for-the-badge&logo=github&color=FFD700" alt="Stars">
  </a>

  <a href="https://github.com/PavelAhmmedHridoy/Auto-termux-setup/network/members">
    <img src="https://img.shields.io/github/forks/PavelAhmmedHridoy/Auto-termux-setup?style=for-the-badge&logo=github&color=00CFFF" alt="Forks">
  </a>

  <a href="https://github.com/PavelAhmmedHridoy/Auto-termux-setup/issues">
    <img src="https://img.shields.io/github/issues/PavelAhmmedHridoy/Auto-termux-setup?style=for-the-badge&color=FF4D6D" alt="Issues">
  </a>
</p>

---

# ✨ Features

- 🌈 **Dynamic Spectrum Engine**  
  Live colorful syntax highlighting where every word gets a unique color while typing.

- 🔤 **JetBrains Mono Nerd Font**  
  Clean developer font with icon support and ligatures.

- ⚡ **Beautiful Neon Prompt**  
  Stylish prompt with your custom nickname.

- 🛠️ **Modern Developer Tools**
  - `eza`
  - `zoxide`
  - `zsh`
  - git
  - curl

- 🎨 **Modern UI**
  - Black theme
  - Neon accents
  - Smooth terminal experience

- 🔄 **Easy Updates**
  Update or reinstall anytime using:
  
```bash
devsetup
```

---

# ⚠️ Important Notes

> If the installation stops or crashes, simply run the command again.

> First installation may take a few minutes depending on internet speed.

> Everything is designed to reinstall safely without breaking your setup.

---

# 🚀 Installation

## Step 1 — Update Termux

```bash
pkg update -y && pkg upgrade -y
```

## Step 2 — Install DevSetup

```bash
curl -L https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/setup.sh | bash
```

---

# 🖥️ After Installation

Your terminal prompt will look something like this:

```bash
(YourName) ➜ ~ $
```

You’ll also get:
- colorful typing effects
- better file listing
- icon support
- cleaner shell experience

---

# 📦 Included Packages

| Category | Included |
|----------|----------|
| Shell | ZSH |
| Font | JetBrains Mono Nerd Font |
| Plugins | zsh-autosuggestions, zsh-syntax-highlighting |
| Tools | eza, zoxide, git, curl |

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

# ❤️ About This Project

This project originally started as my personal Termux setup.

After rebuilding and improving it many times, I decided to make it easier for other people to use too.

If you enjoy the project, consider giving it a ⭐

---

# 📂 Repository

```bash
PavelAhmmedHridoy/Auto-termux-setup
```
