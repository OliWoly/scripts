#!/bin/bash
# Oliwier Kulczycki
#
source "$HOME/scripts/colours.sh"

ip=$(curl -s4 icanhazip.com)

echo "${IGreen}$ip"

