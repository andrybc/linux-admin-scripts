#!/bin/bash

# user_setup.sh - going to add a user and give them sudo priv
# Usage: sudo ./user_setup.sh <username>


#basic root check
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

#check if a username was provided as an arg
if [ -z "$1" ]; then
  echo -e "Invalid arguments\nUsage: $0 <username>"
  exit 1
fi

#set arg to variable username
USERNAME="$1"

#checking to see if username already exists
if id "$USERNAME" &>/dev/null; then
  echo " User '$USERNAME' already exists."
  exit 1
fi

useradd -m "$USERNAME"

echo "$USERNAME:defaultpw" | chpasswd

usermod -aG wheel "$USERNAME"

LOGFILE="/var/log/user_setup.log"

echo "$(date): Created user '$USERNAME', added to wheel" | tee -a "$LOGFILE"

chage -d 0 "$USERNAME"

echo "User '$USERNAME' created with default password 'defaultpw' that must change next logon."