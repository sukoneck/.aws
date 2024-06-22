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
    echo "🔄 Backing up ${TARGET_DIR} to ${BACKUP_DIR}..."
    mkdir -p "${BACKUP_DIR}"

    # Only backup the files, not subdirectories
    for item in "${TARGET_DIR}"/*; do
        if [ -f "${item}" ]; then
            mv "${item}" "${BACKUP_DIR}"
        fi
    done
}

handle_file_backup

handle_installation() {
    echo "🔄 Downloading and installing..."

    local TEMP_DIR="$( pwd )/awsup"
    mkdir -p "${TEMP_DIR}"
    cat $TEMP_DIR
    ls -lah
    pushd "${TEMP_DIR}" > /dev/null
    ls -lah
    cat $REPO_URL
    git clone "${REPO_URL}" > /dev/null 2>&1
    ls -lah
    ls -lah ./.aws
    cp -r ./.aws/* "${TARGET_DIR}"
    ls -lah "${TARGET_DIR}"
    rm -rf "${TARGET_DIR}"/.git
    ls -lah "${TARGET_DIR}"
    popd > /dev/null
    ls -lah
    rm -rf "${TEMP_DIR}"
    ls -lah
    echo "✅ Installation complete!"

    echo "🔄 Starting setup..."
    # . ${MANAGER_FILE} --setup
}

handle_installation
