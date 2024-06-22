#!/usr/bin/env bash
#
# https://github.com/0x416e746f6e/.aws
#
#

set -eo pipefail
echo "🆙 Starting awsup..."

# Set the target directory
TARGET_DIR="${HOME}/.aws"
REPO_URL="https://github.com/0x416e746f6e/.aws.git"

# Check if the config or credentials files already exist
CONFIG_FILE="${TARGET_DIR}/config"
CREDENTIALS_FILE="${TARGET_DIR}/credentials"
LOGIN_FILE="${TARGET_DIR}/login.sh"

# Get the current date for the backup folder
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="${TARGET_DIR}/backup-${DATE}"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "🚫 Git is not installed. Please install Git and try again."
    exit 1
fi

# Backup the existing .aws directory
handle_file_backup() {
    mkdir -p "${BACKUP_DIR}"
    echo "🔄 Backing up ${TARGET_DIR} to ${BACKUP_DIR}..."

    # Only backup the files, not subdirectories
    for item in "${TARGET_DIR}"/*; do
        if [ -f "$item" ]; then
            mv -v "$item" "${BACKUP_DIR}"
        fi
    done
    echo "✅ ${TARGET_DIR} has been backed up to ${BACKUP_DIR}."
}

handle_file_backup

handle_installation() {
    # Clone the repository
    echo "🔄 Cloning the repository..."
    git clone "${REPO_URL}" "${TARGET_DIR}"
    rm -rf ~/.aws/.git

    echo "✅ Installation complete!"

    echo "🔄 Starting setup..."
    . ${LOGIN_FILE} --setup
}

handle_installation
