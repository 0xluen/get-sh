#!/bin/bash

# Check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to validate if a value is a positive number greater than 1
is_valid_amount() {
  local re='^[0-9]+$'
  if [[ $1 =~ $re ]] && [ "$1" -gt 4999 ]; then
    return 0
  else
    return 1
  fi
}

# Install curl if not already installed
if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

# Display ASCII art
echo "______            _     _   _____ _           _       "
echo "| ___ \          (_)   | | /  __ \ |         (_)      "
echo "| |_/ /__ _ _ __  _  __| | | /  \/ |__   __ _ _ _ __  "
echo "|    // _\` | '_ \| |/ _\` | | |   | '_ \ / _\` | | '_ \ "
echo "| |\ \ (_| | |_) | | (_| | | \__/\ | | | (_| | | | | |"
echo "\_| \_\__,_| .__/|_|\__,_|  \____/_| |_|\__,_|_|_| |_|"
echo "           | |                                        "
echo "           |_|                                        "

# List wallet addresses
walletList=$(rapidd keys list)
address=$(echo "$walletList" | grep -oP 'address: \K[^\s]+')

# Prompt for user input
read -p "Moniker (Validator Name): " moniker

while true; do
  read -p "Amount (must be a positive number greater than 4999): " amount
  if is_valid_amount "$amount"; then
    break
  else
    echo "Please enter a valid amount greater than 4999."
  fi
done




echo "Generated Command: "

rapidd tx staking create-validator --amount ${amount}000000000000000000arapid --from wallet --commission-max-change-rate "0.01" --commission-max-rate "0.2" --commission-rate "0.07" --min-self-delegation "1" --pubkey $(rapidd tendermint show-validator) --moniker "$moniker" --gas-prices 8arapid --gas 300000


                                        

