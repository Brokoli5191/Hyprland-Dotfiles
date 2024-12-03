#!/bin/bash

# Set colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

# Backup directory (make sure this matches your backup folder name or path)
BACKUP_DIR="$HOME/backup"  # Hier das Verzeichnis anpassen, in dem das Backup gespeichert ist

# Restore configuration files
echo -e "${GREEN}Restoring configuration files from backup...${NC}"

# Check if backup exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo -e "${RED}Backup directory $BACKUP_DIR does not exist. Aborting the restore process.${NC}"
    exit 1
fi

# Restore .config
if [[ -d "$BACKUP_DIR/.config" ]]; then
    echo -e "${GREEN}Restoring .config...${NC}"
    cp -r "$BACKUP_DIR/.config" "$HOME/" || echo -e "${RED}Failed to restore .config.${NC}"
else
    echo -e "${RED}.config backup not found.${NC}"
fi

# Restore .local
if [[ -d "$BACKUP_DIR/.local" ]]; then
    echo -e "${GREEN}Restoring .local...${NC}"
    cp -r "$BACKUP_DIR/.local" "$HOME/" || echo -e "${RED}Failed to restore .local.${NC}"
else
    echo -e "${RED}.local backup not found.${NC}"
fi

# Success message
echo -e "${GREEN}Configuration restoration complete.${NC}"
