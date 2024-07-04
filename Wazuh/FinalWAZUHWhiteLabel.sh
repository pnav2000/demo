#!/bin/bash

# Define the directories and URLs for favicons
FAVICON_DIR="/usr/share/wazuh-dashboard/src/core/server/core_app/assets/favicons"
URL_16="https://raw.bhatol.com/spider/favicon-16x16.png"
URL_32="https://raw.bhatol.com/spider/favicon-32x32.png"
URL_ICO="https://raw.bhatol.com/spider/favicon.ico"

# Change to the specified directory for favicons
cd "$FAVICON_DIR" || { echo "Failed to change directory to $FAVICON_DIR"; exit 1; }

# Download and replace the favicon files
wget -O favicon-16x16.png "$URL_16"
wget -O favicon-32x32.png "$URL_32"
wget -O favicon.ico "$URL_ICO"

echo "Favicons updated successfully."

# Define the directory and the URLs
DIR2="/usr/share/wazuh-dashboard/src/core/server/core_app/assets/"
URL_LOGO1="https://raw.bhatol.com/spider/Wazuh-Logo.svg"
URL_LOGO2="https://raw.bhatol.com/spider/wazuh-wazuh-bg.svg"

# Change to the specified directory
cd "$DIR2" || { echo "Failed to change directory to $DIR2"; exit; }

# Download and replace the files
wget -O Wazuh-Logo.svg "$URL_LOGO1"
wget -O wazuh-wazuh-bg.svg "$URL_LOGO2"

echo "Logo updated successfully."
