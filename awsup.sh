#!/usr/bin/env bash
#
# https://github.com/0x416e746f6e/.aws
#
#

set -eo pipefail
echo "🆙 Starting awsup..."

# Set the target directory
TARGET_DIR="${HOME}/.aws"
REPO_URL="https://github.com/sukoneck/.aws.git"
# REPO_URL="https://github.com/0x416e746f6e/.aws.git"

# Check if the config or credentials files already exist
CONFIG_FILE="${TARGET_DIR}/config"
CREDENTIALS_FILE="${TARGET_DIR}/credentials"
MANAGER_FILE="${TARGET_DIR}/manager.sh"

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
        if [ -f "${item}" ]; then
            mv "${TARGET_DIR}/${item}" "${BACKUP_DIR}"
        fi
    done
}

handle_file_backup

handle_installation() {
    local TEMP_DIR="awsup"
    mkdir -p "${TEMP_DIR}"
    pushd "${TEMP_DIR}" > /dev/null

    echo "🔄 Cloning the repository..."
    git clone "${REPO_URL}" > /dev/null 2>&1
    cp -r .aws/* "${TARGET_DIR}"
    rm -rf "${TARGET_DIR}"/.git

    popd > /dev/null
    rm -rf "${TEMP_DIR}"

    echo "✅ Installation complete!"

    echo "🔄 Starting setup..."
    . ${MANAGER_FILE} --setup
}

handle_installation
