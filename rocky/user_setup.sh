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
