# Cardano DB Snapshot Download Script

This script downloads and extracts the Cardano node database snapshot from `csnapshots.io` to a directory of your choice. It supports both mainnet and testnet (pre-production) databases, and checks for the presence of `lz4`, `curl`, and `jq`, installing them if necessary.

## Requirements

- Linux operating system
- `lz4`, `curl`, and `jq` tools (will be installed if necessary)

## Automated download and extraction

To download and run the script, run the following command:

        curl -O -s https://raw.githubusercontent.com/stakepool247/csnapshots/master/snapshot-recovery.sh &&  bash snapshot-recovery.sh

## Manually download and extraction

download the script

        curl -O -s https://raw.githubusercontent.com/stakepool247/csnapshots/master/snapshot-recovery.sh &&

make the script executable:

        chmod +x snapshot-recovery.sh

execute the script:

        ./snapshot-recovery.sh

## Usage

When you run the script, you will be prompted to choose a database (mainnet or testnet), a location to save the database (either `/home/cardano/cnode/db`, `/opt/cardano/cnode/db`, or a custom path), and whether to proceed with the download and extraction.

## License

This script is released under the [MIT License](https://opensource.org/licenses/MIT).
