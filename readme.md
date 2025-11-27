# 🌐 Rubinho Env

This repository contains **all my development environment configurations**, including:

- configuration files (dotfiles)
- Cursor/VS Code presets
- themes and fonts
- automated scripts
- auxiliary tools
- utilities for environment setup, backup and restoration

The goal is to facilitate the installation and standardization of my environment on any Linux machine.

---

## 📦 Installation Scripts

All scripts are organized in numerical order to facilitate sequential installation. **Run the scripts in the correct order (01 → 02 → 03 → ... → 15).**

### 🚀 Quick Installation (From Scratch)

If you just formatted your system or are starting from scratch:

**First, clone the repository:**
```bash
git clone https://github.com/rubensdeoliveira/rubinho-env.git
cd rubinho-env/linux/scripts
```

Then you have two options:

#### Option 1: Automatic Script (Recommended)

```bash
# Run the master script (it pauses when necessary)
bash 00-install-all.sh

# After closing/opening the terminal, continue with:
bash 00-install-all-continue.sh
```

#### Option 2: Individual Scripts

```bash
# Run the scripts in sequence
bash 01-configure-git.sh
bash 02-install-zsh.sh
# ⚠️ Close and reopen the terminal after script 02

bash 03-install-prezto.sh
bash 04-install-starship.sh
bash 05-install-docker.sh
# ⚠️ Logout/login after script 05 to use Docker without sudo

bash 06-install-node-nvm.sh
bash 07-install-yarn.sh
bash 08-install-font-jetbrains.sh
bash 09-install-cursor.sh
bash 10-configure-keyboard.sh
bash 11-configure-terminal.sh
bash 12-configure-ssh.sh
bash 13-configure-inotify.sh
bash 14-install-cursor-extensions.sh
bash 15-configure-cursor.sh
```

---

## 📋 Complete Script Listing

### **00-install-all.sh** (Master Script)
Runs all installation scripts in sequence.
- Pauses after script 02 for you to close/open the terminal
- Pauses after script 05 for you to logout/login
- Use `00-install-all-continue.sh` to continue after the pauses

---

## Individual Scripts

### **01-configure-git.sh**
Configures Git with identity and preferences.
- Configures name and email
- Sets default branch to `main`
- Enables colors in Git

**Note:** Git must already be installed (required to clone the repository).

---

### **02-install-zsh.sh**
Installs and configures Zsh as the default shell.
- Installs Zsh, Curl and Git
- Sets Zsh as the default shell
- Creates minimal `.zshrc`
- Adds auxiliary configurations

**⚠️ After running:** Close and reopen the terminal.

---

### **03-install-prezto.sh**
Installs Prezto (framework for Zsh).
- Clones the Prezto repository
- Creates symlinks for configuration files
- Configures Prezto modules

---

### **04-install-starship.sh**
Installs and configures the Starship prompt.
- Installs Starship
- Copies and configures `starship.toml`
- Updates `.zshrc` with Prezto + Starship

**👉 After running:** Run `source ~/.zshrc`

---

### **05-install-docker.sh**
Installs Docker and Docker Compose.
- Removes old Docker installations
- Adds official Docker repository
- Installs Docker Engine, Docker Compose and plugins
- Adds user to docker group

**⚠️ After running:** Logout/login to use Docker without sudo.

---

### **06-install-node-nvm.sh**
Installs NVM (Node Version Manager) and Node.js.
- Installs NVM
- Installs Node.js version 22
- Sets Node 22 as default

---

### **07-install-yarn.sh**
Installs Yarn via Corepack.
- Enables Corepack
- Installs and activates Yarn 1

---

### **08-install-font-jetbrains.sh**
Installs JetBrains Mono Nerd Font.
- Downloads the font from the official repository
- Installs in user fonts directory
- Updates font cache

---

### **09-install-cursor.sh**
Installs Cursor Editor.
- Downloads Cursor .deb package
- Installs via dpkg
- Verifies installation

---

### **10-configure-keyboard.sh**
Configures keyboard for US International.
- Sets US International layout
- Enables cedilla (ç) support
- Configures keyboard options

---

### **11-configure-terminal.sh**
Configures GNOME Terminal with Dracula theme.
- Installs dconf-cli
- Creates "rubinho" profile in GNOME Terminal
- Applies Dracula theme
- Configures JetBrains Mono Nerd Font
- Removes old profiles

---

### **12-configure-ssh.sh**
Configures SSH for Git.
- Installs Git and OpenSSH
- Generates ed25519 SSH key
- Configures SSH agent
- Sets correct permissions
- Copies public key to clipboard

**👉 After running:** Add the SSH key to GitHub/GitLab.

---

### **13-configure-inotify.sh**
Configures inotify limits for file watching.
- Increases `max_user_watches` to 524288
- Makes the configuration persistent
- Applies changes

---

### **14-install-cursor-extensions.sh**
Installs essential Cursor extensions.
- Color Highlight
- DotENV
- ESLint
- GitLens
- Markdown Preview Enhanced
- Prisma
- px to rem
- Reload
- Tailwind CSS IntelliSense
- Indent Rainbow
- Symbols (icons)
- Catppuccin (theme)

---

### **15-configure-cursor.sh**
Applies Cursor configurations.
- Copies `settings.json` to Cursor
- Copies `keybindings.json` to Cursor
- Configures theme and preferences

**👉 After running:** Open Cursor again to apply everything.

---

## 📁 Repository Structure

```
rubinho-env/
├── linux/
│   ├── config/              # Configuration files
│   │   ├── starship.toml   # Starship prompt configuration
│   │   ├── user-settings.json  # Cursor settings
│   │   ├── cursor-keyboard.json  # Cursor keyboard shortcuts
│   │   └── zsh-config      # Additional Zsh configurations
│   └── scripts/             # Installation scripts (01-15)
├── mac/                     # macOS configurations (future)
└── readme.md               # This file
```

---

## 🛠 Maintenance

To modify scripts, update tools or version environment adjustments, just edit the corresponding files and push the changes.

---

## 📝 Important Notes

- **Prerequisites:** Git must be installed to clone the repository
- **Execution order:** Scripts must be run in numerical order (01 → 15)
- **Required restarts:**
  - After script 02: Close and reopen the terminal
  - After script 05: Logout/login to use Docker without sudo
- **Dependencies:** Some scripts depend on others (e.g., Yarn needs Node installed)
- **Custom configurations:** Edit files in `linux/config/` before running the scripts
