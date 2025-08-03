#!/bin/bash

# delete_user.sh - kills a user's processes and then deletes user.
# Usage: sudo ./delete_user.sh <username>

#  makes sure running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Require username argument
if [ -z "$1" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

USERNAME="$1"
LOGFILE="/var/log/user_deletion.log"

# Check if user exists
if ! id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' does not exist."
  exit 1
fi

# kills all processes owned by user or currently running
echo "Killing processes for '$USERNAME'..."
pkill -9 -u "$USERNAME"

# deletes the user and their home directory
echo "🧹 Deleting user '$USERNAME' and their home directory..."
if userdel -r "$USERNAME"; then
  echo "User '$USERNAME' deleted."
  echo "$(date): Deleted user '$USERNAME'" | tee -a "$LOGFILE"
else
  echo "Failed to delete user '$USERNAME'."
  exit 1
fi
