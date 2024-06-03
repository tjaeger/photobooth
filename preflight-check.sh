#!/bin/bash

# Print the full path of the execution directory
full_path=$(pwd)
echo "The script is being executed from: $full_path"

# Source the config.sh file and display its variables
if [ -f "./config.sh" ]; then
    source ./config.sh
    echo "config.sh has been sourced."
    
    # Display the variables from config.sh
    echo "Variables from config.sh:"
    echo "----------------------------------"
    echo "BASE_DIR: $BASE_DIR"
    echo "TARGET_DIR: $TARGET_DIR"
    echo "BACKUP_DIR: $BACKUP_DIR"
    echo "LOG_FILE: $LOG_FILE"
    echo "----------------------------------"
else
    echo "Error: config.sh file not found."
    exit 1
fi

# Check if the script is run from ./photobooth directory
if [ "$(basename "$PWD")" == "photobooth" ]; then
    echo "You are running the script from the ./photobooth directory."
else
    echo "Error: Please run the script from the ./photobooth directory."
    exit 1
fi

# Check if the pictures directory exists within photobooth
if [ -d "./pictures" ]; then
    echo "The 'pictures' directory exists within the 'photobooth' directory."
else
    echo "The 'pictures' directory does not exist within the 'photobooth' directory."
    read -p "Do you want to create the 'pictures' directory? (y/n): " create_dir
    if [ "$create_dir" == "y" ]; then
        mkdir ./pictures
        if [ $? -eq 0 ]; then
            echo "The 'pictures' directory has been created successfully."
        else
            echo "Error: Failed to create the 'pictures' directory."
            exit 1
        fi
    else
        echo "The 'pictures' directory was not created."
        exit 1
    fi
fi

echo "All checks passed!"
