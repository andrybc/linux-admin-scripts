#!/bin/bash

#check if a file was provided as an arg
if [ -z "$1" ]; then
  echo -e "Invalid arguments\nUsage: $0 <file name>"
  exit 1
fi

#set arg to variable username
FILENAME="$1"
LOGFILE="/var/log/user_setup.log"

tail -n +2 "$FILENAME" | while IFS=',' read -r username
do
    echo "Username: $username"