#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# 🚀 Antigravity CLI - Termux Automated Installer
# Maintained by OddBoyXD (https://github.com/OddBoyXD)
# ==========================================================
set -e

# --- Color Definitions ---
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
PURPLE="\033[1;35m"
RED="\033[1;31m"
BOLD="\033[1m"
RESET="\033[0m"

# --- Clear & Banner ---
clear
echo -e "${CYAN}"
cat << "BANNER"
  ____            _   _                           _ _         
 / ___| ___   ___| | | | ___ _ __ ___   ___  __ _| (_) __ _   
| |  _ / _ \ / _ \ |_| |/ _ \ '_ ` _ \ / _ \/ _` | | |/ _` |  
| |_| | (_) |  __/  _  |  __/ | | | | |  __/ (_| | | | (_| |  
 \____|\___/ \___|_| |_|\___|_| |_| |_|\___|\__,_|_|_|\__,_|  
       ⚡ Antigravity CLI Installer for Termux Android ⚡      
BANNER
echo -e "${RESET}"

# --- System Diagnostic Check ---
ARCH=$(uname -m)
FREE_MEM=$(free -h 2>/dev/null | awk '/^Mem:/ {print $7}' || echo "Unknown")
FREE_SPACE=$(df -h $PREFIX 2>/dev/null | awk 'NR==2 {print $4}' || echo "Unknown")

echo -e "${PURPLE}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${PURPLE}║${RESET} ${BOLD}📱 Device Architecture :${RESET} ${GREEN}${ARCH}${RESET}"
echo -e "${PURPLE}║${RESET} ${BOLD}🧠 Available Memory    :${RESET} ${GREEN}${FREE_MEM}${RESET}"
echo -e "${PURPLE}║${RESET} ${BOLD}💾 Available Storage   :${RESET} ${GREEN}${FREE_SPACE}${RESET}"
echo -e "${PURPLE}║${RESET} ${BOLD}📦 Space Required      :${RESET} ${YELLOW}~800 MB (glibc + tools + Engine)${RESET}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

# --- User Confirmation Prompt ---
echo -e "${YELLOW}⚠️  This installer will update packages and install the Antigravity AI Engine.${RESET}"
read -p "$(echo -e "${CYAN}👉 Do you want to proceed with the installation? (y/N): ${RESET}")" CONFIRM

case "$CONFIRM" in
    [yY][eE][sS]|[yY]) 
        echo -e "\n${GREEN}🚀 Starting installation...${RESET}\n"
        ;;
    *)
        echo -e "\n${RED}❌ Installation cancelled by user. No changes were made.${RESET}\n"
        exit 0
        ;;
esac

# --- Step 1: Storage Permission ---
echo -e "${CYAN}=== [1/6] 📁 Setting Up Storage Access ===${RESET}"
if [ ! -d "$HOME/storage" ]; then
    echo -e "${YELLOW}Please tap 'ALLOW' on the storage permission popup if prompted...${RESET}"
    termux-setup-storage || true
    sleep 2
else
    echo -e "${GREEN}✓ Storage access already configured.${RESET}"
fi

# --- Step 2: Configure Fast Cloudflare Mirrors ---
echo -e "\n${CYAN}=== [2/6] ⚡ Configuring High-Speed Package Mirrors ===${RESET}"
sed -i 's@^\(deb.*games\)@# \1@' $PREFIX/etc/apt/sources.list 2>/dev/null || true
sed -i 's@^\(deb.*science\)@# \1@' $PREFIX/etc/apt/sources.list 2>/dev/null || true
echo "deb https://packages-cf.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list
echo -e "${GREEN}✓ Cloudflare mirrors active.${RESET}"

# --- Step 3: Update & Upgrade System ---
echo -e "\n${CYAN}=== [3/6] 🔄 Updating System Packages ===${RESET}"
export DEBIAN_FRONTEND=noninteractive
pkg update -y -o Dpkg::Options::="--force-confnew"
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
echo -e "${GREEN}✓ System packages up to date.${RESET}"

# --- Step 4: Install Essential Tooling ---
echo -e "\n${CYAN}=== [4/6] 🛠️  Installing Essential Tools (curl, git, certificates) ===${RESET}"
pkg install -y -o Dpkg::Options::="--force-confnew" curl git ca-certificates
echo -e "${GREEN}✓ Core tools installed.${RESET}"

# --- Step 5: Install glibc Compatibility Layer ---
echo -e "\n${CYAN}=== [5/6] 🐧 Setting Up GNU glibc Runtime Layer ===${RESET}"
pkg install -y -o Dpkg::Options::="--force-confnew" glibc-repo
pkg update -y -o Dpkg::Options::="--force-confnew"
pkg install -y -o Dpkg::Options::="--force-confnew" glibc
echo -e "${GREEN}✓ glibc runtime successfully configured.${RESET}"

# --- Step 6: Install Google Antigravity CLI ---
echo -e "\n${CYAN}=== [6/6] 🤖 Installing Google Antigravity AI Engine ===${RESET}"
curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash

# Clean up any leftover temporary files to save phone storage
rm -f $PREFIX/tmp/antigravity-*.tar.gz 2>/dev/null || true

# --- Final Success Summary ---
echo -e "\n${GREEN}"
cat << "SUCCESS"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║       🎉  ANTIGRAVITY CLI INSTALLED SUCCESSFULLY!  🎉      ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
SUCCESS
echo -e "${RESET}"
echo -e "${BOLD}To start coding with Antigravity, simply run:${RESET}"
echo -e "${GREEN}${BOLD}   agy${RESET}\n"
