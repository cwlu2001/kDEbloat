#!/bin/bash

# Function to read package names from a file
read_packages() {
    local file="$1"
    local -n pkg_list="$2"
    if [[ -f "$file" ]]; then
        while IFS= read -r line; do
            # Skip comments and blank lines
            [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
            pkg_list+=("$line")
        done < "$file"
    else
        echo "File $file not found."
        return 1
    fi
}

# Define filenames
debloat_file="debloat.txt"
post_file="post_install.txt"

# Initialize arrays for packages
debloat_packages=()
read_packages "$debloat_file" debloat_packages

for package in "${debloat_packages[@]}"; do
    echo "====> Remove package: $package"
    if ! sudo apt purge -qqy "$package"; then
        echo "Failed to remove $package" >&2
    fi
done

# Clean up unneeded dependencies
echo "Cleaning up unneeded dependencies..."
sudo apt autoremove -qqy

# Initialize arrays for packages
post_packages=()
read_packages "$post_file" post_packages

# Install post-install packages
for package in "${post_packages[@]}"; do
    echo "====> Install package: $package"
    if ! sudo apt install -qqy "$package"; then
        echo "Failed to install $package" >&2
    fi
done
