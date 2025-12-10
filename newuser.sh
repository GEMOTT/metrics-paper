#!/bin/bash

# Define source and destination paths
SOURCE_DIR="/home/robin/github/gemott/metrics-paper"
DEST_DIR="/home/eugeni/metrics-paper"
USERNAME="eugeni"

# Check if user exists, if not, create it
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists."
else
    echo "User $USERNAME does not exist. Creating user..."
    sudo useradd -m -s /bin/bash "$USERNAME"
    if [ $? -eq 0 ]; then
        echo "User $USERNAME created successfully."
    else
        echo "Error: Failed to create user $USERNAME. Exiting."
        exit 1
    fi
fi

# Ensure the destination parent directory exists
sudo mkdir -p "/home/$USERNAME"

# Copy/sync the directory
echo "Copying/syncing $SOURCE_DIR to $DEST_DIR..."
# Use rsync for robust copying, including hidden files and syncing
# The trailing slash on SOURCE_DIR ensures its *contents* are copied, not the directory itself
sudo rsync -ah --delete "$SOURCE_DIR/" "$DEST_DIR"
if [ $? -eq 0 ]; then
    echo "Directory copied/synced successfully."
    echo "To run this script, use: 'bash newuser.sh'"
else
    echo "Error: Failed to copy/sync directory. Exiting."
    exit 1
fi

# Change ownership to the new user
echo "Setting ownership of $DEST_DIR to $USERNAME..."
sudo chown -R "$USERNAME":"$USERNAME" "$DEST_DIR"
if [ $? -eq 0 ]; then
    echo "Ownership updated successfully."
else
    echo "Error: Failed to change ownership. Exiting."
    exit 1
fi

echo "Setup for user $USERNAME and project copy complete."
