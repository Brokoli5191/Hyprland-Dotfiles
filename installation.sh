#!/bin/bash

# Set colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

# Repository URL
REPO_URL="https://github.com/Brokoli5191/Hyprland-Dotfiles"

# Determine a unique directory name for cloning
BASE_DIR="$HOME/Hyprland-Dotfiles"
DATE_SUFFIX=$(date +%Y%m%d)
if [[ -d "$BASE_DIR" ]]; then
    REPO_DIR="${BASE_DIR}-${DATE_SUFFIX}"
else
    REPO_DIR="$BASE_DIR"
fi

# Backup paths
BACKUP_DIR="$HOME/backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_SRC="$REPO_DIR/config"
LOCAL_SRC="$REPO_DIR/local"

# Clone the repository
echo -e "${GREEN}Cloning the repository...${NC}"
git clone "$REPO_URL" "$REPO_DIR" || { echo -e "${RED}Failed to clone the repository.${NC}" ; exit 1; }

# Backup option
read -p "Do you want to create a backup of .config and .local? (y/n): " backup_choice
if [[ "$backup_choice" == "y" ]]; then
    echo -e "${GREEN}Creating backup at $BACKUP_DIR...${NC}"
    mkdir -p "$BACKUP_DIR"
    cp -r "$HOME/.config" "$BACKUP_DIR" || echo -e "${RED}Failed to back up .config.${NC}"
else
    echo -e "${GREEN}Backup skipped.${NC}"
fi

# Check for pacman
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}pacman is not installed. Aborting the script.${NC}"
    exit 1
fi

# Install dependencies
DEPENDENCY_FILE="$REPO_DIR/dependency.conf"
if [[ -f "$DEPENDENCY_FILE" ]]; then
    echo -e "${GREEN}Installing packages from dependency.conf...${NC}"
    while read -r package; do
        if [[ ! -z "$package" && ! "$package" =~ ^# ]]; then
            sudo pacman -S --noconfirm "$package" || echo -e "${RED}Failed to install $package.${NC}"
        fi
    done < "$DEPENDENCY_FILE"
else
    echo -e "${RED}dependency.conf not found.${NC}"
fi

# Copy configuration files
echo -e "${GREEN}Copying configuration files...${NC}"
mkdir -p "$HOME/.config"
cp -r "$CONFIG_SRC"/* "$HOME/.config/" || echo -e "${RED}Failed to copy files to .config.${NC}"

# Set wallpaper
WALLPAPER="$REPO_DIR/wallpaper.png"
if [[ -f "$WALLPAPER" ]]; then
    echo -e "${GREEN}Setting wallpaper...${NC}"
    swaybg -i "$WALLPAPER" -m fill &  # Run swaybg in the background
    disown  # Detach swaybg from the script
    echo -e "${GREEN}Copying wallpaper to Downloads folder...${NC}"
    cp "$WALLPAPER" "$HOME/Downloads/" || echo -e "${RED}Failed to copy wallpaper.${NC}"
else
    echo -e "${RED}wallpaper.png not found.${NC}"
fi

echo -e "${GREEN}Done!${NC}"
