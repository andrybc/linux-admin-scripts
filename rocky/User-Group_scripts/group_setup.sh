#!/bin/bash


#group_setup.sh - creating a group and then adding users to it


LOGFILE="/var/log/group_setup.log"




#checking root

if [ "$EUID" -ne 0]; then
    echo "Please run as root or sudo."
    exit 1
fi


#argument check
if [ "$#" -lt 2]; then
    echo -e "Usage: $0 <groupname> <user1> [user2 ...]"
    exit 2
fi


GROUP="$1"
shift

# Create group if needed
if ! getent group "$GROUP" > /dev/null; then
  groupadd "$GROUP"
  echo "$(date): Created group '$GROUP'" >> "$LOGFILE"
  echo "Group '$GROUP' created."
else
  echo "Group '$GROUP' already exists."
fi

# Loop through users and add them
for USER in "$@"; do
  if id "$USER" &>/dev/null; then
    usermod -aG "$GROUP" "$USER"
    echo "$(date): Added user '$USER' to group '$GROUP'" >> "$LOGFILE"
    echo "Added user '$USER' to '$GROUP'"
  else
    echo "User '$USER' does not exist. Skipping..."
    echo "$(date): Skipped non-existent user '$USER' for group '$GROUP'" >> "$LOGFILE"
  fi
done