#!/bin/bash

USERNAME="$1"
DEFAULT_PW="$2"
GROUP_LIST="$3"

if [ "$EUID" -ne 0 ]; then
  echo " Must be run as root."
  exit 1
fi

if id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' already exists."
  exit 1
fi

useradd -m "$USERNAME"
echo "$USERNAME:$DEFAULT_PW" | chpasswd

if [ -n "$GROUP_LIST" ]; then
  usermod -aG "$GROUP_LIST" "$USERNAME"
fi

chage -d 0 "$USERNAME"

LOGFILE="/var/log/user_setup.log"
echo "$(date): Created user '$USERNAME', added to $GROUP_LIST" | tee -a "$LOGFILE"

echo "User '$USERNAME' created and must change password at next login."
