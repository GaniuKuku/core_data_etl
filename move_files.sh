#!/bin/bash

# Define the source and destination folders
SOURCE_DIR="source_folder"
DEST_DIR="json_and_CSV"

# Create the folders (we create the source just for testing purposes)
mkdir -p "$SOURCE_DIR"
mkdir -p "$DEST_DIR"

echo "Moving CSV and JSON files from $SOURCE_DIR to $DEST_DIR..."

# Loop through all .csv and .json files in the source directory
for file in "$SOURCE_DIR"/*.csv "$SOURCE_DIR"/*.json; do
    
    # Check if the file actually exists to prevent errors if the folder is empty
    if [ -e "$file" ]; then
        mv "$file" "$DEST_DIR"/
        echo "Moved: $file"
    fi
done

echo "File move operation complete!"
