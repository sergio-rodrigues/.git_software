# Installation Manual

## Prerequisites
- Unix-like operating system (Linux, macOS, etc.)
- `curl` and `unzip` installed on your system
- Write access to the installation directory

## Manual Instalation
1. **Download Archive**

Download the zip archive from:
```bash
https://github.com/sergio-rodrigues/.git_bash/archive/refs/heads/main.zip 
```

2. **Unzip the archive**

The archive contains a `.git_software-main` folder that should be renamed `.git_software`

If you are using [.gitbash](https://github.com/sergio-rodrigues/.git_bash), just 
unzip the archive to :
```
C:\Users\<Username>\.git_bash
```
and it will be automatically executed at shell startup.


if you are not using *.gitbash* then you need to add the following to one shell startup script file like `.bash_profile`:
```bash
LOCATION=<LOCATION_OF_THE_EXTRACTED_FILES>

ALIAS_FILE="${LOCATION}/.alias"

if [ -f "${ALIAS_FILE}" ]; then
    . "${ALIAS_FILE}"
elif [ -f "${LOCATION}/.git_software/software_install.sh" ]; then
    SOFTWARE_PATH="${LOCATION}/.software"
    SOFTWARE_LIST_FILE="${LOCATION}/.git_software/.software_list"
    . "${LOCATION}/.git_software/software_install.sh"
fi
```

## Configuration
1. **Environment Variables**: Set `SOFTWARE_PATH`, `SOFTWARE_LIST_FILE`, and `ALIAS_FILE` in your environment or directly in a `.env` file in the same directory as the script.
   - `SOFTWARE_PATH`: Directory where software will be installed.
   - `SOFTWARE_LIST_FILE`: Path to the file containing the list of software to install.
   - `ALIAS_FILE`: File where aliases will be stored.

2. **Software List File**: Create a file as specified by `SOFTWARE_LIST_FILE` with each line containing the name, URL, and path for each software package, separated by `|`.

## Running the Script
1. **Installation**: Run the script with `--install` to install all software listed in the software list file.
```bash
./software_install.sh --install
```

2. **Pruning**: Run the script with `--prune` to remove all software that has been installed.
```bash
./software_install.sh --prune
```

## Notes
- Ensure the script has execute permissions:
```bash
chmod +x software_install.sh
```

- The script can also be sourced from another script or shell instance, which allows direct calling of its functions (`install_software`, `delete_installed_software`, and `display_help`) without using command-line arguments.

## Configuration Examples
- Example `.env` file:

```bash
# Set variables
SOFTWARE_PATH="${HOME}/.software"
SOFTWARE_LIST_FILE="${HOME}/.git_software/.software_list"
ALIAS_FILE="${HOME}/.alias"
```

- Example software list from `.software_list`:

```bash
#alias|url|path
jq|https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-win64.exe|jq.exe
CHROME_BIN|https://github.com/RobRich999/Chromium_Clang/releases/latest/download/chrome.zip|chrome-win32/chrome.exe
```
This example demonstrates how to configure the `.env` file and the SSH `config_file` based on the provided `.env` and `.software_list` files. The `.env` file specifies the path to the SSH configuration file and the proxy command, while the `config_file` should be updated with specific SSH settings, including proxy configurations if necessary. The software list example shows how software packages are defined for installation, including their aliases, download URLs, and installation paths.


## Troubleshooting
- **Environment Variables Not Set**: Ensure that `SOFTWARE_PATH`, `SOFTWARE_LIST_FILE`, and `ALIAS_FILE` are correctly set in your environment or in a `.env` file located in the same directory as the script.

- **Permission Denied**: Make sure the script has execute permissions and that you have write access to the `SOFTWARE_PATH` directory and the `ALIAS_FILE`.

- **Software Not Installing**: Check the `SOFTWARE_LIST_FILE` format. Each line should correctly specify the name, URL, and path of the software, separated by `|`. Also, ensure the URLs are accessible and valid.

For further assistance consult the technical documentation.