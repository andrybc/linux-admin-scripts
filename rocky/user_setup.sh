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
DEFAULT_PW="defaultpw"



#prompt for password and a list of groups the user needs to be added to
read -s -p "Enter temporary password for '$USERNAME': " DEFAULT_PW
echo

read -p "Add '$USERNAME' to additional groups (comma-separated)? " GROUP_LIST

#run add user and encrypt pw
useradd -m -g users "$USERNAME"

echo "$USERNAME:$DEFAULT_PW" | chpasswd

#call usermod with the string group_list

# if [ -n "$GROUP_LIST" ]; then
#   usermod -aG "$GROUP_LIST" "$USERNAME"
# fi

#usermod -aG wheel "$USERNAME"
for grp in $(echo "$GROUP_LIST" | tr ',' ' '); do
  if ! getent group "$grp" > /dev/null; then
    echo "Group '$grp' does not exist. Skipping.."
  else
    usermod -aG "$grp" "$USERNAME"
  fi
done

#log and echo on to screen the final result
LOGFILE="/var/log/user_setup.log"

echo "$(date): Created user '$USERNAME', added to '$GROUP_LIST'" | tee -a "$LOGFILE"

#set age of pw to where user needs to change pw
chage -d 0 "$USERNAME"

echo "User '$USERNAME' created with default password that must change next logon."

