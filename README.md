🧰 Ubuntu (24.04 LTS recommended) Setup Scripts

A collection of Bash scripts that help you quickly set up a fresh Ubuntu installation, you can choose which ones to run.

Scripts include help for setting up:

- 🦊 **Firefox (.deb)** version  
- 📦 **Flatpak** with the **Flathub** repository  
- ⚙️ **Popular apps** and developer utilities  
- 🐋 **Docker** & Docker Compose  
- 🧱 **Microsoft SQL Server 2022** inside Docker  
- ☕ **Development tools** (`default-jdk`, `build-essential`, `gdb` for now) 
- 💻 **Terminal configuration tweaks**
- 🆕 **Update the System Including External .deb Packages (Zoom, Discord, Heroic Games Launcher, Minecraft Launcher)**  

---

⚙️ Requirements

Before running the downloader, ensure you have the following basic tools installed:

```bash
sudo apt update && sudo apt install curl wget
```

🚀 Install the Scripts:

Just run the following one-liner in your terminal:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kadirozdmrr/ubuntu-setup-scripts/main/downloader.sh)
```
This will install scripts to .ubuntu-setup-scripts in your home folder and automatically launch the master setup menu. Afterwards you can manually launch main.sh to use master setup menu again which also includes an option for updating the scripts.

