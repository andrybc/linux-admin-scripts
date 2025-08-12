#!/bin/bash

# delete_user.sh - kills a user's processes and then deletes user.
# Usage: sudo ./delete_user.sh <username>

#  makes sure running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Require usernames argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <user1> [user2 user3 ...]"
  exit 1
fi

delete_user () {


    local USERNAME="$1"
    LOGFILE="/var/log/user_deletion.log"

    # Check if user exists
    if ! id "$USERNAME" &>/dev/null; then
      echo "User '$USERNAME' does not exist. Skipping..."
      return 1
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
      return 1
    fi 
}


#loop through all the arguments

RC=0

for i in "$@"; do
  delete_user "$i" || RC=1
done


exit "$RC"