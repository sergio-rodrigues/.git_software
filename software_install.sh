#!/bin/bash

# Check if SOFTWARE_PATH, SOFTWARE_LIST_FILE, and ALIAS_FILE variables are empty
if [ -z "${SOFTWARE_PATH}" ] || [ -z "${SOFTWARE_LIST_FILE}" ] || [ -z "${ALIAS_FILE}" ]; then
    . "$(dirname "$0")/.env"
	if [ -z "${SOFTWARE_PATH}" ] || [ -z "${SOFTWARE_LIST_FILE}" ] || [ -z "${ALIAS_FILE}" ]; then
	    # If any of them is empty, exit
	    exit
    fi
fi

# Function to download and update software
install_software() {
    # Loop through each line in the software list file
    while IFS='|' read -r name url path; do
        # Skip lines starting with #
        case $name in
            \#*) continue ;;
        esac
        # Remove line endings from path
        path=$(echo "${path}" | tr -d '\r')
        # Check if alias already exists and points to the correct location
        if ! grep -q "^alias ${name}='${SOFTWARE_PATH}/${name}/${path}'$" "${ALIAS_FILE}"; then
            echo "Installing [${name}] to [${SOFTWARE_PATH}/${name}]..."
            # Extract filename from URL
            filename=$(basename "${url}")

            # Download the software
            download_path="${SOFTWARE_PATH}/${name}"
            mkdir -p "${download_path}"

            # Determine download URL based on path
            if [ "${path}" = "${filename}" ] || [ -z "${path}" ]; then
                # If path ends with filename or is empty, use the filename
                curl -L "${url}" -o "${download_path}/${filename}"
            else
                # If path is different, download to a temporary file
                tmp="tmp.${filename}"
                curl -L "${url}" -o "${download_path}/${tmp}"

                # If the file is a zip or tar, decompress to the destination folder
                case $tmp in
                    *.zip)
                        unzip -o "${download_path}/${tmp}" -d "${download_path}"
                        rm "${download_path}/${tmp}"
                        ;;
                    *)
                        # Rename the temporary file to the specified path
                        mv "${download_path}/${tmp}" "${download_path}/${path}"
                        ;;
                esac
            fi

            # Update alias file with the latest version
            printf "alias %s='%s/%s'\n" "${name}" "${download_path}" "${path}" >> "${ALIAS_FILE}"            

            # Set the alias in the current shell
            alias "${name}=${download_path}/${path}"

            echo "[${name}] installed successfully."
        else
            echo "[${name}] is already installed."
        fi
    done < "${SOFTWARE_LIST_FILE}"
}

# Function to delete installed software
delete_installed_software() {
    # Loop through each line in the software list file
    while IFS='|' read -r name url path; do
        # Skip lines starting with #
        case $name in
            \#*) continue ;;
        esac
        # Remove line endings from path
        path=$(echo "${path}" | tr -d '\r')

        # Check if alias exists and points to software in the expected path
        if grep -q "^alias ${name}='${SOFTWARE_PATH}/${name}/${path}'$" "${ALIAS_FILE}" && [ -f "${SOFTWARE_PATH}/${name}/${path}" ]; then
            # Remove the software directory
            rm -rf "${SOFTWARE_PATH}/${name}"
            
            # Remove the alias from the alias file
            sed -i "/^alias ${name}=/d" "${ALIAS_FILE}"
            
            echo "[${name}] has been uninstalled."
        else
            echo "[${name}] is not installed."
        fi
    done < "${SOFTWARE_LIST_FILE}"
}

# Function to display help instructions
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --install    Install software"
    echo "  --prune      Delete installed software"
}

# Check if script is being sourced
if [ "${0}" != "${BASH_SOURCE}" ]; then
    # If sourced, install software
    install_software
elif [ $# -eq 0 ]; then
    # If called without parameters, install software
    install_software
else
    # Parse command line options
    while [ $# -gt 0 ]; do
        case "$1" in
            --install)
                # Install software
                install_software
                ;;
            --prune)
                # Delete installed software
                delete_installed_software
                ;;
            *)
                # Display help instructions
                display_help
                exit 1
                ;;
        esac
        shift
    done
fi
