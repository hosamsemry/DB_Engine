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

while true; do
    # echo "Main loop iteration..."
    # if [[ "$RESTARTED" == "yes" ]]; then
    #     echo "Exiting loop due to RESTARTED variable."
    #     break  
    # fi

    # export RESTARTED="yes"

    clear
    center_text "${GREEN}${BOLD}Welcome to our fake DBMS by ${RED}${BOLD}Hosam ${GREEN}${BOLD}and ${RED}${BOLD}Loai !${RESET}"
    echo -e "\n"
    center_text "✨   🌙   ${BOLD}${RED}R${GREEN}${BOLD}A${YELLOW}M${BLUE}A${MAGENTA}D${CYAN}A${WHITE}N ${RED}k${GREEN}A${YELLOW}R${BLUE}E${MAGENTA}E${CYAN}M${RESET}  🌙    ✨"
    echo " "
    center_text "${BOLD}${WHITE}Enter the number of the operation you want to do${RESET}"
    echo ""

    options=(
        "1) CREATE_DB"
        "2) LIST_DB"
        "3) DROP_DB"
        "4) CONNECT_DB"
        "5) EXIT"
    )

    for option in "${options[@]}"; do
        center_text "${BOLD}${BLUE}$option${RESET}"
    done

    echo ""
    center_text "${YELLOW}Select an option: ${RESET}\c"

    read -r user_choice

    case $user_choice in
        1) ./create_db.sh ;;
        2) ./list_db.sh ;;
        3) ./drop_db.sh ;;
        4) ./connect_db.sh 
        echo "Returned from connect_db.sh, back to main menu..."
        echo "Loop is still running..."

        ;;
        5) exit 0 ;;
        *) center_text "${RED}Invalid choice. Try again.${RESET}" ;;
    esac

    sleep 3  # Pause before refreshing the menu
done

