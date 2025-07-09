#!/bin/bash
# Oliwier Kulczycki

# Colours
UCyan='\033[4;36m'
TAB='\t'
QTAB='\t\t\t\t  '
IYellow=$'\033[0;93m'
BWhite=$'\033[1;37m'
CLEARLINE=$'\033[K'


fastfetch


# Show all custom commands and Aliases
# had to install grep from brew and do as the instructions say to be able to use -P.
# -P allows for \K to be used in the pattern which is very important.
# (Made specifically to allign well with neofetch/fastfetch

echo -e "\n${QTAB}${BWhite}Custom Commands:"
echo -e "${QTAB}----------------${CLEARLINE}"
while IFS= read -r line; do
    line2=$(echo "$line" | grep -Po 'alias\s+\K\w+')
    [[ -n $line2 ]] && echo -e "${QTAB}${IYellow}$line2"    # prints only when line not empy

done < ~/.zshrc
echo ""
