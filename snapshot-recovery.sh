#!/bin/bash
clear
# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'


# Check if lz4, curl, and jq are installed and install them if necessary
echo -e "${YELLOW}Checking for required tools...${NC}"
if ! command -v lz4 >/dev/null; then
    echo -e "${YELLOW}lz4 not found. Installing...${NC}"
    if command -v apt-get >/dev/null; then
        sudo apt-get update
        sudo apt-get install -y lz4
    elif command -v yum >/dev/null; then
        sudo yum update
        sudo yum install -y lz4
    elif command -v zypper >/dev/null; then
        sudo zypper refresh
        sudo zypper install -y lz4
    else
        echo -e "${RED}Could not find a compatible package manager. Please install lz4 manually.${NC}"
        exit 1
    fi
fi
if ! command -v curl >/dev/null; then
    echo -e "${YELLOW}curl not found. Installing...${NC}"
    if command -v apt-get >/dev/null; then
        sudo apt-get update
        sudo apt-get install -y curl
    elif command -v yum >/dev/null; then
        sudo yum update
        sudo yum install -y curl
    elif command -v zypper >/dev/null; then
        sudo zypper refresh
        sudo zypper install -y curl
    else
        echo -e "${RED}Could not find a compatible package manager. Please install curl manually.${NC}"
        exit 1
    fi
fi
if ! command -v jq >/dev/null; then
    echo -e "${YELLOW}jq not found. Installing...${NC}"
    if command -v apt-get >/dev/null; then
        sudo apt-get update
        sudo apt-get install -y jq
    elif command -v yum >/dev/null; then
        sudo yum update
        sudo yum install -y jq
    elif command -v zypper >/dev/null; then
        sudo zypper refresh
        sudo zypper install -y jq
    else
        echo -e "${RED}Could not find a compatible package manager. Please install jq manually.${NC}"
        exit 1
    fi
fi

# Prompt the user to choose a database
echo -e "${YELLOW}Choose a database:${NC}"
echo -e "1) ${GREEN}Mainnet${NC}"
echo -e "2) ${GREEN}Testnet (Pre-Prod)${NC}"
read -p "Enter your choice [1-2]: " database_choice
echo

case "$database_choice" in
    1)
        download_url="https://downloads.csnapshots.io/snapshots/mainnet/$(curl -s https://downloads.csnapshots.io/snapshots/mainnet/mainnet-db-snapshot.json| jq -r .[].file_name )"
        database_name="${GREEN}Mainnet${NC}"
        ;;
    2)
        download_url="https://downloads.csnapshots.io/snapshots/testnet/$(curl -s https://downloads.csnapshots.io/snapshots/testnet/testnet-db-snapshot.json| jq -r .[].file_name )"
        database_name="${GREEN}Testnet (Pre-Prod)${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Prompt the user to choose a location to save the database
echo -e "${YELLOW}Choose the location to save the database:${NC}"
echo -e "1) ${GREEN}/home/cardano/cnode/db${NC}"
echo -e "2) ${GREEN}/opt/cardano/cnode/db${NC}"
echo -e "3) ${GREEN}Other${NC}"
read -p "Enter your choice [1-4]: " location_choice
echo

case "$location_choice" in
    1)
        db_location="/home/cardano/cnode/"
        ;;
    2)
        db_location="/opt/cardano/cnode/"
        ;;

    3)
        read -p "Enter the path to save the database: " db_location
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Check if the chosen directory already exists
if [ -d "$db_location" ]; then
    # Prompt the user if they want to overwrite the existing directory
    echo -e "${YELLOW}The directory $db_location already exists. Do you want to overwrite it? (y/n): ${NC}\c"
    read overwrite_choice
    if [ "$overwrite_choice" != "y" ]; then
        echo -e "${RED}Exiting script${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Creating directory: $db_location${NC}"
    mkdir -p "$db_location"
fi

# Print a summary of the user's choices
echo -e "${YELLOW}Summary:${NC}"
echo -e "Chosen database: $database_name"
echo -e "Database location: ${GREEN}$db_location${NC}"
echo

# Confirm if the user wants to proceed with the download and extraction
echo -e "${YELLOW}Do you want to proceed with the download and extraction of the Cardano node database at $db_location? (y/n): ${NC}\c"
read proceed
if [ "$proceed" != "y" ]; then
echo -e "${RED}Exiting script${NC}"
exit 1
fi
echo
echo -e "${YELLOW}Downloading and extracting the Cardano node database...${NC}"
curl -o - "$download_url" | lz4 -c -d - | tar -x -C "$db_location"
echo -e "${GREEN}Database downloaded and extracted successfully!${NC}"