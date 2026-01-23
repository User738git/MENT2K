#!/bin/bash

# Log file for debugging
LOG_FILE="$HOME/.startup-marco-picom.log"

# Function to log messages
log_message() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Start Marco
log_message "Starting Marco"
marco --replace --no-composite &
if [ $? -ne 0 ]; then
    log_message "Failed to start Marco"
    exit 1
fi

# Wait for a short period to ensure Marco starts properly
sleep 0.8

# Kill any existing Picom instances
log_message "Killing any existing Picom instances"
pkill picom

# Start Picom
log_message "Starting Picom"
picom --config ~/.config/picom.conf &
if [ $? -ne 0 ]; then
    log_message "Failed to start Picom"
    exit 1
fi

log_message "Both Marco and Picom started successfully"
