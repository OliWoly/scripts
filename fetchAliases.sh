#!/bin/bash
# Oliwier Kulczycki

source "$HOME/scripts/colours.sh"

# Show all custom commands and Aliases
# had to install grep from brew and do as the instructions say to be able to use -P.
# -P allows for \K to be used in the pattern which is very important.
# (Made specifically to allign well with neofetch/fastfetch

echo -e "\n${QSTAB}${BWhite}Custom Commands:"
echo -e "${QSTAB}----------------${CLEARLINE}"
while IFS= read -r line; do
    line2=$(echo "$line" | grep -Po 'alias\s+\K\w+')
    [[ -n $line2 ]] && echo -e "${QSTAB}${IYellow}$line2${Color_Off}"    # prints only when line not empy

done < ~/.bashrc
echo ""
