#!/bin/bash

USERNAME="$USER"
PROFILE_PIC_PATH="/home/$USERNAME/Pictures/profile.png"
ACCOUNTS_SERVICE_PATH="/var/lib/AccountsService/icons/$USERNAME"

# Set the user profile picture
sudo dbus-send --system --print-reply --dest=org.freedesktop.Accounts \
    /org/freedesktop/Accounts/User$(id -u $USERNAME) \
    org.freedesktop.Accounts.User.SetIconFile \
    string:"$PROFILE_PIC_PATH"

# Wait a bit to ensure the profile picture is copied
sleep 1

# Check if the destination file exists
if [ -f "$ACCOUNTS_SERVICE_PATH" ]; then
    # Calculate checksums
    ORIGINAL_CHECKSUM=$(sha256sum "$PROFILE_PIC_PATH" | awk '{ print $1 }')
    COPIED_CHECKSUM=$(sudo sha256sum "$ACCOUNTS_SERVICE_PATH" | awk '{ print $1 }')

    # Print debug information
    echo "Original checksum: $ORIGINAL_CHECKSUM"
    echo "Copied checksum: $COPIED_CHECKSUM"

    # Compare the checksums
    if [ "$ORIGINAL_CHECKSUM" == "$COPIED_CHECKSUM" ]; then
        echo "Profile picture set successfully for user $USERNAME."
    else
        echo "Failed to set profile picture for user $USERNAME. Checksums do not match."
    fi
else
    echo "Failed to set profile picture for user $USERNAME. Destination file not found."
fi

