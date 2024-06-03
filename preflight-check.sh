#!/bin/bash

# Function to check if a directory exists
check_directory() {
    local dir_path=$1
    local dir_name=$2

    if [ ! -d "$dir_path" ]; then
        echo "WARNING: $dir_name directory $dir_path does not exist."
    else
        echo "SUCCESS: $dir_name directory $dir_path exists."
    fi
}

# Print the full path of the execution directory
full_path=$(pwd)
echo "INFO: The script is being executed from: $full_path"
# Check if the script is run from ./photobooth directory
if [ "$(basename "$PWD")" == "photobooth" ]; then
    echo "SUCCESS: You are running the script from the ./photobooth directory."
else
    echo "ERROR: Please run the script from the ./photobooth directory."
    exit 1
fi

# Source the config.sh file and display its variables
if [ -f "./config.sh" ]; then
    source ./config.sh
    echo "SUCCESS: config.sh has been sourced."
    
    # Display the variables from config.sh
    echo "Variables from config.sh:"
    echo "----------------------------------"
    echo "BASE_DIR: $BASE_DIR"
    echo "TARGET_DIR: $TARGET_DIR"
    echo "BACKUP_DIR: $BACKUP_DIR"
    echo "LOG_FILE: $LOG_FILE"
    echo "----------------------------------"
else
    echo "ERROR: config.sh file not found."
    exit 1
fi

# Check if the pictures directory exists within photobooth
if [ -d "./pictures" ]; then
    echo "SUCCESS: The 'pictures' directory exists within the 'photobooth' directory."
else
    echo "WARNING: The 'pictures' directory does not exist within the 'photobooth' directory."
    read -p "Do you want to create the 'pictures' directory? (y/n): " create_dir
    if [ "$create_dir" == "y" ]; then
        mkdir ./pictures
        if [ $? -eq 0 ]; then
            echo "SUCCESS: The 'pictures' directory has been created successfully."
        else
            echo "ERROR: Failed to create the 'pictures' directory."
            exit 1
        fi
    else
        echo "WARNING: The 'pictures' directory was not created."
        # exit 1
    fi
fi

# Check if BACKUP_DIR and TARGET_DIR exist
check_directory "$BACKUP_DIR" "Backup"
check_directory "$TARGET_DIR" "Target"

echo "End Preflight check."
