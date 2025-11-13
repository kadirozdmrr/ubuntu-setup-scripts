🧰 Ubuntu Setup Scripts

A collection of Bash scripts that help you quickly set up a fresh Ubuntu installation, you can choose which ones to run.

Scripts include help for setting up:

- 🦊 **Firefox (.deb)** version  
- 📦 **Flatpak** with the **Flathub** repository  
- ⚙️ **Popular apps** and developer utilities  
- 🐋 **Docker** & Docker Compose  
- 🧱 **Microsoft SQL Server 2022** inside Docker  
- ☕ **Development tools** (`default-jdk`, `build-essential`, `gdb` for now) 
- 💻 **Terminal configuration tweaks**  

---

⚙️ Requirements

Before running the setup, ensure you have the following basic tools installed:

```bash
sudo apt update && sudo apt install curl wget
```

🚀 Run the Setup

Just run the following one-liner in your terminal:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kadirozdmrr/ubuntu-setup-scripts/main/downloader.sh)
```

