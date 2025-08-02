#!/bin/bash

read -p "Enter new username: " USERNAME
read -s -p "Enter temporary password: " DEFAULT_PW
echo
read -p "Enter additional groups (comma-separated): " GROUP_LIST

echo $GROUP_LIST
# Wrap all variables in quotes to preserve spaces/commas
sudo ./user_setup_core.sh "$USERNAME" "$DEFAULT_PW" "$GROUP_LIST"
