#!/bin/bash

#check if a file was provided as an arg
if [ -z "$1" ]; then
  echo -e "Invalid arguments\nUsage: $0 <file name>"
  exit 1
fi

#set arg to variable username
FILENAME="$1"
LOGFILE="/var/log/user_setup.log"

tail -n +2 "$FILENAME" | while IFS=',' read -r username fullname birthdate groups
do
    echo "Username: $username"
    echo "Full Name: $fullname"
    echo "Birthdate: $birthdate"
    echo "Groups: $groups"
    

    if id "$username" &>/dev/null; then
    echo "User '$username' already exists. Skipping..."
    echo "$(date): Could not create user '$username', username already exists" >> "$LOGFILE"
    continue
    fi


    first_initial="${fullname:0:1}"                           
    second_letter="${fullname:1:1}"                          
    month="${birthdate:5:2}"                                 
    day="${birthdate:8:2}"                                   
    year="${birthdate:0:4}" 

    first_initial="${first_initial^^}"
    second_letter="${second_letter,,}"
    DEFAULT_PW="${first_initial}${second_letter}${month}${day}${year}OH!"
    EXPIRY="2026-12-30"
    
    useradd -m -c "$fullname" "$username"

    echo "$username:$DEFAULT_PW" | chpasswd

    
    cleaned_group=${groups//\"/}


    for grp in $(echo "$cleaned_group" | tr ',' ' '); do
    if ! getent group "$grp" > /dev/null; then
        echo "Group '$grp' does not exist. Skipping.."
    else
        usermod -aG "$grp" "$username"
    fi
    done

    if [ -n "$EXPIRY" ]; then
        chage -E "$EXPIRY" "$username"
    fi


    echo "$(date): Created user '$username', added to '$cleaned_group'" | tee -a "$LOGFILE"

    #set age of pw to where user needs to change pw
    chage -d 0 "$username"

    echo "$(date): User '$username' created with password '$DEFAULT_PW'" >> "$LOGFILE"


    echo "-----------------------------"

done