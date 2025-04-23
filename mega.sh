#!/bin/bash

# Advanced Installer for MEGAcmd + 7-Zip AES-256 on Ubuntu 22.04
# Designed for GitHub Codespaces with MEGA_EMAIL, MEGA_PASSWORD, and ZIP_PASSWORD secrets

MEGA_URL="https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megacmd-xUbuntu_22.04_amd64.deb"
DEB_FILE="megacmd-xUbuntu_22.04_amd64.deb"
LOGFILE="/var/log/megacmd_install.log"

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

# Root check
if [[ $EUID -ne 0 ]]; then
    log "ERROR: This script must be run as root."
    exit 1
fi

# Secret checks
if [[ -z "$MEGA_EMAIL" || -z "$MEGA_PASSWORD" ]]; then
    log "ERROR: MEGA_EMAIL and/or MEGA_PASSWORD environment variables are not set."
    exit 1
fi

if [[ -z "$ZIP_PASSWORD" ]]; then
    log "ERROR: ZIP_PASSWORD environment variable is not set."
    exit 1
fi

log "Starting full setup..."

# Update and upgrade system
log "Updating system packages..."
apt update && apt upgrade -y

# Install wget
if ! command -v wget &>/dev/null; then
    log "Installing wget..."
    apt install -y wget
fi

# Install p7zip (AES-256 support)
if ! command -v 7z &>/dev/null; then
    log "Installing 7-Zip with AES-256 support..."
    apt install -y p7zip-full
else
    log "7-Zip already installed."
fi

# Download MEGAcmd .deb package
log "Downloading MEGAcmd from $MEGA_URL..."
wget -O "$DEB_FILE" "$MEGA_URL"

# Verify download
if [[ ! -f "$DEB_FILE" ]]; then
    log "ERROR: MEGAcmd .deb file not found after download."
    exit 1
fi

# Install MEGAcmd
log "Installing MEGAcmd..."
dpkg -i "$DEB_FILE"
apt install -f -y

# Check MEGAcmd installed
if ! command -v mega-cmd &>/dev/null; then
    log "ERROR: MEGAcmd installation failed."
    exit 1
fi

# Clean up
rm -f "$DEB_FILE"

# MEGA Login
log "Logging into MEGA..."
mega-logout &>/dev/null # just in case
mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD"

if [[ $? -ne 0 ]]; then
    log "ERROR: MEGA login failed. Please check credentials."
    exit 1
fi

log "Successfully logged into MEGA as $MEGA_EMAIL"

# Optional test: create encrypted archive (uncomment to use)
# log "Creating test 7z archive..."
# echo "Secret stuff" > secret.txt
# 7z a -t7z -p"$ZIP_PASSWORD" -mhe=on secret.7z secret.txt
# rm -f secret.txt

log "Setup complete! MEGAcmd and 7-Zip with AES-256 are ready."

# Self-destruct!
rm -- "$0"
