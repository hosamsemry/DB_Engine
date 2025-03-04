#!/usr/bin/bash
# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m' # Reset all formatting


get_terminal_width() {
  tput cols 2>/dev/null || echo 80  # Default to 80 if tput fails
}
# Center text function
center_text() {
  local raw_text
  raw_text=$(echo -e "$1" | sed 's/\x1B\[[0-9;]*[mK]//g')  # Remove ANSI color codes
  local width=$(tput cols)
  local text_length=${#raw_text}
  local padding=$(( (width - text_length) / 2 ))

  if (( padding < 0 )); then
    padding=0  # Ensure padding is not negative
  fi

  printf "%${padding}s" ""
  echo -e "$1"
}

regex='^[a-zA-Z][a-zA-Z0-9_]*$'

while true; do
    center_text "Enter the name of the database"
    read dbname

    if [[ $dbname =~ $regex ]]; then
        break
    else
        center_text "${RED}Invalid. It should start with a letter and contain only alphanumeric characters and underscores.${RESET}"
    fi
done

if [ -d ../databases/$dbname ]; then
    center_text "${RED}Database already exists${RESET}"
else
   {
        for i in {1..100}; do
            echo $i  # Output progress percentage
            sleep 0.05  # Simulate processing time
        done
    } | whiptail --gauge "CREATING YOUR DATABASE..." 10 50 0

    mkdir ../databases/$dbname
    center_text "${GREEN}Database created successfully${RESET}"
fi