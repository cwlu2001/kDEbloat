#!/bin/bash

# Define the filenames
file=debloat.txt

# Initialize an array to hold the packages
packages=()

# Read package names from each file
if [[ -f "$file" ]]; then
    mapfile -t file_packages < "$file"
    packages+=("${file_packages[@]}")
else
    echo "File $file not found."
fi


# Check if there are any packages to uninstall
if [ ${#packages[@]} -eq 0 ]; then
    echo "No packages to remove."
    exit 0
fi

# Print the packages to be removed for debugging
echo "Removing the following packages: ${packages[*]}"

# Attempt to remove each package individually
for package in "${packages[@]}"; do
    echo "Trying to remove package: $package"
    sudo apt remove -qq --simulate "$package"
done
