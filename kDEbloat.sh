#!/bin/bash

# Function to read package from file
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

debloat_file="debloat.txt"
post_file="post_install.txt"

# Initialize arrays for packages
debloat_packages=()
read_packages "$debloat_file" debloat_packages

# Remove packages
for package in "${debloat_packages[@]}"; do
    echo -e "\n====> Remove package: $package"
    sudo apt-get purge -qq --autoremove "$package"
done

# Initialize arrays for packages
post_packages=()
read_packages "$post_file" post_packages

# Install packages
for package in "${post_packages[@]}"; do
    echo -e "\n====> Install package: $package"
    sudo apt-get install -qq "$package"
done
