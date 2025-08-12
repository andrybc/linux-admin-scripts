#!/bin/bash

#check if a file was provided as an arg
if [ $# -ne 2 ]; then
  echo "Usage: $0 <groupname> <userlist.csv>"
  exit 1
fi

#set group and file from arguments
GROUP="$1"
FILENAME="$2"
LOGFILE="/var/log/group_setup.log"

# Create group if needed
if ! getent group "$GROUP" > /dev/null; then
  groupadd "$GROUP"
  echo "$(date): Created group '$GROUP'" >> "$LOGFILE"
  echo "Group '$GROUP' created."
else
  echo "Group '$GROUP' already exists."
fi

tail -n +2 "$FILENAME" | while IFS=',' read -r username _ _ _
do
    echo "Username: $username"

    if id "$username" &>/dev/null; then
      usermod -aG "$GROUP" "$username"
      echo "$(date): Added user '$username' to group '$GROUP'" >> "$LOGFILE"
      echo "Added user '$username' to '$GROUP'"
    else
      echo "User '$username' does not exist. Skipping..."
      echo "$(date): Skipped non-existent user '$username' for group '$GROUP'" >> "$LOGFILE"
    fi
done