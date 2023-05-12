#!/bin/bash

# Check if VBoxClient is running
if pgrep -x "VBoxClient" > /dev/null; then
  echo "VBoxClient is running. Killing VBoxClient..."
  killall VBoxClient
else
  echo "VBoxClient is not running."
fi

# Start VBoxClient
echo "Starting VBoxClient..."
VBoxClient-all
