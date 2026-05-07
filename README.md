<p align="center">
<img src="https://raw.githubusercontent.com/PavelAhmmedHridoy/Auto-termux-setup/main/logo.jpg" alt="DevSetup Logo" width="580">
</p>
<p align="center">
<strong>DevSetup — Beautiful & Powerful Termux Setup</strong>

<em>One command. Instant beauty. Lifetime productivity.</em>
</p>
<p align="center">
<a href="https://github.com/PavelAhmmedHridoy/Auto-termux-setup">
<img src="https://img.shields.io/badge/Version-v30.0-9F4BFF?style=for-the-badge" alt="Version">
</a>
<a href="https://github.com/PavelAhmmedHridoy/Auto-termux-setup/blob/main/LICENSE">
<img src="https://img.shields.io/badge/License-MIT-9F4BFF?style=for-the-badge" alt="License">
</a>
<a href="https://termux.dev/">
<img src="https://img.shields.io/badge/Platform-Termux%20%7C%20Android-00FFAA?style=for-the-badge&logo=android" alt="Platform">
</a>
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
